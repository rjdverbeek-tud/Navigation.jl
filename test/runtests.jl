using Navigation
using Test

@testset "Navigation.jl" begin
    p1 = Point(0.5, 1.0)
    p2 = Point(1.0, 0.5)
    @test distance(p1, p2) ≈ 3888e3 atol = 1e3
    @test bearing(p1, p2) ≈ 5.81412807071 atol = 0.001
    @test final_bearing(p1, p2) ≈ 5.45864813531 atol = 0.001
    @test midpoint(p1, p2).λ ≈ 0.8106650896663075 atol = 0.0001
    @test midpoint(p1, p2).ϕ ≈ 0.76484691145 atol = 0.0001
    @test intermediate_point(p1, p2, 0.5).λ ≈ 0.8106650896663075 atol = 0.0001
    @test intermediate_point(p1, p2, 0.5).ϕ ≈ 0.76484691145 atol = 0.0001
    @test Vground(110.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 89.7 atol = 0.1
    @test Vground(120.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 100.3 atol = 0.1
    @test Navigation.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test Navigation.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
    @test rad2deg(p1).ϕ ≈ 28.6479 atol = 0.0001
    @test rad2deg(p2).λ ≈ 28.6479 atol = 0.0001
    @test deg2rad(p1).ϕ ≈ 0.0087 atol = 0.0001
    @test deg2rad(p2).λ ≈ 0.0087 atol = 0.0001
end
