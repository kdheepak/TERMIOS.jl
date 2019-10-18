using Documenter, termios

makedocs(;
    modules=[termios],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/kdheepak/termios.jl/blob/{commit}{path}#L{line}",
    sitename="termios.jl",
    authors="Dheepak Krishnamurthy",
    assets=String[],
)

deploydocs(;
    repo="github.com/kdheepak/termios.jl",
)
