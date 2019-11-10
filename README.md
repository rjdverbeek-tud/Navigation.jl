# Navigation

[![Build Status](https://travis-ci.com/rjdverbeek-tud/Navigation.jl.svg?branch=master)](https://travis-ci.com/rjdverbeek-tud/Navigation.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/rjdverbeek-tud/Navigation.jl?svg=true)](https://ci.appveyor.com/project/rjdverbeek-tud/Navigation-jl)
[![Codecov](https://codecov.io/gh/rjdverbeek-tud/Navigation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rjdverbeek-tud/Navigation.jl)
[![Coveralls](https://coveralls.io/repos/github/rjdverbeek-tud/Navigation.jl/badge.svg?branch=master)](https://coveralls.io/github/rjdverbeek-tud/Navigation.jl?branch=master)

This package provides a number of navigation functions.
The functions are based on the Aviation Formulary V1.46 of Ed Williams and the
latlong scripts of Movable-type.

Implemented Functions:
* distance
* bearing
* final_bearing
* midpoint
* intermediate_point
* destination_point
* intersection_point
* along_track_distance
* Vground
* head_wind
* cross_wind
* normalize

Implemented Types:
* Point(ϕ, λ)

Implemented constants:
* Rₑ    Radius Earth in [m]

The calculations are done using the Point struct for specifying points as radians

All angles are radians, distances are in meters, and speeds are in m/s.

Source: https://www.movable-type.co.uk/scripts/latlong.html
Source: http://edwilliams.org/avform.htm
