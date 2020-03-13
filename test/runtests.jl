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

    dst = 3888000.0
    brg = 5.81412807071
    @test destination_point(p1, dst, brg).ϕ ≈ 1.0 atol = 0.01
    @test destination_point(p1, dst, brg).λ ≈ 0.5 atol = 0.01

    brg13 = 0.5
    brg23 = 1.5
    @test intersection_point(p1, p2, brg13, brg23).ϕ ≈ 0.86121333 atol = 0.001
    @test intersection_point(p1, p2, brg13, brg23).λ ≈ 1.31431535 atol = 0.001

    p1b = deg2rad(Point(30.0, 100.0))
    p2b = deg2rad(Point(50.0, 210.0))
    p3b = deg2rad(Point(40.0, 180.0))
    @test cross_track_distance(p1b, p2b, p3b, 1.0) ≈ 0.297182506587 atol = 0.00001
    @test along_track_distance(p1b, p2b, p3b, 1.0) ≈ 1.09661554384 atol = 0.00001

    @test Vground(110.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 89.7 atol = 0.1
    @test Vground(120.0, 40.0, deg2rad(315.0), deg2rad(245.0)) ≈ 100.3 atol = 0.1

    @test head_wind(20.0, deg2rad(60.0), deg2rad(30.0)) ≈ 17.32 atol = 0.01
    @test cross_wind(20.0, deg2rad(60.0), deg2rad(30.0)) ≈ 10.00 atol = 0.01

    @test Navigation.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test Navigation.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
    @test rad2deg(p1).ϕ ≈ 28.6479 atol = 0.0001
    @test rad2deg(p2).λ ≈ 28.6479 atol = 0.0001
    @test deg2rad(p1).ϕ ≈ 0.0087 atol = 0.0001
    @test deg2rad(p2).λ ≈ 0.0087 atol = 0.0001

    p3 = Point(100.0, 190.0)
    @test Navigation.normalize(p3, type='deg').ϕ ≈ 80.0 atol = 0.1
    @test Navigation.normalize(p3, type='deg').λ ≈ -170.0 atol = 0.1
end
