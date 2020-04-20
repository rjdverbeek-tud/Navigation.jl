using Navigation
using Test

@testset "Navigation.jl" begin
    tests = ["utility", "distances", "bearings", "points", "wind"]
    # tests = [""]

    for t in tests
        include("$(t).jl")
    end
end

# @testset "Navigation.jl" begin
#     p1 = Point_rad(0.5, 1.0)
#     p2 = Point_rad(1.0, 0.5)
#     p3 = Point_rad(0.6, 1.0)  # above p1
#
#     p1deg = rad2deg(p1)
#     p2deg = rad2deg(p2)
#     p3deg = rad2deg(p3)
#
#     rs = RouteSection(p1,p2)
#     rsdeg = RouteSection(p1deg, p2deg)
#
#     @test (p1deg-p2deg).ϕ ≈ -28.6478897565 atol = 0.001
#
#     @test distance(p1, p2) ≈ 3888e3 atol = 1e3
#     @test distance(rs) ≈ 3888e3 atol = 1e3
#     @test distance(p1deg, p2deg) ≈ 3888e3 atol = 1e3
#     @test distance(rsdeg) ≈ 3888e3 atol = 1e3
#
#     @test bearing(p1, p2) ≈ 5.81412807071 atol = 0.001
#     @test bearing(rs) ≈ 5.81412807071 atol = 0.001
#     @test bearing(p1deg, p2deg) ≈ rad2deg(5.81412807071) atol = 0.001
#     @test bearing(rsdeg) ≈ rad2deg(5.81412807071) atol = 0.001
#     @test bearing(p1, p3) ≈ 0.0 atol = 0.001
#     @test bearing(p3deg, p1deg) ≈ 180.0 atol = 0.001
#
#     @test final_bearing(p1, p2) ≈ 5.45864813531 atol = 0.001
#     @test final_bearing(rs) ≈ 5.45864813531 atol = 0.001
#     @test final_bearing(p1deg, p2deg) ≈ rad2deg(5.45864813531) atol = 0.001
#     @test final_bearing(rsdeg) ≈ rad2deg(5.45864813531) atol = 0.001
#
#     @test midpoint(p1, p2).λ ≈ 0.8106650896663075 atol = 0.0001
#     @test midpoint(p1, p2).ϕ ≈ 0.76484691145 atol = 0.0001
#     @test midpoint(rs).λ ≈ 0.8106650896663075 atol = 0.0001
#     @test midpoint(rs).ϕ ≈ 0.76484691145 atol = 0.0001
#     @test midpoint(p1deg, p2deg).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
#     @test midpoint(p1deg, p2deg).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
#     @test midpoint(rsdeg).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
#     @test midpoint(rsdeg).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
#
#     @test intermediate_point(p1, p2, 0.5).λ ≈ 0.8106650896663075 atol = 0.0001
#     @test intermediate_point(p1, p2, 0.5).ϕ ≈ 0.76484691145 atol = 0.0001
#     @test intermediate_point(rs, 0.5).λ ≈ 0.8106650896663075 atol = 0.0001
#     @test intermediate_point(rs, 0.5).ϕ ≈ 0.76484691145 atol = 0.0001
#     @test intermediate_point(p1deg, p2deg, 0.5).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
#     @test intermediate_point(p1deg, p2deg, 0.5).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
#     @test intermediate_point(rsdeg, 0.5).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
#     @test intermediate_point(rsdeg, 0.5).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
#
#     dst = 3888000.0
#     brg = 5.81412807071
#     @test destination_point(p1, dst, brg).ϕ ≈ 1.0 atol = 0.01
#     @test destination_point(p1, dst, brg).λ ≈ 0.5 atol = 0.01
#     @test destination_point(p1deg, dst, rad2deg(brg)).ϕ ≈ rad2deg(1.0) atol = 0.01
#     @test destination_point(p1deg, dst, rad2deg(brg)).λ ≈ rad2deg(0.5) atol = 0.01
#
#     brg13 = 0.5
#     brg23 = 1.5
#     @test intersection_point(p1, p2, brg13, brg23).ϕ ≈ 0.86121333 atol = 0.001
#     @test intersection_point(p2, p1, brg13, brg23).ϕ ≈ -0.290965779 atol = 0.001
#     brg13_ambiguous = 2.61799387799
#     @test isnan(intersection_point(p2, p1, brg13_ambiguous, brg23).ϕ) == true
#
#     @test intersection_point(p1, p2, brg13, brg23).λ ≈ 1.31431535 atol = 0.001
#     @test intersection_point(p1deg, p2deg, rad2deg(brg13), rad2deg(brg23)).ϕ ≈ rad2deg(0.86121333) atol = 0.001
#     @test intersection_point(p1deg, p2deg, rad2deg(brg13), rad2deg(brg23)).λ ≈ rad2deg(1.31431535) atol = 0.001
#
#     p1ni = Point_deg(50.0, 10.0)
#     p2ni = Point_deg(50.0, 30.0)
#     p3ni = Point_deg(40.0, 20.0)
#     p4ni = Point_deg(60.0, 20.0)
#     @test intersection_point(p1ni, p2ni, p3ni, p4ni).ϕ ≈ 50.4313888888 atol = 0.0001
#     @test intersection_point(p1ni, p2ni, p3ni, p4ni).λ ≈ 20.0 atol = 0.0001
#     p4ni2 = Point_deg(49.0, 20.0)
#     @test isnan(intersection_point(p1ni, p2ni, p3ni, p4ni2).λ)
#
#     ap = Airspace("test", [Point_deg(50.0, 10.0), Point_deg(50.0, 30.0),
#     Point_deg(60.0, 30.0), Point_deg(60.0, 10.0), Point_deg(50.0, 10.0)])
#
#     bx = box_spherical_polygon(ap.polygon)
#     @test bx[3].ϕ ≈ 60.378348124804496 atol = 0.00001
#     @test isnan(intersection_point(Point_deg(40.0, 20.0), Point_deg(50.0, 20.0), ap).ϕ)
#
#     p1bdeg = Point_deg(30.0, 100.0)
#     p2bdeg = Point_deg(50.0, 210.0)
#     rsbdeg = RouteSection(p1bdeg, p2bdeg)
#     rsb = deg2rad(rsbdeg)
#     rsbdeg = rad2deg(rsb)
#     p3bdeg = Point_deg(40.0, 180.0)
#     p1b = deg2rad(p1bdeg)
#     p2b = deg2rad(p2bdeg)
#     p3b = deg2rad(p3bdeg)
#     # rsb = RouteSection(p1b, p2b)
#     @test cross_track_distance(p1b, p2b, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
#     @test cross_track_distance(rsb, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
#     @test along_track_distance(p1b, p2b, p3b, 1.0) ≈ 1.09661554384 atol = 0.00001
#     @test cross_track_distance(p1bdeg, p2bdeg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
#     p1p2bearing_deg = bearing(p1bdeg, p2bdeg)
#     p1p2bearing = bearing(p1b, p2b)
#     @test cross_track_distance(p1bdeg, p1p2bearing_deg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
#     @test cross_track_distance(p1b, p1p2bearing, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
#     @test cross_track_distance(rsbdeg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
#     @test along_track_distance(p1bdeg, p2bdeg, p3bdeg, 1.0) ≈ 1.09661554384 atol = 0.00001
#
#
#     @test Vground(110.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 89.7 atol = 0.1
#     @test Vground(120.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 100.3 atol = 0.1
#
#     @test head_wind(20.0, deg2rad(60.0), deg2rad(30.0)) ≈ 17.32 atol = 0.01
#     @test cross_wind(20.0, deg2rad(60.0), deg2rad(30.0)) ≈ 10.00 atol = 0.01
#
#     @test Navigation.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
#     @test Navigation.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
#     @test rad2deg(p1).ϕ ≈ 28.6479 atol = 0.0001
#     @test rad2deg(p2).λ ≈ 28.6479 atol = 0.0001
#     @test deg2rad(p1deg).ϕ ≈ 0.5 atol = 0.0001
#     @test deg2rad(p2deg).λ ≈ 0.5 atol = 0.0001
#
#     p3 = Point_deg(80.0, 190.0)
#     p4 = deg2rad(p3)
#     @test Navigation.normalize(p4).ϕ ≈ 1.3962634016 atol = 0.0001
#     @test Navigation.normalize(p4).λ ≈ -2.96705972839 atol = 0.0001
#     @test Navigation.normalize(p3).λ ≈ -170.000 atol = 0.01
#
#     @test opposite_point(p1).ϕ ≈ -0.5 atol = 0.0001
#     @test opposite_point(p1).λ ≈ -2.14159265359 atol = 0.0001
#     @test opposite_point(p1deg).ϕ ≈ -28.6478897565 atol = 0.0001
#     @test opposite_point(p1deg).λ ≈ -122.704220487 atol = 0.0001
#     @test max_latitude_deg(0.0, 45.0) ≈ 45.0 atol = 0.0001
#     @test max_latitude_rad(1.0, π/2.0) ≈ 1.0 atol = 0.0001
#     @test max_latitude_rad(1.0, 0.0) ≈ π/2.0 atol = 0.0001
#     @test max_latitude_rad(-1.0, 0.0) ≈ π/2.0 atol = 0.0001
#     @test max_latitude_rad(-1.0, 1.0*π) ≈ π/2.0 atol = 0.0001
#
#     p5 = Point_deg(45.0, 45.0)
#     @test closest_point_to_pole(p5, 45.0).ϕ ≈ 60.0 atol = 0.001
#     @test closest_point_to_pole(p5, 45.0).λ ≈ 99.73561 atol = 0.001
#     @test closest_point_to_pole(p5, 89.0).ϕ ≈ 45.00873 atol = 0.001
#     @test closest_point_to_pole(p5, 89.0).λ ≈ 46.41407 atol = 0.001
#     @test closest_point_to_pole(p5, 135.0).ϕ ≈ -60.0 atol = 0.001
#     @test closest_point_to_pole(p5, 135.0).λ ≈ 170.2644 atol = 0.001
#     @test closest_point_to_pole(p5, -135.0).ϕ ≈ -60.0 atol = 0.001
#     @test closest_point_to_pole(p5, -135.0).λ ≈ -80.2644 atol = 0.001
#     @test closest_point_to_pole(p5, -89.0).ϕ ≈ 45.00873 atol = 0.001
#     @test closest_point_to_pole(p5, -89.0).λ ≈ 43.58593 atol = 0.001
#     @test closest_point_to_pole(p5, -45.0).ϕ ≈ 60.0 atol = 0.001
#     @test closest_point_to_pole(p5, -45.0).λ ≈ -9.73561 atol = 0.001
#
#     p6 = Point_deg(-45.0, 45.0)
#     @test closest_point_to_pole(p6, 45.0).ϕ ≈ 60.0 atol = 0.001
#     @test closest_point_to_pole(p6, 45.0).λ ≈ 170.2644 atol = 0.001
#     @test closest_point_to_pole(p6, 91.0).ϕ ≈ -45.00873 atol = 0.001
#     @test closest_point_to_pole(p6, 91.0).λ ≈ 46.41407 atol = 0.001
#     @test closest_point_to_pole(p6, 135.0).ϕ ≈ -60.0 atol = 0.001
#     @test closest_point_to_pole(p6, 135.0).λ ≈ 99.73561 atol = 0.001
#     @test closest_point_to_pole(p6, -135.0).ϕ ≈ -60.0 atol = 0.001
#     @test closest_point_to_pole(p6, -135.0).λ ≈ -9.73561 atol = 0.001
#     @test closest_point_to_pole(p6, -91.0).ϕ ≈ -45.00873 atol = 0.001
#     @test closest_point_to_pole(p6, -91.0).λ ≈ 43.58593 atol = 0.001
#     @test closest_point_to_pole(p6, -45.0).ϕ ≈ 60.0 atol = 0.001
#     @test closest_point_to_pole(p6, -45.0).λ ≈ -80.2644 atol = 0.001
# end
