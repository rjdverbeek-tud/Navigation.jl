@testset "distances.jl" begin
    p1 = Point_rad(0.5, 1.0)
    p2 = Point_rad(1.0, 0.5)
    p3 = Point_rad(0.6, 1.0)  # above p1

    p1deg = rad2deg(p1)
    p2deg = rad2deg(p2)
    p3deg = rad2deg(p3)

    rs = RouteSection(p1,p2)
    rsdeg = RouteSection(p1deg, p2deg)

    @test distance(p1, p2) ≈ 3888e3 atol = 1e3
    @test distance(rs) ≈ 3888e3 atol = 1e3
    @test distance(p1deg, p2deg) ≈ 3888e3 atol = 1e3
    @test distance(rsdeg) ≈ 3888e3 atol = 1e3

    p1bdeg = Point_deg(30.0, 100.0)
    p2bdeg = Point_deg(50.0, 210.0)
    rsbdeg = RouteSection(p1bdeg, p2bdeg)
    rsb = deg2rad(rsbdeg)
    rsbdeg = rad2deg(rsb)
    p3bdeg = Point_deg(40.0, 180.0)
    p1b = deg2rad(p1bdeg)
    p2b = deg2rad(p2bdeg)
    p3b = deg2rad(p3bdeg)
    # rsb = RouteSection(p1b, p2b)
    @test cross_track_distance(p1b, p2b, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test cross_track_distance(rsb, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test along_track_distance(p1b, p2b, p3b, 1.0) ≈ 1.09661554384 atol = 0.00001
    @test cross_track_distance(p1bdeg, p2bdeg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
    p1p2bearing_deg = bearing(p1bdeg, p2bdeg)
    p1p2bearing = bearing(p1b, p2b)
    @test cross_track_distance(p1bdeg, p1p2bearing_deg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test cross_track_distance(p1b, p1p2bearing, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test cross_track_distance(rsbdeg, p3bdeg, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test along_track_distance(p1bdeg, p2bdeg, p3bdeg, 1.0) ≈ 1.09661554384 atol = 0.00001

end
