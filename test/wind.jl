@testset "wind.jl" begin

        @test Vground(110.0, 40.0, 315.0, 245.0) ≈ 89.7 atol = 0.1
        @test Vground(120.0, 40.0, 315.0, 245.0) ≈ 100.3 atol = 0.1

        @test head_wind(20.0, 60.0, 30.0) ≈ 17.32 atol = 0.01
        @test cross_wind(20.0, 60.0, 30.0) ≈ 10.00 atol = 0.01
end
