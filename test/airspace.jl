@testset "airspace.jl" begin
    p1 = Point(0.0, 0.0)
    p2 = Point(0.0, 10.0)
    p3 = Point(10.0, 10.0)
    p4 = Point(10.0, 0.0)

    ap = Airspace("test", [p1, p2, p3, p4, p1])

    mp = midpoint(p3, p4)
    @test ap.name == "test"
    @test ap.polygon[1] == p1
    @test ap.polygon[end] == p1
    @test ap.bounding_box[3].ϕ ≈ mp.ϕ atol = 0.0001

    @test isinside(Point(5.0, 5.0), ap.bounding_box)
    @test isinside(Point(15.0, 5.0), ap.bounding_box) == false
    @test isinside(Point(5.0, 15.0), ap.bounding_box) == false
end
