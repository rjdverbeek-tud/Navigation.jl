export Point_rad, Point_deg, RouteSection

import Base:(convert)

"""
    Radius Earth [m]

Source: en.wikipedia.org/wiki/Earth_radius
"""
const Rₑ_m = 6371008.7714

"""
Point type with latitude `ϕ` [rad] and longitude `λ` [rad]
"""
struct Point_rad{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point_rad, y::Point_rad) = Point_rad(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point_rad) = Point_deg(rad2deg(x.ϕ), rad2deg(x.λ))

"Point_deg type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point_deg{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point_deg, y::Point_deg) = Point_deg(x.ϕ - y.ϕ, x.λ - y.λ)
(deg2rad)(x::Point_deg) = Point_rad(deg2rad(x.ϕ), deg2rad(x.λ))

Base.:convert(type::Type{Point_deg}, x::Point_rad) = rad2deg(x)
Base.:convert(type::Type{Point_rad}, x::Point_deg) = deg2rad(x)

"RouteSection type with start position pos₁ [Point_deg] / [Point_rad] and end position pos₂
[Point_deg] / [Point_rad]"
struct RouteSection{T}
    pos₁::T
    pos₂::T
end

(deg2rad)(x::RouteSection) = RouteSection(deg2rad(x.pos₁), deg2rad(x.pos₂))
(rad2deg)(x::RouteSection) = RouteSection(rad2deg(x.pos₁), rad2deg(x.pos₂))

"""
    normalize(value::Float64[, lower::Float64 = 0.0, upper::Float64 = 360.0])

Normalize a `value` to stay within the `lower` and `upper` limit.

Example:
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

#TODO Get a more efficient way to normalize latitude
"""
    normalize(point::Point_rad)
    normalize(point::Point_deg)

Normalize a `point`.
"""
function normalize(point::Point_rad)
    return Point_rad(asin(sin(point.ϕ)), normalize(point.λ, -π, π*1.0))
end

function normalize(point::Point_deg)
    return rad2deg(normalize(deg2rad(point)))
end
