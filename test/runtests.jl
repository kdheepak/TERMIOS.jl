using TERMIOS
using Test

const c_iflag = Sys.islinux() ? 0x00000500 : 0x0000000000002b02
const c_oflag = Sys.islinux() ? 0x00000005 : 0x0000000000000003
const c_cflag = Sys.islinux() ? 0x000000bf : 0x0000000000004b00
const c_lflag = Sys.islinux() ? 0x00008a3b : 0x00000000000005cb
const c_cc = Sys.islinux() ? (0x03, 0x1c, 0x7f, 0x15, 0x04, 0x00, 0x01, 0x00, 0x11, 0x13, 0x1a, 0x00, 0x12, 0x0f, 0x17, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00) : (0x04, 0xff, 0xff, 0x7f, 0x17, 0x15, 0x12, 0xff, 0x03, 0x1c, 0x1a, 0x19, 0x11, 0x13, 0x16, 0x0f, 0x01, 0x00, 0x14, 0xff)
const c_ispeed = Sys.islinux() ? 0x0000000f : 0x0000000000002580
const c_ospeed = Sys.islinux() ? 0x0000000f : 0x0000000000002580

@testset "All" begin
@testset "termios.jl stdout" begin

    term = TERMIOS.termios()
    TERMIOS.tcgetattr(stdout, term)
    @test term.c_iflag == c_iflag
    @test term.c_oflag == c_oflag
    @test term.c_cflag == c_cflag
    @test term.c_lflag == c_lflag
    @test_broken term.c_cc == c_cc
    @test term.c_ispeed == c_ispeed
    @test term.c_ospeed == c_ospeed

    term = TERMIOS.termios()
    TERMIOS.tcgetattr(0, term)
    @test term.c_iflag == c_iflag
    @test term.c_oflag == c_oflag
    @test term.c_cflag == c_cflag
    @test term.c_lflag == c_lflag
    @test_broken term.c_cc == c_cc
    @test term.c_ispeed == c_ispeed
    @test term.c_ospeed == c_ospeed

    term = TERMIOS.termios()
    TERMIOS.tcgetattr(0, term)
    @test TERMIOS.cfgetispeed(term) == term.c_ispeed
    @test TERMIOS.cfgetospeed(term) == term.c_ospeed

    TERMIOS.cfsetispeed(term, term.c_ispeed)
    @test TERMIOS.cfgetispeed(term) == term.c_ispeed

    TERMIOS.cfsetospeed(term, term.c_ospeed)
    @test TERMIOS.cfgetospeed(term) == term.c_ospeed

    term = TERMIOS.termios()
    TERMIOS.tcgetattr(0, term)
    TERMIOS.tcsetattr(0, TERMIOS.TCSANOW, term)
    @test TERMIOS.cfgetispeed(term) == term.c_ispeed
    @test TERMIOS.cfgetospeed(term) == term.c_ospeed

end

@testset "termios.jl stdin" begin

    term = TERMIOS.termios()
    TERMIOS.tcgetattr(stdin, term)
    @test term.c_iflag == c_iflag
    @test term.c_oflag == c_oflag
    @test term.c_cflag == c_cflag
    @test term.c_lflag == c_lflag
    @test_broken term.c_cc == c_cc
    @test term.c_ispeed == c_ispeed
    @test term.c_ospeed == c_ospeed

end
end
