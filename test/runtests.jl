using Navigation
using Test

@testset "Navigation.jl" begin
    tests = ["utility", "distances", "bearings", "points", "wind", "airspace"]
    # tests = ["airspace"]

    for t in tests
        include("$(t).jl")
    end
end
