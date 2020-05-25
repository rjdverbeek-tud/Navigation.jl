export bearing, final_bearing

"""
    bearing(pos₁::Point, pos₂::Point)

Return the initial `bearing` [deg] of the great circle line between the
positions `pos₁` and `pos₂` [deg] on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function bearing(pos₁::Point, pos₂::Point)
    Δpos = pos₂ - pos₁
    return mod(atand(sind(Δpos.λ)*cosd(pos₂.ϕ), cosd(pos₁.ϕ)*sind(pos₂.ϕ) -
    sind(pos₁.ϕ)*cosd(pos₂.ϕ)*cosd(Δpos.λ)), 360.0)
end

"""
    bearing(section::RouteSection)

Return the initial `bearing` [deg] of the route section on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
bearing(section::RouteSection) = bearing(section.pos₁, section.pos₂)

"""
    final_bearing(pos₁::Point, pos₂::Point)

Return the `final_bearing` [deg] of the great circle line between the positions
`pos₁` and `pos₂` [deg] on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function final_bearing(pos₁::Point, pos₂::Point)
    return mod(bearing(pos₂, pos₁) + 180.0, 360.0)
end

"""
    final_bearing(section::RouteSection)

Return the `final_bearing` [deg] of the route section on a sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
final_bearing(section::RouteSection) = final_bearing(section.pos₁, section.pos₂)
