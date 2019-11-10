"""
Calculate distances, angles, speeds and points for aviation navigation purposes.

All angles are in radians, distances are standard in meters, and speeds are
standard in m/s.

These methods are not to be used for operational purposes.

Implemented Functions:
* distance
* bearing
* final_bearing
* midpoint
* intermediate_point
* destination_point
* intersection_point
* along_track_distance
* Vground
* head_wind
* cross_wind
* normalize

Implemented Types:
* Point(ϕ, λ)

Implemented constants:
* Rₑ    Radius Earth in [m]

Based on
source: https://www.movable-type.co.uk/scripts/latlong.html
source: http://edwilliams.org/avform.htm
"""
module Navigation

import Base.-, Base.Math.rad2deg, Base.Math.deg2rad

export Point, distance, bearing, final_bearing, midpoint,
intermediate_point, Vground, destination_point, intersection_point,
cross_track_distance, along_track_distance, head_wind, cross_wind

"""
Radius Earth [m]
https://en.wikipedia.org/wiki/Earth_radius
"""
const Rₑ = 6371008.7714

"Point type with latitude ϕ [rad] and longitude λ [rad]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"""
"""
# function normalize_angle(angle::Float64)
#     return (angle + 2.0*π)
# end

"""
distance(pos₁::Point, pos₂::Point, radius::Float64=Rₑ)

Distance (=[Rₑ]) on a sphere calculated using the haversine formula
The haversine gives also good estimations at short distances

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function distance(pos₁::Point, pos₂::Point, radius::Float64=Rₑ)
    Δpos = pos₂ - pos₁
    a = sin(Δpos.ϕ/2.0)^2 + cos(pos₁.ϕ)*cos(pos₂.ϕ)*sin(Δpos.λ/2.0)^2
    c = 2.0 * atan(√a, √(1.0 - a))
    return radius * c
end

"""
bearing(pos₁::Point, pos₂::Point)

Initial bearing [rad] of the great circle line between the positions 1
(Point) and 2 (Point) on a sphere

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function bearing(pos₁::Point, pos₂::Point)
    Δpos = pos₂ - pos₁
    return mod2pi(atan(sin(Δpos.λ)*cos(pos₂.ϕ)
                ,cos(pos₁.ϕ)*sin(pos₂.ϕ) - sin(pos₁.ϕ)*cos(pos₂.ϕ)*cos(Δpos.λ)))
end

"""
final_bearing(pos₁::Point, pos₂::Point)

Final bearing [rad] of the great circle line between the positions 1
(Point) and 2 (Point) on a sphere

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function final_bearing(pos₁::Point, pos₂::Point)
    return mod2pi(bearing(pos₂, pos₁) + π)
end

"""
midpoint(pos₁::Point, pos₂::Point)

The half-way point (Point) on a great circle path between two points (Point)

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function midpoint(pos₁::Point, pos₂::Point)
    Δpos = pos₂ - pos₁
    Bx = cos(pos₂.ϕ) * cos(Δpos.λ)
    By = cos(pos₂.ϕ) * sin(Δpos.λ)
    ϕₘ = atan(sin(pos₁.ϕ) + sin(pos₂.ϕ), √((cos(pos₁.ϕ) + Bx)^2 + By^2))
    λₘ = pos₁.λ + atan(By, cos(pos₁.ϕ) + Bx)
    return Point(ϕₘ, normalize(λₘ, -π, Float64(π)))
end

"""
intermediate_point(pos₁::Point, pos₂::Point, fraction::Float64 = 0.5)

An intermediate point (Point) at any fraction along the great circle path
between two points 1 (Point) and 2 (Point). The fraction along the great circle
route is such that fraction = 0.0 is at point 1 and fraction 1.0 is at point 2.

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function intermediate_point(pos₁::Point, pos₂::Point, fraction::Float64 = 0.5)
    δ = distance(pos₁, pos₂) / Rₑ
    a = sin((1.0 - fraction) * δ) / sin(δ)
    b = sin(fraction * δ) / sin(δ)
    x = a * cos(pos₁.ϕ) * cos(pos₁.λ) + b * cos(pos₂.ϕ) * cos(pos₂.λ)
    y = a * cos(pos₁.ϕ) * sin(pos₁.λ) + b * cos(pos₂.ϕ) * sin(pos₂.λ)
    z = a * sin(pos₁.ϕ) + b * sin(pos₂.ϕ)
    ϕᵢ = atan(z, √(x*x + y*y))
    λᵢ = atan(y, x)
    return Point(ϕᵢ, λᵢ)
end

"""
destination_point(start_pos::Point, distance::Float64, bearing::Float64
, radius::Float64=Rₑ)

Given a start point (Point), initial bearing [rad] (clockwise from North),
distance (=[Rₑ]), and the earth radius (Rₑ) calculate the destina­tion point
(Point) travelling along a (shortest distance) great circle arc.
(The distance must use the same radius as the radius of the earth.)

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function destination_point(start_pos::Point, distance::Float64, bearing::Float64,
    radius::Float64=Rₑ)
    δ = distance / radius  # Angular distance
    ϕ₂ = asin(sin(start_pos.ϕ) * cos(δ) + cos(start_pos.ϕ) * sin(δ) * cos(bearing))
    λ₂ = start_pos.λ + atan(sin(bearing) * sin(δ) * cos(start_pos.ϕ),
    cos(δ) - sin(start_pos.ϕ) * sin(ϕ₂))
    return Point(ϕ₂, λ₂)
end

"""
intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64, bearing₂₃::Float64)

The intersection point pos₃ (Point) of two great circle paths given two start
points (Point) pos₁ and pos₂ and two bearings [rad] from pos₁ to pos₃, and from
pos₂ to pos₃.

Under certain circumstances the results can be an infinite or ambiguous solution.

source: http://edwilliams.org/avform.htm
"""
function intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64,
    bearing₂₃::Float64)
    Δpos = pos₂ - pos₁
    δ₁₂ = 2asin(√(sin(Δpos.ϕ / 2)^2 + cos(pos₁.ϕ) * cos(pos₂.ϕ) * sin(Δpos.λ/2)^2))
    θₐ = acos((sin(pos₂.ϕ) - sin(pos₁.ϕ) * cos(δ₁₂)) / (sin(δ₁₂) * cos(pos₁.ϕ)))
    θᵦ = acos((sin(pos₁.ϕ) - sin(pos₂.ϕ) * cos(δ₁₂)) / (sin(δ₁₂) * cos(pos₂.ϕ)))
    local θ₁₂, θ₂₁
    if sin(Δpos.λ) > 0.0
        θ₁₂ = θₐ
        θ₂₁ = 2π - θᵦ
    else
        θ₁₂ = 2π - θₐ
        θ₂₁ = θᵦ
    end
    α₁ = (bearing₁₃ - θ₁₂ + π)%(2π) - π
    α₂ = (θ₂₁ - bearing₂₃ + π)%(2π) - π

    if sin(α₁) ≈ 0.0 && sin(α₂) ≈ 0.0
        return Point(Inf, Inf)  # infinity of intersections
    elseif sin(α₁) * sin(α₂) < 0.0
        return Point(Inf, Inf)  # intersection ambiguous
    else
        α₃ = acos(-cos(α₁) * cos(α₂) + sin(α₁) * sin(α₂) * cos(δ₁₂))
        δ₁₃ = atan(sin(δ₁₂) * sin(α₁) * sin(α₂), cos(α₂) + cos(α₁) * cos(α₃))
        ϕ₃ = asin(sin(pos₁.ϕ) * cos(δ₁₃) + cos(pos₁.ϕ) * sin(δ₁₃) * cos(bearing₁₃))
        Δλ₁₃ = atan(sin(bearing₁₃) * sin(δ₁₃) * cos(pos₁.ϕ), cos(δ₁₃)
        - sin(pos₁.ϕ) * sin(ϕ₃))
        λ₃ = pos₁.λ + Δλ₁₃
        return Point(ϕ₃, λ₃)
    end
end

"""
cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point, radius::Float64=Rₑ)

Cross-track distance from a point pos₃ (Point) to a great circle path defined
by the points pos₁ and pos₂ (Point).

cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point, radius::Float64=Rₑ)

Cross-track distance from a point pos₃ (Point) to a great circle path defined
by the point pos₁ and bearing [rad].

cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64, radius::Float64=Rₑ)

Cross-track distance from a point pos₃ to a great circle path. The distance is
calculated using the angular distance between points pos₁ and pos₃ (Point),
the bearing [rad] between points pos₁ and pos₃ (Point), the bearing [rad]
between points pos₁ and pos₂ (Point), and the radius of the earth.

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point,
    radius::Float64=Rₑ)
    ∠distance₁₃ = distance(pos₁, pos₃ , radius) / radius
    bearing₁₃ = bearing(pos₁, pos₃)
    bearing₁₂ = bearing(pos₁, pos₂)
    return cross_track_distance(∠distance₁₃, bearing₁₂, bearing₁₃, radius)
end

function cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point,
    radius::Float64=Rₑ)
    pos₂ = destination_point(pos₁, radius, bearing, radius)
    return cross_track_distance(pos₁, pos₂, pos₃, radius)
end

function cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64, radius::Float64=Rₑ)
    return asin(sin(∠distance₁₃) * sin(bearing₁₃ - bearing₁₂)) * radius
end

"""
along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point, radius::Float64=Rₑ)

The along-track distance from the start point pos₁ (Point) to the closest point
on the great circle path (defined by points pos₁ and pos₂ (Point)) to the point
pos₃ (Point). The radius of the earth can also be given.

along_track_distance(∠distance₁₃::Float64, cross_track_∠distance::Float64, radius::Float64=Rₑ)

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point,
    radius::Float64=Rₑ)
    ∠distance₁₃ = distance(pos₁, pos₃, radius)
    cross_track_∠distance = cross_track_distance(pos₁, pos₂, pos₃, radius) / radius
    return along_track_distance(∠distance₁₃, cross_track_∠distance, radius)
end

function along_track_distance(∠distance₁₃::Float64,
    cross_track_∠distance::Float64, radius::Float64=Rₑ)
    return acos(cos(∠distance₁₃) / cos(cross_track_∠distance)) * radius
end

"""
Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)

Ground speed (=[Vtas]) given the course [rad], airspeed,
wind speed (=[Vtas]) and wind direction [rad]. The speeds need to use the same
speed unit.

source: http://edwilliams.org/avform.htm
"""
function Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)
    swc = (Vwind / Vtas) * sin(∠wind - course)
    return Vtas * √(1-swc*swc) - Vwind * cos(∠wind - course)
end

"""
head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Head-wind component. A tail-wind is a negative head-wind.
"""
function head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*cos(∠wind - course)
end

"""
cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Cross-wind component. A positive cross-wind component indicates a wind from the
right.
"""
function cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*sin(∠wind - course)
end

"""
normalize(value::Float64, lower::Float64 = 0.0, upper::Float64 = 360.0)

Normalize a value to stay within the lower and upper limit:
normalize(370.0, lower=0.0, upper=360.0)
10.0
"""
function normalize(value::Float64, lower::Float64 = 0.0, upper::Float64 = 360.0)
    result = value
    if result > upper || value == lower
        value = lower + abs(value + upper) % (abs(lower) + abs(upper))
    end
    if result < lower || value == upper
        value = upper - abs(value - lower) % (abs(lower) + abs(upper))
    end
    value == upper ? result = lower : result = value
    return result
end

#TODO Closest point to the poles
#TODO Crossing parallels
#TODO Rhumb lines

end # module
