export Vground, head_wind, cross_wind

"""
    Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)

Return the ground speed `Vground` [m/s] given the `course` [deg], airspeed
`Vtas` [m/s], wind speed `Vwind`[m/s] and wind direction (from) `∠wind` [deg].

source: edwilliams.org/avform.htm
"""
function Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)
    swc = (Vwind / Vtas) * sind(∠wind - course)
    if abs(swc) > 1.0
        return NaN
    end
    return Vtas * √(1-swc^2) - Vwind * cosd(∠wind - course)
end

"""
    head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Return the `head_wind` [m/s] component for a given wind speed `Vwind` [m/s],
`course` [deg], and wind direction (from) `∠wind` [deg]. A tail-wind is a
negative head-wind.

source: edwilliams.org/avform.htm
"""
function head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*cosd(∠wind - course)
end

"""
    cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Return the `cross_wind` [m/s] component for a given wind speed `Vwind` [m/s],
`course` [deg], and wind direction (from) `∠wind` [deg]. A positive cross-wind
component indicates a wind from the right.

source: edwilliams.org/avform.htm
"""
function cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*sind(∠wind - course)
end
