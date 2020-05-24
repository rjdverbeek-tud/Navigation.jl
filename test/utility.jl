@testset "utility.jl" begin
    p1 = rad2deg(Point(0.5, 1.0))
    p2 = rad2deg(Point(1.0, 0.5))
    p3 = rad2deg(Point(0.6, 1.0))  # above p1

    rs = RouteSection(p1,p2)

    @test (p1-p2).ϕ ≈ -28.6478897565 atol = 0.001

    @test Navigation.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test Navigation.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
    @test deg2rad(p1).ϕ ≈ 0.5 atol = 0.0001
    @test deg2rad(p2).λ ≈ 0.5 atol = 0.0001

    p3 = Point(80.0, 190.0)
    @test Navigation.normalize(p3).ϕ ≈ rad2deg(1.3962634016) atol = 0.0001
    @test Navigation.normalize(p3).λ ≈ rad2deg(-2.96705972839) atol = 0.0001
    @test Navigation.normalize(p3).λ ≈ -170.000 atol = 0.01

end
