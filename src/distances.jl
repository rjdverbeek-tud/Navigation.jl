export distance, cross_track_distance, along_track_distance

"""
    distance(pos₁::Point, pos₂::Point[, radius::Float64=Rₑ_m])

Return the `distance` in [m] of the great circle line between the positions `pos₁`
and `pos₂` on a sphere, with a given `radius`, calculated using the haversine
formula. The haversine gives also good estimations at short distances.

Point = Point_deg or Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function distance(pos₁::Point_rad, pos₂::Point_rad, radius::Float64=Rₑ_m)
    Δpos = pos₂ - pos₁
    a = sin(Δpos.ϕ/2.0)^2 + cos(pos₁.ϕ)*cos(pos₂.ϕ)*sin(Δpos.λ/2.0)^2
    c = 2.0 * atan(√a, √(1.0 - a))
    return radius * c
end

distance(pos₁::Point_deg, pos₂::Point_deg, radius::Float64=Rₑ_m) = distance(
deg2rad(pos₁), deg2rad(pos₂), radius)

"""
    distance(section::RouteSection [, radius::Float64=Rₑ_m])

Return the `distance` in [m] of the great circle line on the route section on a
sphere, with a given `radius`, calculated using the haversine formula. The
haversine gives also good estimations at short distances.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
distance(section::RouteSection, radius::Float64=Rₑ_m) = distance(section.pos₁,
section.pos₂, radius)

"""
    cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` (Point) to a great
circle path defined by the points `pos₁` and `pos₂` (Point).

Point = Point_deg or Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(pos₁::Point_rad, pos₂::Point_rad, pos₃::Point_rad,
    radius::Float64=Rₑ_m)
    ∠distance₁₃ = distance(pos₁, pos₃ , radius) / radius
    bearing₁₃ = bearing(pos₁, pos₃)
    bearing₁₂ = bearing(pos₁, pos₂)
    return cross_track_distance(∠distance₁₃, bearing₁₂, bearing₁₃, radius)
end

cross_track_distance(pos₁::Point_deg, pos₂::Point_deg, pos₃::Point_deg,
radius::Float64=Rₑ_m) = cross_track_distance(deg2rad(pos₁), deg2rad(pos₂),
deg2rad(pos₃), radius)

"""
    cross_track_distance(section::RouteSection, pos₃::Point [,
    radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` (Point) to a route
section.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
cross_track_distance(section::RouteSection, pos₃::Point_rad,
radius::Float64=Rₑ_m) = cross_track_distance(section.pos₁, section.pos₂, pos₃,
radius)

cross_track_distance(section::RouteSection, pos₃::Point_deg,
radius::Float64=Rₑ_m) = cross_track_distance(deg2rad(section), deg2rad(pos₃),
radius)

"""
    cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` (Point) to a great
circle path defined by the point `pos₁` and `bearing` [rad].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(pos₁::Point_rad, bearing::Float64, pos₃::Point_rad,
    radius::Float64=Rₑ_m)
    pos₂ = destination_point(pos₁, radius, bearing, radius)
    return cross_track_distance(pos₁, pos₂, pos₃, radius)
end

cross_track_distance(pos₁::Point_deg, bearing::Float64, pos₃::Point_deg,
    radius::Float64=Rₑ_m) = cross_track_distance(deg2rad(pos₁), deg2rad(bearing),
    deg2rad(pos₃), radius)

"""
    cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` to a great circle
path. The distance is calculated using the angular distance between points `pos₁`
and `pos₃` (Point), the `bearing` [rad] between points `pos₁` and `pos₃` (Point)
, the `bearing` [rad] between points `pos₁` and `pos₂` (Point), and the
`radius` of the earth [m].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64, radius::Float64=Rₑ_m)
    return asin(sin(∠distance₁₃) * sin(bearing₁₃ - bearing₁₂)) * radius
end

"""
    along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[,
    radius::Float64=Rₑ_m])

The `along_track_distance` from the start point `pos₁` (Point) to the closest
point on the great circle path (defined by points `pos₁` and `pos₂` (Point)) to
the point `pos₃` (Point). The `radius` of the earth can also be given.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_track_distance(pos₁::Point_rad, pos₂::Point_rad, pos₃::Point_rad,
    radius::Float64=Rₑ_m)
    ∠distance₁₃ = distance(pos₁, pos₃, radius)
    cross_track_∠distance = cross_track_distance(pos₁, pos₂, pos₃, radius) / radius
    return along_track_distance(∠distance₁₃, cross_track_∠distance, radius)
end

along_track_distance(pos₁::Point_deg, pos₂::Point_deg, pos₃::Point_deg,
    radius::Float64=Rₑ_m) = along_track_distance(deg2rad(pos₁), deg2rad(pos₂),
    deg2rad(pos₃), radius)

"""
    along_track_distance(∠distance₁₃::Float64, cross_track_∠distance::Float64,
    [radius::Float64=Rₑ_m])

The `along_track_distance` from the start point `pos₁` (Point) to the closest
point on the great circle path (defined by angular distance `∠distance₁₃` [rad]
between `pos₁` and `pos₃` (Point) and the cross track angular distance
`cross_track_∠distance` [rad]) to the point `pos₃` (Point). The `radius` of the
earth can also be given.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_track_distance(∠distance₁₃::Float64,
    cross_track_∠distance::Float64, radius::Float64=Rₑ_m)
    return acos(cos(∠distance₁₃) / cos(cross_track_∠distance)) * radius
end
