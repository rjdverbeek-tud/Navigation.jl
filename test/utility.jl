@testset "utility.jl" begin
    p1 = Point_rad(0.5, 1.0)
    p2 = Point_rad(1.0, 0.5)
    p3 = Point_rad(0.6, 1.0)  # above p1

    p1deg = rad2deg(p1)
    p2deg = rad2deg(p2)
    p3deg = rad2deg(p3)

    rs = RouteSection(p1,p2)
    rsdeg = RouteSection(p1deg, p2deg)

    @test (p1deg-p2deg).ϕ ≈ -28.6478897565 atol = 0.001

    @test Navigation.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test Navigation.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
    @test rad2deg(p1).ϕ ≈ 28.6479 atol = 0.0001
    @test rad2deg(p2).λ ≈ 28.6479 atol = 0.0001
    @test deg2rad(p1deg).ϕ ≈ 0.5 atol = 0.0001
    @test deg2rad(p2deg).λ ≈ 0.5 atol = 0.0001

    p3 = Point_deg(80.0, 190.0)
    p4 = deg2rad(p3)
    @test Navigation.normalize(p4).ϕ ≈ 1.3962634016 atol = 0.0001
    @test Navigation.normalize(p4).λ ≈ -2.96705972839 atol = 0.0001
    @test Navigation.normalize(p3).λ ≈ -170.000 atol = 0.01

end
