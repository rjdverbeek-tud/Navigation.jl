export midpoint, intermediate_point, destination_point, intersection_point,
max_latitude_rad, max_latitude_deg, opposite_point, closest_point_to_pole

"""
    midpoint(pos₁::Point, pos₂::Point)

Return the half-way point `midpoint` (Point) on the great circle line between
the positions `pos₁` and `pos₂` on a sphere.

Point = Navigation.Point_deg or Navigation.Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function midpoint(pos₁::Point_rad, pos₂::Point_rad)
    Δpos = pos₂ - pos₁
    Bx = cos(pos₂.ϕ) * cos(Δpos.λ)
    By = cos(pos₂.ϕ) * sin(Δpos.λ)
    ϕₘ = atan(sin(pos₁.ϕ) + sin(pos₂.ϕ), √((cos(pos₁.ϕ) + Bx)^2 + By^2))
    λₘ = pos₁.λ + atan(By, cos(pos₁.ϕ) + Bx)
    return normalize(Point_rad(ϕₘ, λₘ))
end

midpoint(pos₁::Point_deg, pos₂::Point_deg) = rad2deg(midpoint(deg2rad(pos₁),
deg2rad(pos₂)))

"""
    midpoint(section::RouteSection)

Return the half-way point `midpoint` (Point) on the route section on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
midpoint(section::RouteSection) = midpoint(section.pos₁, section.pos₂)

"""
    intermediate_point(pos₁::Point, pos₂::Point[, fraction::Float64 = 0.5])

Return the `intermediate_point` (Point) at any `fraction` along the great circle
path between two points with positions `pos₁` and `pos₂`. The fraction along the
great circle route is such that `fraction` = 0.0 is at `pos₁` and `fraction` 1.0
is at `pos₂`.

Point = Navigation.Point_deg or Navigation.Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function intermediate_point(pos₁::Point_rad, pos₂::Point_rad,
    fraction::Float64 = 0.5)
    δ = distance(pos₁, pos₂) / Rₑ_m
    a = sin((1.0 - fraction) * δ) / sin(δ)
    b = sin(fraction * δ) / sin(δ)
    x = a * cos(pos₁.ϕ) * cos(pos₁.λ) + b * cos(pos₂.ϕ) * cos(pos₂.λ)
    y = a * cos(pos₁.ϕ) * sin(pos₁.λ) + b * cos(pos₂.ϕ) * sin(pos₂.λ)
    z = a * sin(pos₁.ϕ) + b * sin(pos₂.ϕ)
    ϕᵢ = atan(z, √(x*x + y*y))
    λᵢ = atan(y, x)
    return Point_rad(ϕᵢ, λᵢ)
end

intermediate_point(pos₁::Point_deg, pos₂::Point_deg, fraction::Float64 = 0.5) =
rad2deg(intermediate_point(deg2rad(pos₁), deg2rad(pos₂), fraction))

"""
    intermediate_point(section::RouteSection [, fraction::Float64 = 0.5])

Return the `intermediate_point` (Point) at any `fraction` along the route
section. The fraction along the great circle route is such that `fraction` =
0.0 is at `pos₁` and `fraction` 1.0 is at `pos₂`.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
intermediate_point(section::RouteSection, fraction::Float64 = 0.5) =
intermediate_point(section.pos₁, section.pos₂, fraction)

"""
    destination_point(start_pos::Point, distance::Float64, bearing::Float64[,
     radius::Float64=Rₑ_m])

Given a `start_pos` (Point), initial `bearing` (clockwise from North),
`distance` [m], and the earth `radius` [m] calculate the `destina­tion_point`
(Point) travelling along a (shortest distance) great circle arc.
(The distance must use the same radius as the radius of the earth.)

Point = Navigation.Point_deg or Navigation.Point_rad
(if Point_deg then the initial bearing must also be in degrees,
and if Point_rad then the intial bearing must be in radians)

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function destination_point(start_pos::Point_rad, distance::Float64,
    bearing::Float64, radius::Float64=Rₑ_m)
    δ = distance / radius  # Angular distance
    ϕ₂ = asin(sin(start_pos.ϕ) * cos(δ) + cos(start_pos.ϕ) * sin(δ) *
    cos(bearing))
    λ₂ = start_pos.λ + atan(sin(bearing) * sin(δ) * cos(start_pos.ϕ),
    cos(δ) - sin(start_pos.ϕ) * sin(ϕ₂))
    return Point_rad(ϕ₂, λ₂)
end

destination_point(start_pos::Point_deg, distance::Float64, bearing::Float64,
radius::Float64=Rₑ_m) = rad2deg(destination_point(deg2rad(start_pos), distance,
deg2rad(bearing), radius))

"""
    intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64,
    bearing₂₃::Float64)

Return the intersection point `pos₃` (Point) of two great circle paths given two
start points (Point) `pos₁` and `pos₂` and two bearings from `pos₁` to
`pos₃`, and from `pos₂` to `pos₃`.

Point = Navigation.Point_deg or Navigation.Point_rad
(if Point_deg then the initial bearings must also be in degrees,
and if Point_rad then the intial bearings must be in radians)

Under certain circumstances the results can be an ∞ or ambiguous solution.

Source: edwilliams.org/avform.htm
"""
function intersection_point(pos₁::Point_rad, pos₂::Point_rad, bearing₁₃::Float64,
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
        return Point_rad(Inf, Inf)  # infinity of intersections
    elseif sin(α₁) * sin(α₂) < 0.0
        # return Point_rad(Inf, Inf)  # intersection ambiguous
        return Point_rad(NaN, NaN)
    else
        α₃ = acos(-cos(α₁) * cos(α₂) + sin(α₁) * sin(α₂) * cos(δ₁₂))
        δ₁₃ = atan(sin(δ₁₂) * sin(α₁) * sin(α₂), cos(α₂) + cos(α₁) * cos(α₃))
        ϕ₃ = asin(sin(pos₁.ϕ) * cos(δ₁₃) + cos(pos₁.ϕ) * sin(δ₁₃) * cos(bearing₁₃))
        Δλ₁₃ = atan(sin(bearing₁₃) * sin(δ₁₃) * cos(pos₁.ϕ), cos(δ₁₃)
        - sin(pos₁.ϕ) * sin(ϕ₃))
        λ₃ = pos₁.λ + Δλ₁₃
        return Point_rad(ϕ₃, λ₃)
    end
end

intersection_point(pos₁::Point_deg, pos₂::Point_deg, bearing₁₃::Float64,
bearing₂₃::Float64) = rad2deg(intersection_point(deg2rad(pos₁), deg2rad(pos₂),
deg2rad(bearing₁₃), deg2rad(bearing₂₃)))

function intersection_point(pos₁::Point_rad, pos₂::Point_rad, pos₃::Point_rad,
    pos₄::Point_rad)
    inter_pnt = intersection_point(pos₁, pos₃, bearing(pos₁, pos₂),
    bearing(pos₃, pos₄))
    if distance(pos₁, pos₂) ≥ distance(pos₁, inter_pnt) && distance(pos₃, pos₄) ≥ distance(pos₃, inter_pnt)
        return inter_pnt
    else
        return Point_rad(NaN, NaN)
    end
end

intersection_point(pos₁::Point_deg, pos₂::Point_deg, pos₃::Point_deg,
    pos₄::Point_deg) = rad2deg(intersection_point(deg2rad(pos₁), deg2rad(pos₂),
    deg2rad(pos₃), deg2rad(pos₄)))

function intersection_point(pos₁::Point_deg, pos₂::Point_deg, airspace::Airspace)
    println(airspace.bounding_box)
end

"""
closest_point_to_pole(point::Point_rad, bearing_rad::Float64)
closest_point_to_pole(point::Point_deg, bearing_deg::Float64)

Given a starting point [Point_rad] and initial bearing [rad] calculate the
closest point to the next pole encountered.

Source: https://www.movable-type.co.uk/scripts/latlong.html
#TODO Source for longitude
"""
function closest_point_to_pole(point_rad::Point_rad, bearing_rad::Float64)
    pnt = normalize(point_rad)
    brg = normalize(bearing_rad, -1.0*π, 1.0*π)
    max_lat = max_latitude_rad(pnt.ϕ, brg)
    max_lon = pnt.λ + atan(1.0, tan(brg)sin(pnt.ϕ))
    # println(brg, " ", max_lon-π*(brg<0.0))
    return normalize(Point_rad(max_lat*(-π*0.5≤brg≤π*0.5 ? 1.0 : -1.0),
    max_lon-π*(brg<0.0)))
end

closest_point_to_pole(point::Point_deg, bearing_deg::Float64) =
rad2deg(closest_point_to_pole(deg2rad(point), deg2rad(bearing_deg)))

"""
max_latitude_rad(lat_rad::Float64, bearing_rad::Float64)

Using Clairaut's formula it is possible to calculate the maximum latitude
of a great circle path, give a bearing `bearing_rad` [rad] and latitude
`lat_rad` [rad] on the great circle.

The minimum latitude is -max_latitude_rad

Source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function max_latitude_rad(lat_rad::Float64, bearing_rad::Float64)
    return acos(abs(sin(bearing_rad)cos(lat_rad)))
end

"""
max_latitude_deg(lat_deg::Float64, bearing_deg::Float64)

Using Clairaut's formula it is possible to calculate the maximum latitude
of a great circle path, give a bearing `bearing_deg` [deg] and latitude
`lat_deg` [deg] on the great circle.

The minimum latitude is -max_latitude_deg

Source: https://www.movable-type.co.uk/scripts/latlong.html
"""
max_latitude_deg(lat_deg::Float64, bearing_deg::Float64) = rad2deg(max_latitude_rad(
deg2rad(lat_deg), deg2rad(bearing_deg)))

"""
opposite_point(point::Point_rad)
opposite_point(point::Point_deg)

The point at the opposite site of the Earth.
"""
function opposite_point(point::Point_rad)
    normalize(Point_rad(-point.ϕ, point.λ+π))
end

opposite_point(point::Point_deg) = rad2deg(opposite_point(deg2rad(point)))
