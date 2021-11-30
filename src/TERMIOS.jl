"""
This package provides an interface to the POSIX calls for tty I/O control.

For a complete description of these calls, see the [termios(3)](http://man7.org/linux/man-pages/man3/termios.3.html) manual page.

**Usage**

Example:

    using TERMIOS
    const T = TERMIOS
    term_stdin = T.termios()
    T.tcgetattr(stdin, term_stdin)
    term_stdin.c_iflag |= T.IGNBRK
    T.tcsetattr(stdin, T.TCSANOW, term_stdin)

"""
module TERMIOS

struct TERMIOSError <: Exception
    msg::String
end

Base.showerror(io::IO, e::TERMIOSError) = print(io, "TERMIOSError: $(e.msg)")

const cc_t = Sys.islinux() ? Cuchar : Cvoid
const tcflag_t = Sys.islinux() ? Cuint : Culong
const char = Sys.islinux() ? Cchar : Cchar
const speed_t = Sys.islinux() ? Cuint : Culong

"""End-of-file character ICANON"""
const VEOF = Sys.islinux() ? 4 : 0

"""End-of-line character ICANON"""
const VEOL = Sys.islinux() ? 11 : 1

"""Second EOL character ICANON together with IEXTEN"""
const VEOL2 = Sys.islinux() ? 16 : 2

"""Erase character ICANON"""
const VERASE = Sys.islinux() ? 2 : 3

"""Word-erase character ICANON together with IEXTEN"""
const VWERASE = Sys.islinux() ? 14 : 4

"""Kill-line character ICANON"""
const VKILL = Sys.islinux() ? 3 : 5

"""Reprint-line character ICANON together with IEXTEN"""
const VREPRINT = Sys.islinux() ? 12 : 6

"""Interrupt character ISIG"""
const VINTR = Sys.islinux() ? 0 : 8

"""Quit character ISIG"""
const VQUIT = Sys.islinux() ? 1 : 9

"""Suspend character ISIG"""
const VSUSP = Sys.islinux() ? 10 : 10

"""Delayed suspend character ISIG together with IEXTEN"""
const VDSUSP = Sys.islinux() ? nothing : 11

"""Start (X-ON) character IXON, IXOFF"""
const VSTART = Sys.islinux() ? 8 : 12

"""Stop (X-OFF) character IXON, IXOFF"""
const VSTOP = Sys.islinux() ? 9 : 13

"""Literal-next character IEXTEN"""
const VLNEXT = Sys.islinux() ? 15 : 14

"""Discard character IEXTEN"""
const VDISCARD = Sys.islinux() ? 13 : 15

"""Minimum number of bytes read at once !ICANON"""
const VMIN = Sys.islinux() ? 6 : 16

"""Time-out value (tenths of a second) !ICANON"""
const VTIME = Sys.islinux() ? 5 : 17

"""Status character ICANON together with IEXTEN"""
const VSTATUS = Sys.islinux() ? nothing : 18

const NCCS = Sys.islinux() ? 32 : 20

const VSWTC = Sys.islinux() ? 7 : nothing

#
# Input flags - software input processing
#

"""Ignore BREAK condition"""
const IGNBRK = 0x00000001

"""Map BREAK to SIGINTR"""
const BRKINT = 0x00000002

"""Ignore (discard) parity errors"""
const IGNPAR = 0x00000004

"""Mark parity and framing errors"""
const PARMRK = 0x00000008

"""Enable checking of parity errors"""
const INPCK = 0x00000010

"""Strip 8th bit off chars"""
const ISTRIP = 0x00000020

"""Map NL into CR"""
const INLCR = 0x00000040

"""Ignore CR"""
const IGNCR = 0x00000080

"""Map CR to NL (ala CRMOD)"""
const ICRNL = 0x00000100

"""Enable output flow control"""
const IXON = Sys.islinux() ? 0x00000400 : 0x00000200

"""Enable input flow control"""
const IXOFF = Sys.islinux() ? 0x00001000 : 0x00000400

"""Any char will restart after stop"""
const IXANY = 0x00000800

"""Ring bell on input queue full"""
const IMAXBEL = Sys.islinux() ? nothing : 0x00002000

"""(macos) maintain state for UTF-8 VERASE"""
const IUTF8 = Sys.islinux() ? nothing : 0x00004000

"""(glibc) Translate upper case input to lower case."""
const IUCLC = Sys.islinux() ? (1 << 14) : nothing

#
# Output flags - software output processing
#

"""Enable following output processing """
const OPOST = 0x00000001

"""Map NL to CR-NL (ala CRMOD)"""
const ONLCR = Sys.islinux() ? 0x00000004 : 0x00000002

"""Expand tabs to spaces"""
const OXTABS = 0x00000004

"""Discard EOT's (^D) on output)"""
const ONOEOT = 0x00000008

"""Map CR to NL on output"""
const OCRNL = Sys.islinux() ? 0x00000008 : 0x00000010

"""No CR output at column 0"""
const ONOCR = Sys.islinux() ? 0x00000010 : 0x00000020

"""NL performs CR function"""
const ONLRET = Sys.islinux() ? 0x00000020 : 0x00000040

raw"""\n delay"""
const NLDLY = Sys.islinux() ? 0x00000100 : 0x00000300

"""Horizontal tab delay"""
const TABDLY = Sys.islinux() ? 0x00001800 : 0x00000c04

raw"""\r delay"""
const CRDLY = Sys.islinux() ? 0x00000600 : 0x00003000

"""Form feed delay"""
const FFDLY = Sys.islinux() ? 0x00008000 : 0x00004000

raw"""\b delay"""
const BSDLY = Sys.islinux() ? 0x00002000 : 0x00008000

"""Vertical tab delay"""
const VTDLY = Sys.islinux() ? 0x00004000 : 0x00010000

"""NL type 0."""
const NL0 = 0x00000000

"""NL type 1."""

const NL1 = 0x00000100
const NL2 = Sys.islinux() ? nothing : 0x00000200
const NL3 = Sys.islinux() ? nothing : 0x00000300

"""TAB delay type 0."""
const TAB0 = 0x00000000

"""TAB delay type 1."""
const TAB1 = Sys.islinux() ? 0x00000800 : 0x00000400

"""TAB delay type 2."""
const TAB2 = Sys.islinux() ? 0x00001000 : 0x00000800

"""Expand tabs to spaces."""
const TAB3 = Sys.islinux() ? 0x00001800 : 0x00000004

"""CR delay type 0."""
const CR0 = 0x00000000

"""CR delay type 1."""
const CR1 = Sys.islinux() ? 0x00000200 : 0x00001000

"""CR delay type 2."""
const CR2 = Sys.islinux() ? 0x00000400 : 0x00002000

"""CR delay type 3."""
const CR3 = Sys.islinux() ? 0x00000600 : 0x00003000

"""FF delay type 0."""
const FF0 = 0x00000000

"""FF delay type 1."""
const FF1 = Sys.islinux() ? 0x00008000 : 0x00004000

"""BS delay type 0."""
const BS0 = 0x00000000

"""BS delay type 1."""
const BS1 = Sys.islinux() ? 0x00002000 : 0x00008000

"""VT delay type 0."""
const VT0 = 0x00000000

"""VT delay type 1."""
const VT1 = Sys.islinux() ? 0x00004000 : 0x00010000

"""(glibc) Translate lower case output to upper case."""
const OLCUC = Sys.islinux() ? (1 << 17) : nothing

"""Use fill characters for delay"""
const OFILL = Sys.islinux() ? 0x00000040 : 0x00000080

"""Fill is DEL, else NUL"""
const OFDEL = Sys.islinux() ? nothing : 0x00020000

#
# Control flags - hardware control of terminal
#

"""Ignore control flags"""
const CIGNORE = Sys.islinux() ? nothing : 0x00000001

"""5 bits (pseudo)"""
const CS5 = 0x00000000

"""6 bits"""
const CS6 = Sys.islinux() ? 0x00000010 : 0x00000100

"""7 bits"""
const CS7 = Sys.islinux() ? 0x00000020 : 0x00000200

"""8 bits"""
const CS8 = CS6 | CS7

"""Character size mask"""
const CSIZE = CS5 | CS6 | CS7 | CS8

"""Send 2 stop bits"""
const CSTOPB = Sys.islinux() ? 0x00000040 : 0x00000400

"""Enable receiver"""
const CREAD = Sys.islinux() ? 0x00000080 : 0x00000800

"""Parity enable"""
const PARENB = Sys.islinux() ? 0x00000100 : 0x00001000

"""Odd parity, else even"""
const PARODD = Sys.islinux() ? 0x00000200 : 0x00002000

"""Hang up on last close"""
const HUPCL = Sys.islinux() ? 0x00000400 : 0x00004000

"""Ignore modem status lines"""
const CLOCAL = Sys.islinux() ? 0x00000800 : 0x00008000

"""CTS flow control of output"""
const CCTS_OFLOW = Sys.islinux() ? nothing : 0x00010000

"""RTS flow control of input"""
const CRTS_IFLOW = Sys.islinux() ? nothing : 0x00020000

"""DTR flow control of input"""
const CDTR_IFLOW = Sys.islinux() ? nothing : 0x00040000

"""DSR flow control of output"""
const CDSR_OFLOW = Sys.islinux() ? nothing : 0x00080000

"""DCD flow control of output"""
const CCAR_OFLOW = Sys.islinux() ? nothing : 0x00100000

"""Old name for CCAR_OFLOW"""
const MDMBUF = Sys.islinux() ? nothing : 0x00100000
const CRTSCTS = Sys.islinux() ? nothing : (CCTS_OFLOW | CRTS_IFLOW)

#
# "Local" flags - dumping ground for other state
#
# Warning: some flags in this structure begin with
# the letter "I" and look like they belong in the
# input flag.
#

"""Visual erase for line kill"""
const ECHOKE = Sys.islinux() ? nothing : 0x00000001

"""Visually erase chars"""
const ECHOE = Sys.islinux() ? 0x00000010 : 0x00000002

"""Echo NL after line kill"""
const ECHOK = Sys.islinux() ? 0x00000020 : 0x00000004

"""Enable echoing"""
const ECHO = 0x00000008

"""Echo NL even if ECHO is off"""
const ECHONL = Sys.islinux() ? 0x00000040 : 0x00000010

"""Visual erase mode for hardcopy"""
const ECHOPRT = Sys.islinux() ? nothing : 0x00000020

"""Echo control chars as ^(Char)"""
const ECHOCTL = Sys.islinux() ? nothing : 0x00000040

"""Enable signals INTR, QUIT, [D]SUSP"""
const ISIG = Sys.islinux() ? 0x00000001 : 0x00000080

"""Canonicalize input lines"""
const ICANON = Sys.islinux() ? 0x00000002 : 0x00000100

"""Use alternate WERASE algorithm"""
const ALTWERASE = Sys.islinux() ? nothing : 0x00000200

"""Enable DISCARD and LNEXT"""
const IEXTEN = Sys.islinux() ? 0x00008000 : 0x00000400

"""External processing"""
const EXTPROC = Sys.islinux() ? nothing : 0x00000800

"""Stop background jobs from output"""
const TOSTOP = Sys.islinux() ? 0x00000100 : 0x00400000

"""Output being flushed (state)"""
const FLUSHO = Sys.islinux() ? nothing : 0x00800000

"""No kernel output from VSTATUS"""
const NOKERNINFO = Sys.islinux() ? nothing : 0x02000000

"""XXX retype pending input (state)"""
const PENDIN = Sys.islinux() ? nothing : 0x20000000

"""Don't flush after interrupt"""
const NOFLSH = Sys.islinux() ? 0x00000080 : 0x80000000

#
# Commands passed to tcsetattr() for setting the termios structure.
#

"""Make change immediate"""
const TCSANOW = 0

"""Drain output, then change"""
const TCSADRAIN = 1

"""Drain output, flush input"""
const TCSAFLUSH = 2

"""Flag - don't alter h.w. state"""
const TCSASOFT = Sys.islinux() ? nothing : 0x10

#
# Standard speeds
#

const B0 = Sys.islinux() ? 0 : 0
const B50 = Sys.islinux() ? 1 : 50
const B75 = Sys.islinux() ? 2 : 75
const B110 = Sys.islinux() ? 3 : 110
const B134 = Sys.islinux() ? 4 : 134
const B150 = Sys.islinux() ? 5 : 150
const B200 = Sys.islinux() ? 6 : 200
const B300 = Sys.islinux() ? 7 : 300
const B600 = Sys.islinux() ? 8 : 600
const B1200 = Sys.islinux() ? 9 : 1200
const B1800 = Sys.islinux() ? 10 : 1800
const B2400 = Sys.islinux() ? 11 : 2400
const B4800 = Sys.islinux() ? 12 : 4800
const B7200 = Sys.islinux() ? 13 : 7200
const B19200 = Sys.islinux() ? 14 : 19200
const B38400 = Sys.islinux() ? 15 : 38400
const B9600 = 9600
const B14400 = 14400
const B28800 = 28800
const B57600 = 57600
const B76800 = 76800
const B115200 = 115200
const B230400 = 230400
const EXTA = 19200
const EXTB = 38400

const B460800 = 460800
const B500000 = 500000
const B576000 = 576000
const B921600 = 921600
const B1000000 = 1000000
const B1152000 = 1152000
const B1500000 = 1500000
const B2000000 = 2000000
const B2500000 = 2500000
const B3000000 = 3000000
const B3500000 = 3500000
const B4000000 = 4000000

#
# Values for the QUEUE_SELECTOR argument to `tcflush'.
#
"""Discard data received but not yet read."""
const TCIFLUSH = Sys.islinux() ? 0 : 1

"""Discard data written but not yet sent."""
const TCOFLUSH = Sys.islinux() ? 1 : 2

"""Discard all pending data."""
const TCIOFLUSH = Sys.islinux() ? 2 : 3

#
# Values for the ACTION argument to `tcflow'.
#

"""Suspend output."""
const TCOOFF = Sys.islinux() ? 16 : 1

"""Restart suspended output."""
const TCOON = Sys.islinux() ? 32 : 2

"""Send a STOP character."""
const TCIOFF = Sys.islinux() ? 4 : 3

"""Send a START character."""
const TCION = Sys.islinux() ? 8 : 4

########################################################################################################################

# The layout of a termios struct in C must be as follows
#
# ```c
# struct termios {
# 	tcflag_t	c_iflag;
# 	tcflag_t	c_oflag;
# 	tcflag_t	c_cflag;
# 	tcflag_t	c_lflag;
# 	cc_t		c_line;
# 	cc_t		c_cc[NCCS];
# 	speed_t		c_ispeed;
# 	speed_t		c_ospeed;
# };
# ```
#
# We need to create this struct in Julia and set the memory layout in Julia.
# the termios library requires passing in a termios struct that is used to get or set attributes
# There are two ways to create a `struct` in Julia that affect the memory layout.
# `struct termios end` and `mutable struct termios end`
# The first one is a immutable, and cannot be passed as a reference into a library.
# Additionally, because it is a immutable, Julia may make a copy of the struct instead of passing in the reference.
# The second one is what we want.
# Typical workflow in using the termios library involves using `tcgetattr` to initialize a termios struct, changing values appropriately
# and using `tcsetattr` to set the attributes.
# the termios struct has a field `c_cc[NCCS]`.
# This field is laid out sequentially in memory.
# In Julia, there are two ways to lay out memory sequentially. We can either
# 1) use a `NTuple{NCCS, UInt8}`
# 2) lay out the memory manually
# Tuples are immutable, which means if a user wants to change `termios.c_cc`, they would have to create a new tuple with the values needed.
# In both of these approaches, we can use `getproperty` to mimic the interface presented in C

mutable struct termios
    """Input flags"""
    c_iflag::tcflag_t
    """Output flags"""
    c_oflag::tcflag_t
    """Control flags"""
    c_cflag::tcflag_t
    """Local flags"""
    c_lflag::tcflag_t
    @static if Sys.islinux()
        c_line::cc_t
    end
    """Control chars"""
    _c_cc::NTuple{NCCS, UInt8}
    """Input speed"""
    c_ispeed::speed_t
    """Output speed"""
    c_ospeed::speed_t
end

function Base.getproperty(t::termios, name::Symbol)
    if name == :c_cc
        return _C_CC(t)
    else
        return getfield(t, name)
    end
end

function Base.propertynames(t::termios, private = false)
    return @static if Sys.islinux()
        (
            :c_iflag,
            :c_oflag,
            :c_cflag,
            :c_lflag,
            :c_cc,
            :c_ispeed,
            :c_ospeed,
        )
    else
        (
            :c_iflag,
            :c_oflag,
            :c_cflag,
            :c_lflag,
            :c_line,
            :c_cc,
            :c_ispeed,
            :c_ospeed,
        )
    end
end

struct _C_CC
    ref::termios
end

function Base.getindex(c_cc::_C_CC, index)
    return collect(c_cc.ref._c_cc)[index + 1]
end

function Base.setindex!(c_cc::_C_CC, value, index)
    _c_cc = collect(c_cc.ref._c_cc)
    _c_cc[index + 1] = value
    c_cc.ref._c_cc = NTuple{NCCS, UInt8}(_c_cc)
end

function Base.show(io::IO, ::MIME"text/plain", c_cc::_C_CC)
    X = [getfield(c_cc.ref, Symbol("_c_cc$i")) for i in 1:NCCS]
    summary(io, X)
    isempty(X) && return
    print(io, ":")
    if !haskey(io, :compact) && length(axes(X, 2)) > 1
        io = IOContext(io, :compact => true)
    end
    if get(io, :limit, false) && eltype(X) === Method
        # override usual show method for Vector{Method}: don't abbreviate long lists
        io = IOContext(io, :limit => false)
    end
    if get(io, :limit, false) && displaysize(io)[1]-4 <= 0
        return print(io, " …")
    else
        println(io)
    end
    io = IOContext(io, :typeinfo => eltype(X))
    Base.print_array(io, X)
end


function termios()

    term = @static if Sys.islinux()
        termios(
            0,
            0,
            0,
            0,
            0,
            NTuple{NCCS, UInt8}([0 for _ in 1:NCCS]),
            0,
            0,
        )
    else
        termios(
            0,
            0,
            0,
            0,
            NTuple{NCCS, UInt8}([0 for _ in 1:NCCS]),
            0,
            0,
        )
    end

   return term

end

# helper function
_file_handle(s::Base.LibuvStream) = Base._fd(s)

"""
    tcgetattr(fd::RawFD, term::termios)
    tcgetattr(s::Base.LibuvStream, term::termios)
    tcgetattr(f::Int, term::termios)

Get the tty attributes for file descriptor fd
"""
function tcgetattr(fd::RawFD, term::termios)
    r = ccall(:tcgetattr, Cint, (Cint, Ptr{Cvoid}), fd, Ref(term))
    r == -1 ? throw(TERMIOSError("tcgetattr failed: $(Base.Libc.strerror())")) : nothing
end
tcgetattr(s::Base.LibuvStream, term) = tcgetattr(_file_handle(s), term)
tcgetattr(f::Int, term) = tcgetattr(RawFD(f), term)

"""
    tcsetattr(s::Base.LibuvStream, when::Integer, term::termios)

Set the tty attributes for file descriptor fd.
The when argument determines when the attributes are changed:

- `TERMIOS.TCSANOW` to change immediately
- `TERMIOS.TCSADRAIN` to change after transmitting all queued output
- `TERMIOS.TCSAFLUSH` to change after transmitting all queued output and discarding all queued input.
"""
function tcsetattr(fd::RawFD, when::Integer, term::termios)
    r = ccall(:tcsetattr, Cint, (Cint, Cint, Ptr{Cvoid}), fd, when, Ref(term))
    r == -1 ? throw(TERMIOSError("tcsetattr failed: $(Base.Libc.strerror())")) : nothing
end
tcsetattr(s::Base.LibuvStream, when, term) = tcsetattr(_file_handle(s), when, term)
tcsetattr(f::Int, when, term) = tcsetattr(RawFD(f), when, term)

"""
    tcdrain(s::Base.LibuvStream)

Wait until all output written to file descriptor fd has been transmitted.
"""
function tcdrain(fd::RawFD)
    r = ccall(:tcdrain, Cint, (Cint, ), fd)
    r == -1 ? throw(TERMIOSError("tcdrain failed: $(Base.Libc.strerror())")) : nothing
end
tcdrain(s::Base.LibuvStream) = tcdrain(_file_handle(s))
tcdrain(f::Int) = tcdrain(RawFD(f))

"""
    tcflow(s::Base.LibuvStream, action::Integer)

Suspend transmission or reception of data on the object referred to by fd, depending on the value of action:

- `TERMIOS.TCOOFF` to suspend output,
- `TERMIOS.TCOON` to restart output
- `TERMIOS.TCIOFF` to suspend input,
- `TERMIOS.TCION` to restart input.
"""
function tcflow(fd::RawFD, action::Integer)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, action)
    r == -1 ? throw(TERMIOSError("tcflow failed: $(Base.Libc.strerror())")) : nothing
end
tcflow(s::Base.LibuvStream, action) = tcflow(_file_handle(s), action)
tcflow(fd::Int, action) = tcflow(RawFD(fd), action)

"""
    tcflush(s::Base.LibuvStream, queue::Integer)

Discard data written to the object referred to by fd but not transmitted, or data received but not read, depending on the value of queue_selector:

- `TERMIOS.TCIFLUSH` flushes data received but not read.
- `TERMIOS.TCOFLUSH` flushes data written but not transmitted.
- `TERMIOS.TCIOFLUSH` flushes both data received but not read, and data written but not transmitted.
"""
function tcflush(fd::RawFD, queue::Integer)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, queue)
    r == -1 ? throw(TERMIOSError("tcflush failed: $(Base.Libc.strerror())")) : nothing
end
tcflush(s::Base.LibuvStream, queue) = tcflush(_file_handle(s), queue)
tcflush(fd::Int, queue) = tcflush(RawFD(fd), queue)

"""
    tcsendbreak(s::Base.LibuvStream, duration::Integer)

Transmit a continuous stream of zero-valued bits for a specific duration, if the terminal is using asynchronous serial data transmission. If duration is zero, it transmits zero-valued bits for at least 0.25 seconds, and not more that 0.5 seconds. If duration is not zero, it sends zero-valued bits for some implementation-defined length of time.

If the terminal is not using asynchronous serial data transmission, tcsendbreak() returns without taking any action.
"""
function tcsendbreak(fd::RawFD, duration::Integer)
    r = ccall(:tcsendbreak, Cint, (Cint, Cint), fd, duration)
    r == -1 ? throw(TERMIOSError("tcsendbreak failed: $(Base.Libc.strerror())")) : nothing
end
tcsendbreak(s::Base.LibuvStream, duration) = tcsendbreak(_file_handle(s), duration)
tcsendbreak(f::Int, duration) = tcsendbreak(RawFD(f), duration)

"""
    cfmakeraw(term::termios)

Set the terminal to something like the "raw" mode of the old Version 7 terminal driver: input is available character by character, echoing is disabled, and all special processing of terminal input and output characters is disabled. The terminal attributes are set as follows:

    term.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP
                 | INLCR | IGNCR | ICRNL | IXON);
    term.c_oflag &= ~OPOST;
    term.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    term.c_cflag &= ~(CSIZE | PARENB);
    term.c_cflag |= CS8;
"""
function cfmakeraw(term::termios)
    r = ccall(:cfmakeraw, Cint, (Ref{termios},), Ref(term))
    r == -1 ? throw(TERMIOSError("cfmakeraw failed: $(Base.Libc.strerror())")) : nothing
end

"""
    cfsetspeed(term::termios, speed::Int)

is a 4.4BSD extension. It takes the same arguments as cfsetispeed(), and sets both input and output speed.
"""
function cfsetspeed(term::termios, speed::Integer)
    r = ccall(:cfsetspeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 ? throw(TERMIOSError("cfsetspeed failed: $(Base.Libc.strerror())")) : nothing
end

"""
    cfgetispeed(term::termios) -> Int

Returns the input baud rate stored in the termios structure.
"""
cfgetispeed(term::termios) = ccall(:cfgetispeed, speed_t, (Ptr{termios}, ), Ref(term))

"""
    cfgetospeed(term::termios) -> Int

Returns the output baud rate stored in the termios structure.
"""
cfgetospeed(term::termios) = ccall(:cfgetospeed, speed_t, (Ptr{termios}, ), Ref(term))

"""
    cfsetispeed(term::termios, speed::Integer)

sets the input baud rate stored in the termios structure to speed, which must be one of these constants:
- `TERMIOS.B0`
- `TERMIOS.B50`
- `TERMIOS.B75`
- `TERMIOS.B110`
- `TERMIOS.B134`
- `TERMIOS.B150`
- `TERMIOS.B200`
- `TERMIOS.B300`
- `TERMIOS.B600`
- `TERMIOS.B1200`
- `TERMIOS.B1800`
- `TERMIOS.B2400`
- `TERMIOS.B4800`
- `TERMIOS.B9600`
- `TERMIOS.B19200`
- `TERMIOS.B38400`
- `TERMIOS.B57600`
- `TERMIOS.B115200`
- `TERMIOS.B230400`

The zero baud rate, B0, is used to terminate the connection. If B0 is specified, the modem control lines shall no longer be asserted. Normally, this will disconnect the line. CBAUDEX is a mask for the speeds beyond those defined in POSIX.1 (57600 and above). Thus, B57600 & CBAUDEX is nonzero.
"""
function cfsetispeed(term::termios, speed::Integer)
    r = ccall(:cfsetispeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 ? throw(TERMIOSError("cfsetispeed failed: $(Base.Libc.strerror())")) : nothing
end


"""
    cfsetospeed(term::termios, speed::Integer)

sets the output baud rate stored in the termios structure to speed, which must be one of these constants:
- `TERMIOS.B0`
- `TERMIOS.B50`
- `TERMIOS.B75`
- `TERMIOS.B110`
- `TERMIOS.B134`
- `TERMIOS.B150`
- `TERMIOS.B200`
- `TERMIOS.B300`
- `TERMIOS.B600`
- `TERMIOS.B1200`
- `TERMIOS.B1800`
- `TERMIOS.B2400`
- `TERMIOS.B4800`
- `TERMIOS.B9600`
- `TERMIOS.B19200`
- `TERMIOS.B38400`
- `TERMIOS.B57600`
- `TERMIOS.B115200`
- `TERMIOS.B230400`

The zero baud rate, B0, is used to terminate the connection. If B0 is specified, the modem control lines shall no longer be asserted. Normally, this will disconnect the line. CBAUDEX is a mask for the speeds beyond those defined in POSIX.1 (57600 and above). Thus, B57600 & CBAUDEX is nonzero.
"""
function cfsetospeed(term::termios, speed::Integer)
    r = ccall(:cfsetospeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 ? throw(TERMIOSError("cfsetospeed failed: $(Base.Libc.strerror())")) : nothing
end

end # module
