export distance, angular_distance, cross_track_distance, along_track_distance

"""
    distance(pos₁::Point, pos₂::Point[, radius::Float64=Rₑ_m])

Return the `distance` in [m] of the great circle line between the positions `pos₁`
[deg] and `pos₂` [deg] on a sphere, with an optionally given `radius`.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function distance(pos₁::Point, pos₂::Point, radius::Float64=Rₑ_m)
    Δpos = pos₂ - pos₁
    a = sind(Δpos.ϕ/2.0)^2 + cosd(pos₁.ϕ)*cosd(pos₂.ϕ)*sind(Δpos.λ/2.0)^2
    c = 2.0 * atan(√a, √(1.0 - a))
    return radius * c
end

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
    angular_distance(distance::Float64[, radius::Float64=Rₑ_m])

Return the `angular_distance` in [deg] on a sphere, with an optionally given
`radius`.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(distance::Float64, radius::Float64=Rₑ_m)
    return rad2deg(distance/radius)
end

"""
    angular_distance(pos₁::Point, pos₂::Point, radius::Float64=Rₑ_m)

Return the `angular_distance` in [deg] of the great circle line between the
positions `pos₁` [deg] and `pos₂` [deg] on a sphere, with an optionally given
`radius`.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
angular_distance(pos₁::Point, pos₂::Point, radius::Float64=Rₑ_m) =
angular_distance(distance(pos₁, pos₂, radius), radius)

"""
    cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` [deg] to a great
circle path defined by the points `pos₁` and `pos₂` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point,
    radius::Float64=Rₑ_m)
    ∠distance₁₃ = angular_distance(pos₁, pos₃, radius)
    # ∠distance₁₃ = distance(pos₁, pos₃ , radius) / radius
    bearing₁₃ = bearing(pos₁, pos₃)
    bearing₁₂ = bearing(pos₁, pos₂)
    return cross_track_distance(∠distance₁₃, bearing₁₂, bearing₁₃, radius)
end

"""
    cross_track_distance(section::RouteSection, pos₃::Point [,
    radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` [deg] to a route
section.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
cross_track_distance(section::RouteSection, pos₃::Point,
radius::Float64=Rₑ_m) = cross_track_distance(section.pos₁, section.pos₂, pos₃,
radius)

"""
    cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` [deg] to a great
circle path defined by the point `pos₁` and `bearing` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point,
    radius::Float64=Rₑ_m)
    pos₂ = destination_point(pos₁, radius, bearing, radius)
    return cross_track_distance(pos₁, pos₂, pos₃, radius)
end

"""
    cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64[, radius::Float64=Rₑ_m])

Return the `cross_track_distance` [m] from a point `pos₃` [deg] to a great circle
path. The distance is calculated using the angular distance between points `pos₁`
and `pos₃` [deg], the `bearing` [deg] between points `pos₁` and `pos₃` [deg]
, the `bearing` [deg] between points `pos₁` and `pos₂` [deg], and the
`radius` of the earth [m].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,
    bearing₁₃::Float64, radius::Float64=Rₑ_m)
    return asin(sind(∠distance₁₃) * sind(bearing₁₃ - bearing₁₂)) * radius
end

"""
    along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[,radius::Float64=Rₑ_m])

The `along_track_distance` from the start point `pos₁` [deg] to the closest
point on the great circle path (defined by points `pos₁` and `pos₂` [deg]) to
the point `pos₃` [deg]. Optionally a different `radius` for the earth can be used.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point,
    radius::Float64=Rₑ_m)
    ∠distance₁₃ = angular_distance(pos₁, pos₃, radius)
    cross_track_∠distance = rad2deg(cross_track_distance(pos₁, pos₂, pos₃, radius)/radius)
    return along_track_distance(∠distance₁₃, cross_track_∠distance, radius)
end

"""
    along_track_distance(∠distance₁₃::Float64, cross_track_∠distance::Float64,
    [radius::Float64=Rₑ_m])

The `along_track_distance` from the start point `pos₁` [deg] to the closest
point on the great circle path (defined by angular distance `∠distance₁₃` [deg]
between `pos₁` and `pos₃` [deg] and the cross track angular distance
`cross_track_∠distance` [deg]) to the point `pos₃` [deg]. Optionally a
different `radius` for the earth can be used.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_track_distance(∠distance₁₃::Float64,
    ∠cross_track_distance::Float64, radius::Float64=Rₑ_m)
    return acos(cosd(∠distance₁₃) / cosd(∠cross_track_distance)) * radius
end
