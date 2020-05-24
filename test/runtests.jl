using Navigation
using Test

@testset "Navigation.jl" begin
    tests = ["utility", "distances", "bearings", "points", "wind"]
    # tests = ["network"]

    for t in tests
        include("$(t).jl")
    end
end
