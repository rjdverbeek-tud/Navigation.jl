"""
Calculate distances, angles, speeds and points for aviation navigation purposes.

All angles are in radians, distances are standard in meters, and speeds are
standard in m/s.

These methods are not to be used for operational purposes.

Implemented Functions:
* distance
* bearing
* final_bearing
* midpoint
* intermediate_point
* destination_point
* intersection_point
* along_track_distance
* cross_track_distance
* Vground
* head_wind
* cross_wind
* normalize

Implemented Types:
* Point_rad(ϕ, λ)
* Point_deg(ϕ, λ)

Implemented constants:
* Rₑ_m    Radius Earth in [m]

Based on
source: www.movable-type.co.uk/scripts/latlong.html
source: edwilliams.org/avform.htm
"""
module Navigation

import Base.-, Base.Math.rad2deg, Base.Math.deg2rad

include("utility.jl")
include("distances.jl")
include("bearings.jl")
include("points.jl")
include("wind.jl")

#TODO Closest point to the poles
#TODO Crossing parallels
#TODO Rhumb lines

end # module
