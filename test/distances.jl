@testset "distances.jl" begin
    p1 = rad2deg(Point(0.5, 1.0))
    p2 = rad2deg(Point(1.0, 0.5))
    p3 = rad2deg(Point(0.6, 1.0))  # above p1

    rs = RouteSection(p1,p2)

    @test distance(p1, p2) ≈ 3888e3 atol = 1e3
    @test distance(rs) ≈ 3888e3 atol = 1e3

    p1b = Point(30.0, 100.0)
    p2b = Point(50.0, 210.0)
    rsb = RouteSection(p1b, p2b)

    @test distance(p1b, p2b) ≈ 8773000.0 atol = 1000.0
    @test angular_distance(p1b, p2b) ≈ 78.8974 atol = 0.1

    p3b = Point(40.0, 180.0)
    @test cross_track_distance(p1b, p2b, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test cross_track_distance(rsb, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test along_track_distance(p1b, p2b, p3b, 1.0) ≈ 1.09661554384 atol = 0.00001

    p1p2bearing = bearing(p1b, p2b)
    @test cross_track_distance(p1b, p1p2bearing, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test along_track_distance(p1b, p2b, p3b, 1.0) ≈ 1.09661554384 atol = 0.00001

end
