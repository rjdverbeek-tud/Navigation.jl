export Vground, head_wind, cross_wind

"""
    Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)

Return the ground speed `Vground` [m/s] given the `course` [rad], airspeed
`Vtas` [m/s], wind speed `Vwind`[m/s] and wind direction `∠wind` [rad]. The
speeds need to use the same speed unit ([m/s] or [kts] or [km/h]).

source: edwilliams.org/avform.htm
"""
function Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)
    swc = (Vwind / Vtas) * sin(∠wind - course)
    return Vtas * √(1-swc*swc) - Vwind * cos(∠wind - course)
end

"""
    head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Return the `head_wind` [m/s] component for a given wind speed `Vwind` [m/s],
`course` [rad], and wind direction `∠wind` [rad]. A tail-wind is a negative
head-wind.

source: edwilliams.org/avform.htm
"""
function head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*cos(∠wind - course)
end

"""
    cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)

Return the `cross_wind` [m/s] component for a given wind speed `Vwind` [m/s],
`course` [rad], and wind direction `∠wind` [rad]. A positive cross-wind
component indicates a wind from the right.

source: edwilliams.org/avform.htm
"""
function cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)
    return Vwind*sin(∠wind - course)
end
