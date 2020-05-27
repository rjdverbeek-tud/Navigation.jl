export midpoint, intermediate_point, destination_point, intersection_point,
max_latitude, opposite_point, closest_point_to_pole

"""
    midpoint(pos₁::Point, pos₂::Point)

Return the half-way point `midpoint` [deg] on the great circle line between
the positions `pos₁` and `pos₂` [deg] on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function midpoint(pos₁::Point, pos₂::Point)
    Δpos = pos₂ - pos₁
    Bx = cosd(pos₂.ϕ) * cosd(Δpos.λ)
    By = cosd(pos₂.ϕ) * sind(Δpos.λ)
    ϕₘ = atand(sind(pos₁.ϕ) + sind(pos₂.ϕ), √((cosd(pos₁.ϕ) + Bx)^2 + By^2))
    λₘ = pos₁.λ + atand(By, cosd(pos₁.ϕ) + Bx)
    return normalize(Point(ϕₘ, λₘ))
end

"""
    midpoint(section::RouteSection)

Return the half-way point `midpoint` [deg] on the route section on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
midpoint(section::RouteSection) = midpoint(section.pos₁, section.pos₂)

"""
    intermediate_point(pos₁::Point, pos₂::Point[, fraction::Float64 = 0.5])

Return the `intermediate_point` [deg] at any `fraction` along the great circle
path between two points with positions `pos₁` and `pos₂` [deg]. The fraction along the
great circle route is such that `fraction` = 0.0 is at `pos₁` [deg] and `fraction` 1.0
is at `pos₂` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function intermediate_point(pos₁::Point, pos₂::Point, fraction::Float64 = 0.5)
    δ = angular_distance(pos₁, pos₂)
    a = sind((1.0 - fraction) * δ) / sind(δ)
    b = sind(fraction * δ) / sind(δ)
    x = a * cosd(pos₁.ϕ) * cosd(pos₁.λ) + b * cosd(pos₂.ϕ) * cosd(pos₂.λ)
    y = a * cosd(pos₁.ϕ) * sind(pos₁.λ) + b * cosd(pos₂.ϕ) * sind(pos₂.λ)
    z = a * sind(pos₁.ϕ) + b * sind(pos₂.ϕ)
    ϕᵢ = atand(z, √(x*x + y*y))
    λᵢ = atand(y, x)
    return Point(ϕᵢ, λᵢ)
end

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

Given a `start_pos` [deg], initial `bearing` (clockwise from North) [deg],
`distance` [m], and the earth `radius` [m] calculate the `destina­tion_point`
[deg] travelling along a (shortest distance) great circle arc.
(The distance must use the same radius as the radius of the earth.)

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function destination_point(start_pos::Point, distance::Float64,
    bearing::Float64, radius::Float64=Rₑ_m)
    δ = rad2deg(distance / radius)  # Angular distance
    ϕ₂ = asind(sind(start_pos.ϕ) * cosd(δ) + cosd(start_pos.ϕ) * sind(δ) *
    cosd(bearing))
    λ₂ = start_pos.λ + atand(sind(bearing) * sind(δ) * cosd(start_pos.ϕ),
    cosd(δ) - sind(start_pos.ϕ) * sind(ϕ₂))
    return Point(ϕ₂, λ₂)
end

"""
    intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64, bearing₂₃::Float64)

Return the intersection point `pos₃` [deg] of two great circle paths given two
start points [deg] `pos₁` and `pos₂` [deg] and two bearings [deg] from `pos₁` to
`pos₃` [deg], and from `pos₂` to `pos₃` [deg].

Under certain circumstances the results can be an ∞ or *ambiguous solution*.

Source: edwilliams.org/avform.htm
"""
function intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64,
    bearing₂₃::Float64)
    Δpos = pos₂ - pos₁
    δ₁₂ = 2asind(√(sind(Δpos.ϕ / 2)^2 + cosd(pos₁.ϕ) * cosd(pos₂.ϕ) * sind(Δpos.λ/2)^2))
    if sind(δ₁₂) * cosd(pos₁.ϕ) == 0.0 || sind(δ₁₂) * cosd(pos₂.ϕ) == 0.0
        return Point(NaN, NaN)
    end
    θₐ = acosd((sind(pos₂.ϕ) - sind(pos₁.ϕ) * cosd(δ₁₂)) / (sind(δ₁₂) * cosd(pos₁.ϕ)))
    θᵦ = acosd((sind(pos₁.ϕ) - sind(pos₂.ϕ) * cosd(δ₁₂)) / (sind(δ₁₂) * cosd(pos₂.ϕ)))
    local θ₁₂, θ₂₁
    if sind(Δpos.λ) > 0.0
        θ₁₂ = θₐ
        θ₂₁ = 360.0 - θᵦ
    else
        θ₁₂ = 360.0 - θₐ
        θ₂₁ = θᵦ
    end
    α₁ = (bearing₁₃ - θ₁₂ + 180.0)%(360.0) - 180.0
    α₂ = (θ₂₁ - bearing₂₃ + 180.0)%(360.0) - 180.0

    if sind(α₁) ≈ 0.0 && sind(α₂) ≈ 0.0
        return Point(Inf, Inf)  # infinity of intersections
    elseif sind(α₁) * sind(α₂) < 0.0
        # return Point_rad(Inf, Inf)  # intersection ambiguous
        return Point(NaN, NaN)
    else
        α₃ = acosd(-cosd(α₁) * cosd(α₂) + sind(α₁) * sind(α₂) * cosd(δ₁₂))
        δ₁₃ = atand(sind(δ₁₂) * sind(α₁) * sind(α₂), cosd(α₂) + cosd(α₁) * cosd(α₃))
        ϕ₃ = asind(sind(pos₁.ϕ) * cosd(δ₁₃) + cosd(pos₁.ϕ) * sind(δ₁₃) * cosd(bearing₁₃))
        Δλ₁₃ = atand(sind(bearing₁₃) * sind(δ₁₃) * cosd(pos₁.ϕ), cosd(δ₁₃)
        - sind(pos₁.ϕ) * sind(ϕ₃))
        λ₃ = pos₁.λ + Δλ₁₃
        return Point(ϕ₃, λ₃)
    end
end

function intersection_point(pos₁::Point, pos₂::Point, pos₃::Point, pos₄::Point)
    inter_pnt = intersection_point(pos₁, pos₃, bearing(pos₁, pos₂),
    bearing(pos₃, pos₄))
    if isinf(inter_pnt.ϕ)
        return inter_pnt
    elseif distance(pos₁, pos₂) + tolerance_m ≥ distance(pos₁, inter_pnt) &&
        distance(pos₃, pos₄) + tolerance_m ≥ distance(pos₃, inter_pnt)
        return inter_pnt
    else
        return Point(NaN, NaN)
    end
end

"""
    intersection_point(pos₁::Point, pos₂::Point, polygon::Vector{Point{Float64}})

Return the intersection point `pos₃` [deg] of a great circle section with a
polygon. The great circle section is defined by two points [deg] `pos₁` and
`pos₂` [deg].
"""
function intersection_point(pos₁::Point, pos₂::Point,
    polygon::Vector{Point{Float64}})
    min_distance = Inf
    inter_point = Point(NaN, NaN)
    current_point = Point(NaN, NaN)
    poly₁ = polygon[1]
    for poly₂ in polygon[2:end]
        current_point = intersection_point(pos₁, pos₂, poly₁, poly₂)
        if current_point.ϕ ∉ [Inf, NaN]
            current_distance = distance(pos₁, current_point)
            if min_distance > current_distance
                min_distance = current_distance
                inter_point = current_point
            end
        end
        poly₁ = poly₂
    end
    return inter_point
end

"""
    intersection_point(pos₁::Point, pos₂::Point, airspace::Airspace)

Return the intersection point `pos₃` [deg] of a great circle section with an
`Airspace`. The great circle section is defined by two points [deg] `pos₁` and
`pos₂` [deg].
"""
function intersection_point(pos₁::Point, pos₂::Point,
    airspace::Airspace)
    inter_point = Point(NaN, NaN)
    if isinside(pos₁, airspace.bounding_box) ||
        isinside(pos₂, airspace.bounding_box)
        inter_point = intersection_point(pos₁, pos₂, airspace.polygon)
    else
        inter_box_point = intersection_point(pos₁, pos₂, airspace.bounding_box)
        if !isnan(inter_box_point.ϕ)
            inter_point = intersection_point(pos₁, pos₂, airspace.polygon)
        end
    end
    return inter_point
end

#TODO Source for longitude
"""
closest_point_to_pole(starting_point::Point, bearing::Float64)

Given a `starting_point` [deg] and initial `bearing` [deg] calculate the
closest point [deg] to the next pole encountered.

Source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function closest_point_to_pole(starting_point::Point, bearing::Float64)
    pnt = normalize(starting_point)
    brg = normalize(bearing, -180.0, 180.0)
    max_lat = max_latitude(pnt.ϕ, brg)
    max_lon = pnt.λ + atand(1.0, tand(brg)sind(pnt.ϕ))
    return normalize(Point(max_lat*(-90.0≤brg≤90.0 ? 1.0 : -1.0),
    max_lon-180.0*(brg<0.0)))
end

"""
max_latitude(latitude::Float64, bearing::Float64)

Using Clairaut's formula it is possible to calculate the maximum latitude [deg]
of a great circle path, given a `bearing` [deg] and `latitude` [deg] on the
great circle.

The minimum latitude is -max_latitude

Source: https://www.movable-type.co.uk/scripts/latlong.html
"""
function max_latitude(latitude::Float64, bearing::Float64)
    return acosd(abs(sind(bearing)cosd(latitude)))
end

"""
opposite_point(point::Point)

The point at the opposite site of the Sphere.
"""
function opposite_point(point::Point)
    normalize(Point(-point.ϕ, point.λ+180.0))
end
