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

    @test intersection_point(Point(15.0, 5.0), Point(-90.0, 0.0),
    ap.polygon).ϕ ≈ 10.03742304591071 atol = 0.0001
    @test intersection_point(Point(5.0, 5.0), Point(-90.0, 0.0),
    ap.polygon).ϕ ≈ 0.0 atol = 0.0001

    @test intersection_point(Point(15.0, 5.0), Point(-90.0, 0.0), ap).ϕ ≈
    10.03742304591071 atol = 0.0001
    @test intersection_point(Point(5.0, 5.0), Point(-90.0, 0.0), ap).ϕ ≈
    0.0 atol = 0.0001
    @test isnan(intersection_point(Point(5.0, 15.0), Point(-90.0, 0.0), ap).ϕ)

    ap_triangle = Airspace("triangle", [p1, p2, p3, p1])
    @test isinside(Point(9.0, 1.0), ap_triangle.bounding_box) == true
    @test isinside(Point(9.0, 1.0), ap_triangle.polygon) == false

    @test isnan(intersection_point(Point(0.0, -1.0), Point(11.0, 10.0), ap_triangle).ϕ)
    @test intersection_point(Point(11.0, -1.0), Point(-1.0, 11.0), ap_triangle).ϕ ≈ 5.0703 atol = 0.001
    @test intersection_point(Point(-1.0, 11.0), Point(11.0, -1.0), ap_triangle).λ ≈ 10.000   atol = 0.001
end
