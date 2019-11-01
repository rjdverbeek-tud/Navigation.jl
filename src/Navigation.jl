module Navigation

"""
Calculate distances, and angles for navigation

Based on
source: https://www.movable-type.co.uk/scripts/latlong.html
source: http://edwilliams.org/avform.htm
"""

import Base.-, Base.Math.rad2deg, Base.Math.deg2rad

export Point, distance, bearing, final_bearing, midpoint,
intermediate_point, Vground

"""
Radius Earth in [m]
https://en.wikipedia.org/wiki/Earth_radius
"""
const Rₑ = 6371008.7714

"Point type with latitude ϕ and longitude λ in radians"
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

Distance on a sphere calculated using the haversine formula
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

Initial bearing of the great circle line between the positions 1
and 2 on a sphere

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function bearing(pos₁::Point, pos₂::Point)
    Δpos = pos₂ - pos₁
    return mod2pi(atan(sin(Δpos.λ)*cos(pos₂.ϕ)
                ,cos(pos₁.ϕ)*sin(pos₂.ϕ) - sin(pos₁.ϕ)*cos(pos₂.ϕ)*cos(Δpos.λ)))
end

"""
final_bearing(pos₁::Point, pos₂::Point)

Final bearing of the great circle line between the positions 1
and 2 on a sphere

source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function final_bearing(pos₁::Point, pos₂::Point)
    return mod2pi(bearing(pos₂, pos₁) + π)
end

"""
midpoint(pos₁::Point, pos₂::Point)

The half-way point on a great circle path between two points

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

An intermediate point at any fraction along the great circle path between two
points 1 and 2. The fraction along the great circle route is such that fraction = 0.0
is at point 1 and fraction 1.0 is at point 2.

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
Ground speed given the course (in radians), airspeed, wind speed and
wind direction (in radians). The speeds need to use the same speed unit.
"""
function Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)
    swc = (Vwind / Vtas) * sin(∠wind - course)
    return Vtas * √(1-swc*swc) - Vwind * cos(∠wind - course)
end

"""
Normalize a value to stay within the lower and upper limit
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

#TODO Destination point given distance and bearing from start point
#TODO Intersectino of two paths given start points and bearings
#TODO Cross-track distance
#TODO Closest point to the poles

end # module
