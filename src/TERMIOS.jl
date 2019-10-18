module TERMIOS

struct TERMIOSError <: Exception
    msg::String
end

Base.showerror(io::IO, e::TERMIOSError) = print(io, "TERMIOSError: $(e.msg)")

const cc_t     = Sys.islinux() ? Cuchar : Cvoid
const tcflag_t = Sys.islinux() ? Cuint  : Culong
const char     = Sys.islinux() ? Cchar  : Cchar
const speed_t  = Sys.islinux() ? Cuint  : Culong

const VEOF     = Sys.islinux() ? 4       : 0  #= End-of-file character ICANON                        =#
const VEOL     = Sys.islinux() ? 11      : 1  #= End-of-line character ICANON                        =#
const VEOL2    = Sys.islinux() ? 16      : 2  #= Second EOL character ICANON together with IEXTEN    =#
const VERASE   = Sys.islinux() ? 2       : 3  #= Erase character ICANON                              =#
const VWERASE  = Sys.islinux() ? 14      : 4  #= Word-erase character  ICANON together with IEXTEN   =#
const VKILL    = Sys.islinux() ? 3       : 5  #= Kill-line character ICANON                          =#
const VREPRINT = Sys.islinux() ? 12      : 6  #= Reprint-line character ICANON together with IEXTEN  =#
const VINTR    = Sys.islinux() ? 0       : 8  #= Interrupt character ISIG                            =#
const VQUIT    = Sys.islinux() ? 1       : 9  #= Quit character ISIG                                 =#
const VSUSP    = Sys.islinux() ? 10      : 10 #= Suspend character ISIG                              =#
const VDSUSP   = Sys.islinux() ? nothing : 11 #= Delayed suspend character ISIG together with IEXTEN =#
const VSTART   = Sys.islinux() ? 8       : 12 #= Start (X-ON) character IXON, IXOFF                  =#
const VSTOP    = Sys.islinux() ? 9       : 13 #= Stop (X-OFF) character IXON, IXOFF                  =#
const VLNEXT   = Sys.islinux() ? 15      : 14 #= Literal-next character IEXTEN                       =#
const VDISCARD = Sys.islinux() ? 13      : 15 #= Discard character  IEXTEN                           =#
const VMIN     = Sys.islinux() ? 6       : 16 #= Minimum number of bytes read at once !ICANON        =#
const VTIME    = Sys.islinux() ? 5       : 17 #= Time-out value (tenths of a second) !ICANON         =#
const VSTATUS  = Sys.islinux() ? nothing : 18 #= Status character ICANON together with IEXTEN        =#
const NCCS     = Sys.islinux() ? 32      : 20

const VSWTC    = Sys.islinux() ? 7 : nothing
#
# Input flags - software input processing
#

const IGNBRK  = 0x00000001                              #= ignore BREAK condition                            =#
const BRKINT  = 0x00000002                              #= map BREAK to SIGINTR                              =#
const IGNPAR  = 0x00000004                              #= ignore (discard) parity errors                    =#
const PARMRK  = 0x00000008                              #= mark parity and framing errors                    =#
const INPCK   = 0x00000010                              #= enable checking of parity errors                  =#
const ISTRIP  = 0x00000020                              #= strip 8th bit off chars                           =#
const INLCR   = 0x00000040                              #= map NL into CR                                    =#
const IGNCR   = 0x00000080                              #= ignore CR                                         =#
const ICRNL   = 0x00000100                              #= map CR to NL (ala CRMOD)                          =#
const IXON    = Sys.islinux() ? 0x00000400 : 0x00000200 #= enable output flow control                        =#
const IXOFF   = Sys.islinux() ? 0x00001000 : 0x00000400 #= enable input flow control                         =#
const IXANY   = 0x00000800                              #= any char will restart after stop                  =#
const IMAXBEL = Sys.islinux() ? nothing    : 0x00002000 #= ring bell on input queue full                     =#
const IUTF8   = Sys.islinux() ? nothing    : 0x00004000 #= (macos) maintain state for UTF-8 VERASE           =#
const IUCLC   = Sys.islinux() ? (1 << 14)  : nothing    #= (glibc) Translate upper case input to lower case. =#

#
# Output flags - software output processing
#

const OPOST  = 0x00000001 #= enable following output processing =#
const ONLCR  = Sys.islinux() ? 0x00000004 : 0x00000002 #= map NL to CR-NL (ala CRMOD)        =#
const OXTABS = 0x00000004 #= expand tabs to spaces              =#
const ONOEOT = 0x00000008 #= discard EOT's (^D) on output)      =#

const OCRNL  = Sys.islinux() ? 0x00000008 : 0x00000010 #= map CR to NL on output        =#
const ONOCR  = Sys.islinux() ? 0x00000010 : 0x00000020 #= no CR output at column 0      =#
const ONLRET = Sys.islinux() ? 0x00000020 : 0x00000040 #= NL performs CR function       =#
const NLDLY  = Sys.islinux() ? 0x00000100 : 0x00000300 #= \n delay                      =#
const TABDLY = Sys.islinux() ? 0x00001800 : 0x00000c04 #= horizontal tab delay          =#
const CRDLY  = Sys.islinux() ? 0x00000600 : 0x00003000 #= \r delay                      =#
const FFDLY  = Sys.islinux() ? 0x00008000 : 0x00004000 #= form feed delay               =#
const BSDLY  = Sys.islinux() ? 0x00002000 : 0x00008000 #= \b delay                      =#
const VTDLY  = Sys.islinux() ? 0x00004000 : 0x00010000 #= vertical tab delay            =#

const NL0   = 0x00000000  #= NL type 0. =#
const NL1   = 0x00000100  #= NL type 1. =#
const NL2   = Sys.islinux() ? nothing : 0x00000200
const NL3   = Sys.islinux() ? nothing : 0x00000300
const TAB0  = 0x00000000  #= TAB delay type 0. =#
const TAB1  = Sys.islinux() ? 0x00000800 : 0x00000400  #= TAB delay type 1. =#
const TAB2  = Sys.islinux() ? 0x00001000 : 0x00000800  #= TAB delay type 2. =#
const TAB3  = Sys.islinux() ? 0x00001800 : 0x00000004  #= Expand tabs to spaces. =#
const CR0   = 0x00000000  #= CR delay type 0. =#
const CR1   = Sys.islinux() ? 0x00000200 : 0x00001000  #= CR delay type 1. =#
const CR2   = Sys.islinux() ? 0x00000400 : 0x00002000  #= CR delay type 2. =#
const CR3   = Sys.islinux() ? 0x00000600 : 0x00003000  #= CR delay type 3. =#
const FF0   = 0x00000000  #= FF delay type 0. =#
const FF1   = Sys.islinux() ? 0x00008000 : 0x00004000  #= FF delay type 1. =#
const BS0   = 0x00000000  #= BS delay type 0. =#
const BS1   = Sys.islinux() ? 0x00002000 : 0x00008000  #= BS delay type 0. =#
const VT0   = 0x00000000  #= VT delay type 0. =#
const VT1   = Sys.islinux() ? 0x00004000 : 0x00010000  #= VT delay type 0. =#

const OLCUC = Sys.islinux() ? (1 << 17) : nothing #= (glibc) Translate lower case output to upper case. =#

const OFILL  = Sys.islinux() ? 0x00000040 : 0x00000080 #= use fill characters for delay =#
const OFDEL  = Sys.islinux() ? nothing : 0x00020000 #= fill is DEL, else NUL         =#

#
# Control flags - hardware control of terminal
#

const CIGNORE    = Sys.islinux() ? nothing    : 0x00000001                #= ignore control flags         =#
const CS5        = 0x00000000                                             #= 5 bits (pseudo)              =#
const CS6        = Sys.islinux() ? 0x00000010 : 0x00000100                #= 6 bits                       =#
const CS7        = Sys.islinux() ? 0x00000020 : 0x00000200                #= 7 bits                       =#
const CS8        = CS6 | CS7                                              #= 8 bits                       =#
const CSIZE      = CS5 | CS6 | CS7 | CS8                                  #= character size mask          =#
const CSTOPB     = Sys.islinux() ? 0x00000040 : 0x00000400                #= send 2 stop bits             =#
const CREAD      = Sys.islinux() ? 0x00000080 : 0x00000800                #= enable receiver              =#
const PARENB     = Sys.islinux() ? 0x00000100 : 0x00001000                #= parity enable                =#
const PARODD     = Sys.islinux() ? 0x00000200 : 0x00002000                #= odd parity, else even        =#
const HUPCL      = Sys.islinux() ? 0x00000400 : 0x00004000                #= hang up on last close        =#
const CLOCAL     = Sys.islinux() ? 0x00000800 : 0x00008000                #= ignore modem status lines    =#
const CCTS_OFLOW = Sys.islinux() ? nothing    : 0x00010000                #= CTS flow control of output   =#
const CRTS_IFLOW = Sys.islinux() ? nothing    : 0x00020000                #= RTS flow control of input    =#
const CDTR_IFLOW = Sys.islinux() ? nothing    : 0x00040000                #= DTR flow control of input    =#
const CDSR_OFLOW = Sys.islinux() ? nothing    : 0x00080000                #= DSR flow control of output   =#
const CCAR_OFLOW = Sys.islinux() ? nothing    : 0x00100000                #= DCD flow control of output   =#
const MDMBUF     = Sys.islinux() ? nothing    : 0x00100000                #= old name for CCAR_OFLOW      =#
const CRTSCTS    = Sys.islinux() ? nothing    : (CCTS_OFLOW | CRTS_IFLOW)

#
# "Local" flags - dumping ground for other state
#
# Warning: some flags in this structure begin with
# the letter "I" and look like they belong in the
# input flag.
#

const ECHOKE     = Sys.islinux() ? nothing    : 0x00000001 #= visual erase for line kill         =#
const ECHOE      = Sys.islinux() ? 0x00000010 : 0x00000002 #= visually erase chars               =#
const ECHOK      = Sys.islinux() ? 0x00000020 : 0x00000004 #= echo NL after line kill            =#
const ECHO       = 0x00000008                              #= enable echoing                     =#
const ECHONL     = Sys.islinux() ? 0x00000040 : 0x00000010 #= echo NL even if ECHO is off        =#
const ECHOPRT    = Sys.islinux() ? nothing    : 0x00000020 #= visual erase mode for hardcopy     =#
const ECHOCTL    = Sys.islinux() ? nothing    : 0x00000040 #= echo control chars as ^(Char)      =#
const ISIG       = Sys.islinux() ? 0x00000001 : 0x00000080 #= enable signals INTR, QUIT, [D]SUSP =#
const ICANON     = Sys.islinux() ? 0x00000002 : 0x00000100 #= canonicalize input lines           =#
const ALTWERASE  = Sys.islinux() ? nothing    : 0x00000200 #= use alternate WERASE algorithm     =#
const IEXTEN     = Sys.islinux() ? 0x00008000 : 0x00000400 #= enable DISCARD and LNEXT           =#
const EXTPROC    = Sys.islinux() ? nothing    : 0x00000800 #= external processing                =#
const TOSTOP     = Sys.islinux() ? 0x00000100 : 0x00400000 #= stop background jobs from output   =#
const FLUSHO     = Sys.islinux() ? nothing    : 0x00800000 #= output being flushed (state)       =#
const NOKERNINFO = Sys.islinux() ? nothing    : 0x02000000 #= no kernel output from VSTATUS      =#
const PENDIN     = Sys.islinux() ? nothing    : 0x20000000 #= XXX retype pending input (state)   =#
const NOFLSH     = Sys.islinux() ? 0x00000080 : 0x80000000 #= don't flush after interrupt        =#

#
# Commands passed to tcsetattr() for setting the termios structure.
#

const TCSANOW   = 0    #= make change immediate         =#
const TCSADRAIN = 1    #= drain output, then change     =#
const TCSAFLUSH = 2    #= drain output, flush input     =#

const TCSASOFT  = Sys.islinux() ? nothing : 0x10 #= flag - don't alter h.w. state =#

#
# Standard speeds
#

const B0       = Sys.islinux() ? 0  : 0
const B50      = Sys.islinux() ? 1  : 50
const B75      = Sys.islinux() ? 2  : 75
const B110     = Sys.islinux() ? 3  : 110
const B134     = Sys.islinux() ? 4  : 134
const B150     = Sys.islinux() ? 5  : 150
const B200     = Sys.islinux() ? 6  : 200
const B300     = Sys.islinux() ? 7  : 300
const B600     = Sys.islinux() ? 8  : 600
const B1200    = Sys.islinux() ? 9  : 1200
const B1800    = Sys.islinux() ? 10 : 1800
const B2400    = Sys.islinux() ? 11 : 2400
const B4800    = Sys.islinux() ? 12 : 4800
const B7200    = Sys.islinux() ? 13 : 7200
const B19200   = Sys.islinux() ? 14 : 19200
const B38400   = Sys.islinux() ? 15 : 38400
const B9600    = 9600
const B14400   = 14400
const B28800   = 28800
const B57600   = 57600
const B76800   = 76800
const B115200  = 115200
const B230400  = 230400
const EXTA     = 19200
const EXTB     = 38400

const B460800  = 460800
const B500000  = 500000
const B576000  = 576000
const B921600  = 921600
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
const TCIFLUSH  = 1 #= Discard data received but not yet read. =#
const TCOFLUSH  = 2 #= Discard data written but not yet sent.  =#
const TCIOFLUSH = 3 #= Discard all pending data.               =#

#
# Values for the ACTION argument to `tcflow'.
#
const TCOOFF    = Sys.islinux() ? 16 : 1 #= Suspend output.                         =#
const TCOON     = Sys.islinux() ? 32 : 2 #= Restart suspended output.               =#
const TCIOFF    = Sys.islinux() ? 4  : 3 #= Send a STOP character.                  =#
const TCION     = Sys.islinux() ? 8  : 4 #= Send a START character.                 =#

mutable struct termios
    c_iflag::tcflag_t           #= input flags   =#
    c_oflag::tcflag_t           #= output flags  =#
    c_cflag::tcflag_t           #= control flags =#
    c_lflag::tcflag_t           #= local flags   =#
    @static if Sys.islinux()
        c_line::cc_t
    end
    c_cc::NTuple{NCCS, UInt8}   #= control chars =#
    c_ispeed::speed_t           #= input speed   =#
    c_ospeed::speed_t           #= output speed  =#
end

function termios()

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
_file_handle(s::Base.LibuvStream) = ccall(:jl_uv_file_handle, Base.OS_HANDLE, (Ptr{Cvoid},), s.handle)

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
    tcsetattr(fd, when, attributes)

Set the tty attributes for file descriptor fd.
The when argument determines when the attributes are changed:

- termios.TCSANOW to change immediately
- termios.TCSADRAIN to change after transmitting all queued output
- termios.TCSAFLUSH to change after transmitting all queued output and discarding all queued input.
"""
function tcsetattr(fd::RawFD, when, term::termios)
    r = ccall(:tcgetattr, Cint, (Cint, Cint, Ptr{Cvoid}), fd, when, Ref(term))
    r == -1 ? throw(TERMIOSError("tcsetattr failed: $(Base.Libc.strerror())")) : nothing
end
tcsetattr(s::Base.LibuvStream, when, term) = tcsetattr(_file_handle(s), when, term)
tcsetattr(f::Int, when, term) = tcsetattr(RawFD(f), when, term)

"""
    tcdrain(fd)

Wait until all output written to file descriptor fd has been transmitted.
"""
function tcdrain(fd::RawFD)
    r = ccall(:tcdrain, Cint, (Cint, ), fd)
    r == -1 ? throw(TERMIOSError("tcdrain failed: $(Base.Libc.strerror())")) : nothing
end
tcdrain(s::Base.LibuvStream) = tcdrain(_file_handle(s))
tcdrain(f::Int) = tcdrain(RawFD(f))

"""
    tcflow(fd, action)

Suspend transmission or reception of data on the object referred to by fd, depending on the value of action:

- termios.TCOOFF to suspend output,
- termios.TCOON to restart output
- termios.TCIOFF to suspend input,
- termios.TCION to restart input.
"""
function tcflow(fd::RawFD, action::Int)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, action)
    r == -1 ? throw(TERMIOSError("tcflow failed: $(Base.Libc.strerror())")) : nothing
end
tcflow(s::Base.LibuvStream, action) = tcflow(_file_handle(s), action)
tcflow(fd::Int, action) = tcflow(RawFD(fd), action)

"""
    tcflush(fd, queue)

Discard data written to the object referred to by fd but not transmitted, or data received but not read, depending on the value of queue_selector:

- termios.TCIFLUSH flushes data received but not read.
- termios.TCOFLUSH flushes data written but not transmitted.
- termios.TCIOFLUSH flushes both data received but not read, and data written but not transmitted.
"""
function tcflush(fd::RawFD, queue::Int)
    r = ccall(:tcflush, Cint, (Cint, Cint), fd, queue)
    r == -1 ? throw(TERMIOSError("tcflush failed: $(Base.Libc.strerror())")) : nothing
end
tcflush(s::Base.LibuvStream, queue) = tcflush(_file_handle(s), queue)
tcflush(fd::Int, queue) = tcflush(RawFD(fd), queue)

"""
    tcsendbreak(s::Base.LibuvStream, duration::Int)

Transmit a continuous stream of zero-valued bits for a specific duration, if the terminal is using asynchronous serial data transmission. If duration is zero, it transmits zero-valued bits for at least 0.25 seconds, and not more that 0.5 seconds. If duration is not zero, it sends zero-valued bits for some implementation-defined length of time.

If the terminal is not using asynchronous serial data transmission, tcsendbreak() returns without taking any action.
"""
function tcsendbreak(fd::RawFD, duration::Int)
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
function cfsetspeed(term::termios, speed::Int)
    r = ccall(:cfsetspeed, Cint, (Ref{termios}, speed_t), Ref(term), speed)
    r == -1 ? throw(TERMIOSError("cfsetspeed failed: $(Base.Libc.strerror())")) : nothing
end

"""
    cfgetispeed(term::termios)::Int

Returns the input baud rate stored in the termios structure.
"""
cfgetispeed(term::termios) = ccall(:cfgetispeed, speed_t, (Ptr{termios}, ), Ref(term))

"""
    cfgetospeed(term::termios)::Int

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
    r == -1 ? throw(TERMIOSError("cfsetispeed failed: $(Base.Libc.strerror())")) : nothing
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
    r == -1 ? throw(TERMIOSError("cfsetospeed failed: $(Base.Libc.strerror())")) : nothing
end

end # module
