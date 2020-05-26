#TODO network.jl
# export Airspace, box_spherical_polygon, isinside
#
# struct Airspace
#     name::String
#     polygon::Vector{Point_deg{Float64}}
#     bounding_box::Vector{Point_deg{Float64}}
#     function Airspace(name::String, polygon::Vector{Point_deg{Float64}})
#         box = box_spherical_polygon(polygon)
#         new(name, polygon, box)
#     end
# end
#
# function box_spherical_polygon(polygon::Vector{Point_deg{Float64}})
#     # box = Array{Float64, 2}(undef, 2, 2)
#     lats_max = Array{Float64,1}()
#     lats_min = Array{Float64,1}()
#     previous_point = Point_deg(NaN, NaN)
#     for point in polygon
#         # println(point)
#         if isnan(previous_point.λ)
#             previous_point = point
#         else
#             append!(lats_max, maximum(latitude_options(previous_point, point)))
#             append!(lats_min, minimum(latitude_options(previous_point, point)))
#             previous_point = point
#         end
#     end
#     lat_max = maximum(lats_max)
#     lat_min = minimum(lats_min)
#
#     # Limiting longitudes
#     lon_generator = (x.λ for x in polygon)
#     lon_max = maximum(lon_generator)
#     lon_min = minimum(lon_generator)
#
#     box = Vector{Point_deg}()
#     box = vcat(box, Point_deg(lat_min, lon_min))
#     box = vcat(box, Point_deg(lat_min, lon_max))
#     box = vcat(box, Point_deg(lat_max, lon_max))
#     box = vcat(box, Point_deg(lat_max, lon_min))
#     box = vcat(box, Point_deg(lat_min, lon_min))
#     return box
# end
#
# function latitude_options(pos₁::Point_deg, pos₂::Point_deg)
#     brg = bearing(pos₁, pos₂)
#     closest_point_deg = closest_point_to_pole(pos₁, brg)
#     if distance(pos₁, pos₂) > distance(pos₁, closest_point_deg)
#         return pos₁.ϕ, pos₂.ϕ, closest_point_deg.ϕ
#     else
#         return pos₁.ϕ, pos₂.ϕ
#     end
# end
#
# # function isinside(pos₁::Point_deg, polygon::Vector{Point_deg{Float64}})
# #
# # end
