var documenterSearchIndex = {"docs":
[{"location":"#Navigation.jl-1","page":"Home","title":"Navigation.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Modules = [Navigation]\nOrder = [:module]\nPrivate = false","category":"page"},{"location":"#Navigation.Navigation","page":"Home","title":"Navigation.Navigation","text":"Calculate distances, angles, speeds and points for aviation navigation purposes.\n\nAll angles are in radians, distances are standard in meters, and speeds are standard in m/s.\n\nThese methods are not to be used for operational purposes.\n\nImplemented Functions:\n\ndistance\nbearing\nfinal_bearing\nmidpoint\nintermediate_point\ndestination_point\nintersection_point\nalongtrackdistance\ncrosstrackdistance\nVground\nhead_wind\ncross_wind\nnormalize\nclosestpointto_poles\n\nImplemented Types:\n\nPoint_rad(ϕ, λ)\nPoint_deg(ϕ, λ)\n\nImplemented constants:\n\nRₑ_m    Radius Earth in [m]\n\nBased on source: www.movable-type.co.uk/scripts/latlong.html source: edwilliams.org/avform.htm\n\n\n\n\n\n","category":"module"},{"location":"#Types-1","page":"Home","title":"Types","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Point_rad\nPoint_deg","category":"page"},{"location":"#Navigation.Point_rad","page":"Home","title":"Navigation.Point_rad","text":"Point type with latitude ϕ [rad] and longitude λ [rad]\n\n\n\n\n\n","category":"type"},{"location":"#Navigation.Point_deg","page":"Home","title":"Navigation.Point_deg","text":"Point_deg type with latitude ϕ [deg] and longitude λ [deg]\n\n\n\n\n\n","category":"type"},{"location":"#Functions-1","page":"Home","title":"Functions","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Modules = [Navigation]\nOrder = [:function]\nPrivate = false","category":"page"},{"location":"#Navigation.Vground-NTuple{4,Float64}","page":"Home","title":"Navigation.Vground","text":"Vground(Vtas::Float64, Vwind::Float64, ∠wind::Float64, course::Float64)\n\nReturn the ground speed Vground [m/s] given the course [rad], airspeed Vtas [m/s], wind speed Vwind[m/s] and wind direction ∠wind [rad]. The speeds need to use the same speed unit ([m/s] or [kts] or [km/h]).\n\nsource: edwilliams.org/avform.htm\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.along_track_distance","page":"Home","title":"Navigation.along_track_distance","text":"along_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[,\nradius::Float64=Rₑ_m])\n\nThe along_track_distance from the start point pos₁ (Point) to the closest point on the great circle path (defined by points pos₁ and pos₂ (Point)) to the point pos₃ (Point). The radius of the earth can also be given.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.along_track_distance","page":"Home","title":"Navigation.along_track_distance","text":"along_track_distance(∠distance₁₃::Float64, cross_track_∠distance::Float64,\n[radius::Float64=Rₑ_m])\n\nThe along_track_distance from the start point pos₁ (Point) to the closest point on the great circle path (defined by angular distance ∠distance₁₃ [rad] between pos₁ and pos₃ (Point) and the cross track angular distance cross_track_∠distance [rad]) to the point pos₃ (Point). The radius of the earth can also be given.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.bearing-Tuple{Point_rad,Point_rad}","page":"Home","title":"Navigation.bearing","text":"bearing(pos₁::Point, pos₂::Point)\n\nReturn the initial bearing of the great circle line between the positions pos₁ and pos₂ on a sphere.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.bearing-Tuple{RouteSection}","page":"Home","title":"Navigation.bearing","text":"bearing(section::RouteSection)\n\nReturn the initial bearing [rad] of the route section on a sphere.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.closest_point_to_pole-Tuple{Point_rad,Float64}","page":"Home","title":"Navigation.closest_point_to_pole","text":"closestpointtopole(point::Pointrad, bearingrad::Float64) closestpointtopole(point::Pointdeg, bearingdeg::Float64)\n\nGiven a starting point [Point_rad] and initial bearing [rad] calculate the closest point to the next pole encountered.\n\nSource: https://www.movable-type.co.uk/scripts/latlong.html #TODO Source for longitude\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.cross_track_distance","page":"Home","title":"Navigation.cross_track_distance","text":"cross_track_distance(pos₁::Point, bearing::Float64, pos₃::Point[, radius::Float64=Rₑ_m])\n\nReturn the cross_track_distance [m] from a point pos₃ (Point) to a great circle path defined by the point pos₁ and bearing [rad].\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.cross_track_distance","page":"Home","title":"Navigation.cross_track_distance","text":"cross_track_distance(∠distance₁₃::Float64, bearing₁₂::Float64,\nbearing₁₃::Float64[, radius::Float64=Rₑ_m])\n\nReturn the cross_track_distance [m] from a point pos₃ to a great circle path. The distance is calculated using the angular distance between points pos₁ and pos₃ (Point), the bearing [rad] between points pos₁ and pos₃ (Point) , the bearing [rad] between points pos₁ and pos₂ (Point), and the radius of the earth [m].\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.cross_track_distance","page":"Home","title":"Navigation.cross_track_distance","text":"cross_track_distance(pos₁::Point, pos₂::Point, pos₃::Point[, radius::Float64=Rₑ_m])\n\nReturn the cross_track_distance [m] from a point pos₃ (Point) to a great circle path defined by the points pos₁ and pos₂ (Point).\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.cross_track_distance","page":"Home","title":"Navigation.cross_track_distance","text":"cross_track_distance(section::RouteSection, pos₃::Point [,\nradius::Float64=Rₑ_m])\n\nReturn the cross_track_distance [m] from a point pos₃ (Point) to a route section.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.cross_wind-Tuple{Float64,Float64,Float64}","page":"Home","title":"Navigation.cross_wind","text":"cross_wind(Vwind::Float64, ∠wind::Float64, course::Float64)\n\nReturn the cross_wind [m/s] component for a given wind speed Vwind [m/s], course [rad], and wind direction ∠wind [rad]. A positive cross-wind component indicates a wind from the right.\n\nsource: edwilliams.org/avform.htm\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.destination_point","page":"Home","title":"Navigation.destination_point","text":"destination_point(start_pos::Point, distance::Float64, bearing::Float64[,\n radius::Float64=Rₑ_m])\n\nGiven a start_pos (Point), initial bearing (clockwise from North), distance [m], and the earth radius [m] calculate the destina­tion_point (Point) travelling along a (shortest distance) great circle arc. (The distance must use the same radius as the radius of the earth.)\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad (if Pointdeg then the initial bearing must also be in degrees, and if Pointrad then the intial bearing must be in radians)\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.distance","page":"Home","title":"Navigation.distance","text":"distance(section::RouteSection [, radius::Float64=Rₑ_m])\n\nReturn the distance in [m] of the great circle line on the route section on a sphere, with a given radius, calculated using the haversine formula. The haversine gives also good estimations at short distances.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.distance","page":"Home","title":"Navigation.distance","text":"distance(pos₁::Point, pos₂::Point[, radius::Float64=Rₑ_m])\n\nReturn the distance in [m] of the great circle line between the positions pos₁ and pos₂ on a sphere, with a given radius, calculated using the haversine formula. The haversine gives also good estimations at short distances.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.final_bearing-Tuple{Point_rad,Point_rad}","page":"Home","title":"Navigation.final_bearing","text":"final_bearing(pos₁::Point, pos₂::Point)\n\nReturn the final_bearing of the great circle line between the positions pos₁ and pos₂ on a sphere.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.final_bearing-Tuple{RouteSection}","page":"Home","title":"Navigation.final_bearing","text":"final_bearing(section::RouteSection)\n\nReturn the final_bearing [rad] of the route section on a sphere.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.head_wind-Tuple{Float64,Float64,Float64}","page":"Home","title":"Navigation.head_wind","text":"head_wind(Vwind::Float64, ∠wind::Float64, course::Float64)\n\nReturn the head_wind [m/s] component for a given wind speed Vwind [m/s], course [rad], and wind direction ∠wind [rad]. A tail-wind is a negative head-wind.\n\nsource: edwilliams.org/avform.htm\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.intermediate_point","page":"Home","title":"Navigation.intermediate_point","text":"intermediate_point(section::RouteSection [, fraction::Float64 = 0.5])\n\nReturn the intermediate_point (Point) at any fraction along the route section. The fraction along the great circle route is such that fraction = 0.0 is at pos₁ and fraction 1.0 is at pos₂.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.intermediate_point","page":"Home","title":"Navigation.intermediate_point","text":"intermediate_point(pos₁::Point, pos₂::Point[, fraction::Float64 = 0.5])\n\nReturn the intermediate_point (Point) at any fraction along the great circle path between two points with positions pos₁ and pos₂. The fraction along the great circle route is such that fraction = 0.0 is at pos₁ and fraction 1.0 is at pos₂.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"function"},{"location":"#Navigation.intersection_point-Tuple{Point_rad,Point_rad,Float64,Float64}","page":"Home","title":"Navigation.intersection_point","text":"intersection_point(pos₁::Point, pos₂::Point, bearing₁₃::Float64,\nbearing₂₃::Float64)\n\nReturn the intersection point pos₃ (Point) of two great circle paths given two start points (Point) pos₁ and pos₂ and two bearings from pos₁ to pos₃, and from pos₂ to pos₃.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad (if Pointdeg then the initial bearings must also be in degrees, and if Pointrad then the intial bearings must be in radians)\n\nUnder certain circumstances the results can be an ∞ or ambiguous solution.\n\nSource: edwilliams.org/avform.htm\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.max_latitude_deg-Tuple{Float64,Float64}","page":"Home","title":"Navigation.max_latitude_deg","text":"maxlatitudedeg(latdeg::Float64, bearingdeg::Float64)\n\nUsing Clairaut's formula it is possible to calculate the maximum latitude of a great circle path, give a bearing bearing_deg [deg] and latitude lat_deg [deg] on the great circle.\n\nThe minimum latitude is -maxlatitudedeg\n\nSource: https://www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.max_latitude_rad-Tuple{Float64,Float64}","page":"Home","title":"Navigation.max_latitude_rad","text":"maxlatituderad(latrad::Float64, bearingrad::Float64)\n\nUsing Clairaut's formula it is possible to calculate the maximum latitude of a great circle path, give a bearing bearing_rad [rad] and latitude lat_rad [rad] on the great circle.\n\nThe minimum latitude is -maxlatituderad\n\nSource: https://www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.midpoint-Tuple{Point_rad,Point_rad}","page":"Home","title":"Navigation.midpoint","text":"midpoint(pos₁::Point, pos₂::Point)\n\nReturn the half-way point midpoint (Point) on the great circle line between the positions pos₁ and pos₂ on a sphere.\n\nPoint = Navigation.Pointdeg or Navigation.Pointrad\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.midpoint-Tuple{RouteSection}","page":"Home","title":"Navigation.midpoint","text":"midpoint(section::RouteSection)\n\nReturn the half-way point midpoint (Point) on the route section on a sphere.\n\nSource: www.movable-type.co.uk/scripts/latlong.html\n\n\n\n\n\n","category":"method"},{"location":"#Navigation.opposite_point-Tuple{Point_rad}","page":"Home","title":"Navigation.opposite_point","text":"oppositepoint(point::Pointrad) oppositepoint(point::Pointdeg)\n\nThe point at the opposite site of the Earth.\n\n\n\n\n\n","category":"method"}]
}