module TERMIOS

struct TERMIOSError <: Exception
    msg::String
end

Base.showerror(io::IO, e::TERMIOSError) = print(io, "TERMIOSError: $(e.msg)")

const tcflag_t = Sys.islinux() ? Cuint : Culong
const char     = Sys.islinux() ? Cchar : Cchar
const speed_t  = Sys.islinux() ? Cuint : Culong

const VEOF     = 0  #= ICANON                      =#
const VEOL     = 1  #= ICANON                      =#
const VEOL2    = 2  #= ICANON together with IEXTEN =#
const VERASE   = 3  #= ICANON                      =#
const VWERASE  = 4  #= ICANON together with IEXTEN =#
const VKILL    = 5  #= ICANON                      =#
const VREPRINT = 6  #= ICANON together with IEXTEN =#
const VINTR    = 8  #= ISIG                        =#
const VQUIT    = 9  #= ISIG                        =#
const VSUSP    = 10 #= ISIG                        =#
const VDSUSP   = 11 #= ISIG together with IEXTEN   =#
const VSTART   = 12 #= IXON, IXOFF                 =#
const VSTOP    = 13 #= IXON, IXOFF                 =#
const VLNEXT   = 14 #= IEXTEN                      =#
const VDISCARD = 15 #= IEXTEN                      =#
const VMIN     = 16 #= !ICANON                     =#
const VTIME    = 17 #= !ICANON                     =#
const VSTATUS  = 18 #= ICANON together with IEXTEN =#
const NCCS     = 20

#
# Input flags - software input processing
#

const IGNBRK  = 0x00000001 #= ignore BREAK condition           =#
const BRKINT  = 0x00000002 #= map BREAK to SIGINTR             =#
const IGNPAR  = 0x00000004 #= ignore (discard) parity errors   =#
const PARMRK  = 0x00000008 #= mark parity and framing errors   =#
const INPCK   = 0x00000010 #= enable checking of parity errors =#
const ISTRIP  = 0x00000020 #= strip 8th bit off chars          =#
const INLCR   = 0x00000040 #= map NL into CR                   =#
const IGNCR   = 0x00000080 #= ignore CR                        =#
const ICRNL   = 0x00000100 #= map CR to NL (ala CRMOD)         =#
const IXON    = 0x00000200 #= enable output flow control       =#
const IXOFF   = 0x00000400 #= enable input flow control        =#
const IXANY   = 0x00000800 #= any char will restart after stop =#
const IMAXBEL = 0x00002000 #= ring bell on input queue full    =#
const IUTF8   = 0x00004000 #= maintain state for UTF-8 VERASE  =#

#
# Output flags - software output processing
#

const OPOST  = 0x00000001 #= enable following output processing =#
const ONLCR  = 0x00000002 #= map NL to CR-NL (ala CRMOD)        =#
const OXTABS = 0x00000004 #= expand tabs to spaces              =#
const ONOEOT = 0x00000008 #= discard EOT's (^D) on output)      =#

#
# The following block of features is unimplemented.  Use of these flags in
# programs will currently result in unexpected behaviour.
#
# - Begin unimplemented features
#

const OCRNL  = 0x00000010 #= map CR to NL on output        =#
const ONOCR  = 0x00000020 #= no CR output at column 0      =#
const ONLRET = 0x00000040 #= NL performs CR function       =#
const OFILL  = 0x00000080 #= use fill characters for delay =#
const NLDLY  = 0x00000300 #= \n delay                      =#
const TABDLY = 0x00000c04 #= horizontal tab delay          =#
const CRDLY  = 0x00003000 #= \r delay                      =#
const FFDLY  = 0x00004000 #= form feed delay               =#
const BSDLY  = 0x00008000 #= \b delay                      =#
const VTDLY  = 0x00010000 #= vertical tab delay            =#
const OFDEL  = 0x00020000 #= fill is DEL, else NUL         =#

const NL0   = 0x00000000
const NL1   = 0x00000100
const NL2   = 0x00000200
const NL3   = 0x00000300
const TAB0  = 0x00000000
const TAB1  = 0x00000400
const TAB2  = 0x00000800
const TAB3  = 0x00000004
const CR0   = 0x00000000
const CR1   = 0x00001000
const CR2   = 0x00002000
const CR3   = 0x00003000
const FF0   = 0x00000000
const FF1   = 0x00004000
const BS0   = 0x00000000
const BS1   = 0x00008000
const VT0   = 0x00000000
const VT1   = 0x00010000

#
# + End unimplemented features
#

#
# Control flags - hardware control of terminal
#

const CIGNORE    = 0x00000001 #= ignore control flags       =#
const CSIZE      = 0x00000300 #= character size mask        =#
const CS5        = 0x00000000 #= 5 bits (pseudo)            =#
const CS6        = 0x00000100 #= 6 bits                     =#
const CS7        = 0x00000200 #= 7 bits                     =#
const CS8        = 0x00000300 #= 8 bits                     =#
const CSTOPB     = 0x00000400 #= send 2 stop bits           =#
const CREAD      = 0x00000800 #= enable receiver            =#
const PARENB     = 0x00001000 #= parity enable              =#
const PARODD     = 0x00002000 #= odd parity, else even      =#
const HUPCL      = 0x00004000 #= hang up on last close      =#
const CLOCAL     = 0x00008000 #= ignore modem status lines  =#
const CCTS_OFLOW = 0x00010000 #= CTS flow control of output =#
const CRTS_IFLOW = 0x00020000 #= RTS flow control of input  =#
const CDTR_IFLOW = 0x00040000 #= DTR flow control of input  =#
const CDSR_OFLOW = 0x00080000 #= DSR flow control of output =#
const CCAR_OFLOW = 0x00100000 #= DCD flow control of output =#
const MDMBUF     = 0x00100000 #= old name for CCAR_OFLOW    =#

const CRTSCTS    = (CCTS_OFLOW | CRTS_IFLOW)

#
# "Local" flags - dumping ground for other state
#
# Warning: some flags in this structure begin with
# the letter "I" and look like they belong in the
# input flag.
#

const ECHOKE     = 0x00000001 #= visual erase for line kill         =#
const ECHOE      = 0x00000002 #= visually erase chars               =#
const ECHOK      = 0x00000004 #= echo NL after line kill            =#
const ECHO       = 0x00000008 #= enable echoing                     =#
const ECHONL     = 0x00000010 #= echo NL even if ECHO is off        =#
const ECHOPRT    = 0x00000020 #= visual erase mode for hardcopy     =#
const ECHOCTL    = 0x00000040 #= echo control chars as ^(Char)      =#
const ISIG       = 0x00000080 #= enable signals INTR, QUIT, [D]SUSP =#
const ICANON     = 0x00000100 #= canonicalize input lines           =#
const ALTWERASE  = 0x00000200 #= use alternate WERASE algorithm     =#
const IEXTEN     = 0x00000400 #= enable DISCARD and LNEXT           =#
const EXTPROC    = 0x00000800 #= external processing                =#
const TOSTOP     = 0x00400000 #= stop background jobs from output   =#
const FLUSHO     = 0x00800000 #= output being flushed (state)       =#
const NOKERNINFO = 0x02000000 #= no kernel output from VSTATUS      =#
const PENDIN     = 0x20000000 #= XXX retype pending input (state)   =#
const NOFLSH     = 0x80000000 #= don't flush after interrupt        =#


#
# Commands passed to tcsetattr() for setting the termios structure.
#

const TCSANOW   = 0    #= make change immediate         =#
const TCSADRAIN = 1    #= drain output, then change     =#
const TCSAFLUSH = 2    #= drain output, flush input     =#
const TCSASOFT  = 0x10 #= flag - don't alter h.w. state =#

#
# Standard speeds
#

const B0        = 0
const B50       = 50
const B75       = 75
const B110      = 110
const B134      = 134
const B150      = 150
const B200      = 200
const B300      = 300
const B600      = 600
const B1200     = 1200
const B1800     = 1800
const B2400     = 2400
const B4800     = 4800
const B9600     = 9600
const B19200    = 19200
const B38400    = 38400
const B7200     = 7200
const B14400    = 14400
const B28800    = 28800
const B57600    = 57600
const B76800    = 76800
const B115200   = 115200
const B230400   = 230400
const EXTA      = 19200
const EXTB      = 38400

const TCIFLUSH  = 1
const TCOFLUSH  = 2
const TCIOFLUSH = 3
const TCOOFF    = 1
const TCOON     = 2
const TCIOFF    = 3
const TCION     = 4

mutable struct termios
    c_iflag::tcflag_t           #= input flags   =#
    c_oflag::tcflag_t           #= output flags  =#
    c_cflag::tcflag_t           #= control flags =#
    c_lflag::tcflag_t           #= local flags   =#
    @static if Sys.islinux()
        c_line::UInt8
    end
    c_cc::NTuple{NCCS, UInt8}   #= control chars =#
    c_ispeed::speed_t           #= input speed   =#
    c_ospeed::speed_t           #= output speed  =#
end

function init_termios()

    term = @static if Sys.islinux() termios(
            0,
            0,
            0,
            0,
            0,
            Tuple([0 for _ in 1:NCCS]),
            0,
            0
           )
    else
                             termios(
            0,
            0,
            0,
            0,
            Tuple([0 for _ in 1:NCCS]),
            0,
            0
           )
    end

   return term

end

# helper function
_file_handle(tty::Base.TTY) = ccall(:jl_uv_file_handle, Base.OS_HANDLE, (Ptr{Cvoid},), tty.handle)

"""
    tcgetattr(fd::RawFD, term::termios) -> Nothing
    tcgetattr(tty::Base.TTY, term::termios) -> Nothing
    tcgetattr(f::Int, term::termios) -> Nothing

Get the tty attributes for file descriptor fd
"""
function tcgetattr(fd::RawFD, term::termios)
    r = ccall(:tcgetattr, Cint, (Cint, Ptr{Cvoid}), fd, Ref(term))
    r == -1 && throw(TERMIOSError("tcgetattr failed."))
end
tcgetattr(tty::Base.TTY, term) = tcgetattr(_file_handle(tty), term)
tcgetattr(f::Int, term) = tcgetattr(RawFD(f), term)

"""
    tcsetattr(fd, when, attributes) -> Nothing

Set the tty attributes for file descriptor fd.
The when argument determines when the attributes are changed:

- termios.TCSANOW to change immediately
- termios.TCSADRAIN to change after transmitting all queued output
- termios.TCSAFLUSH to change after transmitting all queued output and discarding all queued input.
"""
function tcsetattr(fd::RawFD, when, term::termios)
    r = ccall(:tcgetattr, Cint, (Cint, Cint, Ptr{Cvoid}), fd, when, Ref(term))
    r == -1 && throw(TERMIOSError("tcsetattr failed."))
end
tcsetattr(tty::Base.TTY, when, term) = tcsetattr(_file_handle(tty), when, term)
tcsetattr(f::Int, when, term) = tcsetattr(RawFD(f), when, term)

"""
    tcdrain(fd) -> Nothing

Wait until all output written to file descriptor fd has been transmitted.
"""
function tcdrain(fd::RawFD)
    r = ccall(:tcdrain, Cint, (Cint, ), fd)
    r == -1 && throw(TERMIOSError("tcdrain failed."))
end
tcdrain(tty::Base.TTY) = tcdrain(_file_handle(tty))
tcdrain(f::Int) = tcdrain(RawFD(f))

"""
    tcflow(fd, action) -> Nothing

Suspend transmission or reception of data on the object referred to by fd, depending on the value of action:

- termios.TCOOFF to suspend output,
- termios.TCOON to restart output
- termios.TCIOFF to suspend input,
- termios.TCION to restart input.
"""
function tcflow(fd::RawFD, action::Int)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, action)
    r == -1 && throw(TERMIOSError("tcflow failed."))
end
tcflow(tty::Base.TTY, action) = tcflow(_file_handle(tty), action)
tcflow(fd::Int, action) = tcflow(RawFD(fd), action)

"""
    tcflush(fd, queue) -> Nothing

Discard data written to the object referred to by fd but not transmitted, or data received but not read, depending on the value of queue_selector:

- termios.TCIFLUSH flushes data received but not read.
- termios.TCOFLUSH flushes data written but not transmitted.
- termios.TCIOFLUSH flushes both data received but not read, and data written but not transmitted.
"""
function tcflush(fd::RawFD, queue::Int)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, queue)
    r == -1 && throw(TERMIOSError("tcflush failed."))
end
tcflush(tty::Base.TTY, queue) = tcflush(_file_handle(tty), queue)
tcflush(fd::Int, queue) = tcflush(RawFD(fd), queue)

"""
    tcsendbreak(tty::Base.TTY, duration::Int) -> Nothing

Transmit a continuous stream of zero-valued bits for a specific duration, if the terminal is using asynchronous serial data transmission. If duration is zero, it transmits zero-valued bits for at least 0.25 seconds, and not more that 0.5 seconds. If duration is not zero, it sends zero-valued bits for some implementation-defined length of time.

If the terminal is not using asynchronous serial data transmission, tcsendbreak() returns without taking any action.
"""
function tcsendbreak(fd::RawFD, duration::Int)
    r = ccall(:tcsendbreak, Cint, (Cint, Cint), fd, duration)
    r == -1 && throw(TERMIOSError("tcsendbreak failed."))
end
tcsendbreak(tty::Base.TTY, duration) = tcsendbreak(_file_handle(tty), duration)
tcsendbreak(f::Int, duration) = tcsendbreak(RawFD(f), duration)

"""
    cfmakeraw(term::termios)

Set the terminal to something like the "raw" mode of the old Version 7 terminal driver: input is available character by character, echoing is disabled, and all special processing of terminal input and output characters is disabled. The terminal attributes are set as follows:

termios_p->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP
                | INLCR | IGNCR | ICRNL | IXON);
termios_p->c_oflag &= ~OPOST;
termios_p->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
termios_p->c_cflag &= ~(CSIZE | PARENB);
termios_p->c_cflag |= CS8;
"""
function cfmakeraw(term::termios)
    r = ccall(:cfmakeraw, Cint, (Ref{termios},) Ref(term))
    r == -1 && throw(TERMIOSError("cfmakeraw failed."))
end

"""
    cfsetspeed(term::termios, speed::Int)

is a 4.4BSD extension. It takes the same arguments as cfsetispeed(), and sets both input and output speed.
"""
function cfsetspeed(term::termios, speed::Int)
    r = ccall(:cfsetspeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 && throw(TERMIOSError("cfsetspeed failed."))
end

"""
    cfgetispeed(term::termios)

Returns the input baud rate stored in the termios structure.
"""
cfgetispeed(term::termios) = ccall(:cfgetispeed, speed_t, (Ptr{termios}, ), Ref(term))

"""
    cfgetospeed(term::termios)

Returns the output baud rate stored in the termios structure.
"""
cfgetospeed(term::termios) = ccall(:cfgetospeed, speed_t, (Ptr{termios}, ), Ref(term))

"""
    cfsetispeed(term::termios, speed::Int)

sets the input baud rate stored in the termios structure to speed, which must be one of these constants:
- B0
- B50
- B75
- B110
- B134
- B150
- B200
- B300
- B600
- B1200
- B1800
- B2400
- B4800
- B9600
- B19200
- B38400
- B57600
- B115200
- B230400

The zero baud rate, B0, is used to terminate the connection. If B0 is specified, the modem control lines shall no longer be asserted. Normally, this will disconnect the line. CBAUDEX is a mask for the speeds beyond those defined in POSIX.1 (57600 and above). Thus, B57600 & CBAUDEX is nonzero.
"""
function cfsetispeed(term::termios, speed::Int)
    r = ccall(:cfsetispeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 && throw(TERMIOSError("cfsetispeed failed."))
end


"""
    cfsetospeed(term::termios, speed::Int)

sets the output baud rate stored in the termios structure to speed, which must be one of these constants:
- B0
- B50
- B75
- B110
- B134
- B150
- B200
- B300
- B600
- B1200
- B1800
- B2400
- B4800
- B9600
- B19200
- B38400
- B57600
- B115200
- B230400

The zero baud rate, B0, is used to terminate the connection. If B0 is specified, the modem control lines shall no longer be asserted. Normally, this will disconnect the line. CBAUDEX is a mask for the speeds beyond those defined in POSIX.1 (57600 and above). Thus, B57600 & CBAUDEX is nonzero.
"""
function cfsetospeed(term::termios, speed::Int)
    r = ccall(:cfsetospeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 && throw(TERMIOSError("cfsetospeed failed."))
end

end # module
