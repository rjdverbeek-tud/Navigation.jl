export Airspace, box_spherical_polygon, isinside

struct Airspace
    name::String
    polygon::Vector{Point{Float64}}
    bounding_box::Vector{Point{Float64}}
    function Airspace(name::String, polygon::Vector{Point{Float64}})
        box = box_spherical_polygon(polygon)
        new(name, polygon, box)
    end
end

function box_spherical_polygon(polygon::Vector{Point{Float64}})
    # box = Array{Float64, 2}(undef, 2, 2)
    lats_max = Array{Float64,1}()
    lats_min = Array{Float64,1}()
    previous_point = Point(NaN, NaN)
    for point in polygon
        # println(point)
        if isnan(previous_point.λ)
            previous_point = point
        else
            append!(lats_max, maximum(latitude_options(previous_point, point)))
            append!(lats_min, minimum(latitude_options(previous_point, point)))
            previous_point = point
        end
    end
    lat_max = maximum(lats_max)
    lat_min = minimum(lats_min)

    # Limiting longitudes
    lon_generator = (x.λ for x in polygon)
    lon_max = maximum(lon_generator)
    lon_min = minimum(lon_generator)

    box = Vector{Point}()
    box = vcat(box, Point(lat_min, lon_min))
    box = vcat(box, Point(lat_min, lon_max))
    box = vcat(box, Point(lat_max, lon_max))
    box = vcat(box, Point(lat_max, lon_min))
    box = vcat(box, Point(lat_min, lon_min))
    return box
end

function latitude_options(pos₁::Point, pos₂::Point)
    brg = bearing(pos₁, pos₂)
    closest_point = closest_point_to_pole(pos₁, brg)
    if distance(pos₁, pos₂) > distance(pos₁, closest_point)
        return pos₁.ϕ, pos₂.ϕ, closest_point.ϕ
    else
        return pos₁.ϕ, pos₂.ϕ
    end
end

function isinside(pos₁::Point, polygon::Vector{Point{Float64}})
    south_pole = Point(-90.0, 0.0)
    poly₁ = polygon[1]
    count_intersections = 0
    for poly₂ in polygon[2:end]
        isnan(intersection_point(pos₁, south_pole, poly₁, poly₂).ϕ) ? false : count_intersections += 1
        poly₁ = poly₂
    end
    return count_intersections%2 != 0
end
