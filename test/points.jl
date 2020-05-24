@testset "points.jl" begin
    p1 = rad2deg(Point(0.5, 1.0))
    p2 = rad2deg(Point(1.0, 0.5))
    p3 = rad2deg(Point(0.6, 1.0))  # above p1

    rs = RouteSection(p1,p2)

    @test midpoint(p1, p2).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
    @test midpoint(p1, p2).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
    @test midpoint(rs).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
    @test midpoint(rs).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001

    @test intermediate_point(p1, p2, 0.5).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
    @test intermediate_point(p1, p2, 0.5).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001
    @test intermediate_point(rs, 0.5).λ ≈ rad2deg(0.8106650896663075) atol = 0.0001
    @test intermediate_point(rs, 0.5).ϕ ≈ rad2deg(0.76484691145) atol = 0.0001

    dst = 3888000.0
    brg = 5.81412807071
    @test destination_point(p1, dst, rad2deg(brg)).ϕ ≈ rad2deg(1.0) atol = 0.01
    @test destination_point(p1, dst, rad2deg(brg)).λ ≈ rad2deg(0.5) atol = 0.01

    brg13 = 0.5
    brg23 = 1.5
    brg13_ambiguous = 2.61799387799
    @test isnan(intersection_point(p2, p1, rad2deg(brg13_ambiguous), rad2deg(brg23)).ϕ) == true

    @test intersection_point(p1, p2, rad2deg(brg13), rad2deg(brg23)).ϕ ≈ rad2deg(0.86121333) atol = 0.001
    @test intersection_point(p1, p2, rad2deg(brg13), rad2deg(brg23)).λ ≈ rad2deg(1.31431535) atol = 0.001

    p1ni = Point(50.0, 10.0)
    p2ni = Point(50.0, 30.0)
    p3ni = Point(40.0, 20.0)
    p4ni = Point(60.0, 20.0)

    @test intersection_point(p1ni, p2ni, p3ni, p4ni).ϕ ≈ 50.4313888888 atol = 0.0001
    @test intersection_point(p1ni, p2ni, p3ni, p4ni).λ ≈ 20.0 atol = 0.0001

    p4ni2 = Point(49.0, 20.0)
    @test isnan(intersection_point(p1ni, p2ni, p3ni, p4ni2).λ)

    #TODO Uncomment after network.jl has been added
    # ap = Airspace("test", [Point(50.0, 10.0), Point(50.0, 30.0),
    # Point(60.0, 30.0), Point(60.0, 10.0), Point(50.0, 10.0)])
    #
    # bx = box_spherical_polygon(ap.polygon)
    # @test bx[3].ϕ ≈ 60.378348124804496 atol = 0.00001
    # # @test isnan(intersection_point(Point(40.0, 20.0), Point(50.0, 20.0), ap).ϕ)

    @test opposite_point(p1).ϕ ≈ -28.6478897565 atol = 0.0001
    @test opposite_point(p1).λ ≈ -122.704220487 atol = 0.0001

    @test max_latitude(0.0, 45.0) ≈ 45.0 atol = 0.0001
    @test max_latitude(rad2deg(1.0), 90.0) ≈ rad2deg(1.0) atol = 0.0001
    @test max_latitude(rad2deg(1.0), 0.0) ≈ 90.0 atol = 0.0001
    @test max_latitude(rad2deg(-1.0), 0.0) ≈ 90.0 atol = 0.0001
    @test max_latitude(rad2deg(-1.0), 180.0) ≈ 90.0 atol = 0.0001

    p5 = Point(45.0, 45.0)
    @test closest_point_to_pole(p5, 45.0).ϕ ≈ 60.0 atol = 0.001
    @test closest_point_to_pole(p5, 45.0).λ ≈ 99.73561 atol = 0.001
    @test closest_point_to_pole(p5, 89.0).ϕ ≈ 45.00873 atol = 0.001
    @test closest_point_to_pole(p5, 89.0).λ ≈ 46.41407 atol = 0.001
    @test closest_point_to_pole(p5, 135.0).ϕ ≈ -60.0 atol = 0.001
    @test closest_point_to_pole(p5, 135.0).λ ≈ 170.2644 atol = 0.001
    @test closest_point_to_pole(p5, -135.0).ϕ ≈ -60.0 atol = 0.001
    @test closest_point_to_pole(p5, -135.0).λ ≈ -80.2644 atol = 0.001
    @test closest_point_to_pole(p5, -89.0).ϕ ≈ 45.00873 atol = 0.001
    @test closest_point_to_pole(p5, -89.0).λ ≈ 43.58593 atol = 0.001
    @test closest_point_to_pole(p5, -45.0).ϕ ≈ 60.0 atol = 0.001
    @test closest_point_to_pole(p5, -45.0).λ ≈ -9.73561 atol = 0.001

    p6 = Point(-45.0, 45.0)
    @test closest_point_to_pole(p6, 45.0).ϕ ≈ 60.0 atol = 0.001
    @test closest_point_to_pole(p6, 45.0).λ ≈ 170.2644 atol = 0.001
    @test closest_point_to_pole(p6, 91.0).ϕ ≈ -45.00873 atol = 0.001
    @test closest_point_to_pole(p6, 91.0).λ ≈ 46.41407 atol = 0.001
    @test closest_point_to_pole(p6, 135.0).ϕ ≈ -60.0 atol = 0.001
    @test closest_point_to_pole(p6, 135.0).λ ≈ 99.73561 atol = 0.001
    @test closest_point_to_pole(p6, -135.0).ϕ ≈ -60.0 atol = 0.001
    @test closest_point_to_pole(p6, -135.0).λ ≈ -9.73561 atol = 0.001
    @test closest_point_to_pole(p6, -91.0).ϕ ≈ -45.00873 atol = 0.001
    @test closest_point_to_pole(p6, -91.0).λ ≈ 43.58593 atol = 0.001
    @test closest_point_to_pole(p6, -45.0).ϕ ≈ 60.0 atol = 0.001
    @test closest_point_to_pole(p6, -45.0).λ ≈ -80.2644 atol = 0.001
end
