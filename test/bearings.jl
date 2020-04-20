@testset "bearings.jl" begin
    p1 = Point_rad(0.5, 1.0)
    p2 = Point_rad(1.0, 0.5)
    p3 = Point_rad(0.6, 1.0)  # above p1

    p1deg = rad2deg(p1)
    p2deg = rad2deg(p2)
    p3deg = rad2deg(p3)

    rs = RouteSection(p1,p2)
    rsdeg = RouteSection(p1deg, p2deg)

    @test bearing(p1, p2) ≈ 5.81412807071 atol = 0.001
    @test bearing(rs) ≈ 5.81412807071 atol = 0.001
    @test bearing(p1deg, p2deg) ≈ rad2deg(5.81412807071) atol = 0.001
    @test bearing(rsdeg) ≈ rad2deg(5.81412807071) atol = 0.001
    @test bearing(p1, p3) ≈ 0.0 atol = 0.001
    @test bearing(p3deg, p1deg) ≈ 180.0 atol = 0.001

    @test final_bearing(p1, p2) ≈ 5.45864813531 atol = 0.001
    @test final_bearing(rs) ≈ 5.45864813531 atol = 0.001
    @test final_bearing(p1deg, p2deg) ≈ rad2deg(5.45864813531) atol = 0.001
    @test final_bearing(rsdeg) ≈ rad2deg(5.45864813531) atol = 0.001

end
