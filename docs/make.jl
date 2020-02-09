using Documenter, Navigation

makedocs(
    sitename = "Navigation.jl",
    modules = [Navigation],
    pages = Any[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/rjdverbeek-tud/Navigation.jl.git",
)
