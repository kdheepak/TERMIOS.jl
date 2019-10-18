# TERMIOS

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kdheepak.github.io/TERMIOS.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kdheepak.github.io/TERMIOS.jl/dev)
[![Build Status](https://travis-ci.com/kdheepak/TERMIOS.jl.svg?branch=master)](https://travis-ci.com/kdheepak/TERMIOS.jl)
[![Codecov](https://codecov.io/gh/kdheepak/TERMIOS.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kdheepak/TERMIOS.jl)
[![Coveralls](https://coveralls.io/repos/github/kdheepak/TERMIOS.jl/badge.svg?branch=master)](https://coveralls.io/github/kdheepak/TERMIOS.jl?branch=master)

This package provides an interface to the POSIX calls for tty I/O control.

> The termios functions describe a general terminal interface that is
provided to control asynchronous communications ports.

For a complete description of these calls, see the [termios(3)](http://man7.org/linux/man-pages/man3/termios.3.html) manual page.

All functions in this package take a `RawFD` file descriptor `fd` as their first argument.
This can also be an integer file descriptor or a concrete instance of `Base.LibuvStream`, such as `stdin` or `stdout`.

This package defines the constants needed to work with the functions provided.
You may need to refer to your system documentation for more information on using this package.
