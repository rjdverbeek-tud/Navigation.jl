export midpoint, intermediate_point, destination_point, intersection_point

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
        return Point_rad(Inf, Inf)  # intersection ambiguous
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
