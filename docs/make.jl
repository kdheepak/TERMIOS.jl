using Documenter, TERMIOS, DocumenterMarkdown

cp(joinpath(@__DIR__, "../README.md"), joinpath(@__DIR__, "./src/index.md"), force=true, follow_symlinks=true)

makedocs(
         sitename="TERMIOS.jl documentation",
         format = Markdown()
        )

deploydocs(;
    repo="github.com/kdheepak/TERMIOS.jl",
    deps = Deps.pip(
                   "mkdocs==0.17.5",
                   "mkdocs-material==2.9.4",
                   "python-markdown-math",
                   "pygments",
                   "pymdown-extensions",
                   ),
    make = () -> run(`mkdocs build`),
    target = "site",
)
