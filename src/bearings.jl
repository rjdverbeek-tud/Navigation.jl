export bearing, final_bearing

"""
    bearing(pos₁::Point, pos₂::Point)

Return the initial `bearing` of the great circle line between the
positions `pos₁` and `pos₂` on a sphere.

Point = Navigation.Point_deg or Navigation.Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function bearing(pos₁::Point_rad, pos₂::Point_rad)
    Δpos = pos₂ - pos₁
    return mod2pi(atan(sin(Δpos.λ)*cos(pos₂.ϕ), cos(pos₁.ϕ)*sin(pos₂.ϕ) -
    sin(pos₁.ϕ)*cos(pos₂.ϕ)*cos(Δpos.λ)))
end

bearing(pos₁::Point_deg, pos₂::Point_deg) = rad2deg(bearing(deg2rad(pos₁),
deg2rad(pos₂)))

"""
    bearing(section::RouteSection)

Return the initial `bearing` [rad] of the route section on a sphere.

Point = Navigation.Point_deg or Navigation.Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
bearing(section::RouteSection) = bearing(section.pos₁, section.pos₂)

"""
    final_bearing(pos₁::Point, pos₂::Point)

Return the `final_bearing` of the great circle line between the positions
`pos₁` and `pos₂` on a sphere.

Point = Navigation.Point_deg or Navigation.Point_rad

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function final_bearing(pos₁::Point_rad, pos₂::Point_rad)
    return mod2pi(bearing(pos₂, pos₁) + π)
end

final_bearing(pos₁::Point_deg, pos₂::Point_deg) = rad2deg(final_bearing(
deg2rad(pos₁), deg2rad(pos₂)))

"""
    final_bearing(section::RouteSection)

Return the `final_bearing` [rad] of the route section on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
final_bearing(section::RouteSection) = final_bearing(section.pos₁, section.pos₂)
