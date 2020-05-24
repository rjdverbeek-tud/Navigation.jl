export Point, RouteSection

"""
    Radius Earth [m]

Source: en.wikipedia.org/wiki/Earth_radius
"""
const Rₑ_m = 6371008.7714

"Point type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"RouteSection type with start position pos₁ [Point] and end position pos₂
[Point_deg]"
struct RouteSection{T}
    pos₁::T
    pos₂::T
end

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
    normalize(point::Point)

Normalize a `point`.
"""
function normalize(point::Point)
    return Point(asind(sind(point.ϕ)), normalize(point.λ, -180.0, 180.0))
end
