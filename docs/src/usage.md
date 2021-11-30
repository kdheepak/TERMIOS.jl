# Usage

### Example

```julia
using TERMIOS
const T = TERMIOS
options = T.termios()
T.tcgetattr(stdin, options)
  # Disable ctrl-c, disable CR translation, disable stripping 8th bit (unicode), disable parity
options.c_iflag &= ~(T.BRKINT | T.ICRNL | T.INPCK | T.ISTRIP | T.IXON)
# Disable output processing
options.c_oflag &= ~(T.OPOST)
# Disable parity
options.c_cflag &= ~(T.CSIZE | T.PARENB)
# Set character size to 8 bits (unicode)
options.c_cflag |= (T.CS8)
  # Disable echo, disable canonical mode (line mode), disable input processing, disable signals
options.c_lflag &= ~(T.ECHO | T.ICANON | T.IEXTEN | T.ISIG)
options.c_cc[T.VMIN] = 0
options.c_cc[T.VTIME] = 1
T.tcsetattr(stdin, T.TCSANOW, options)
```

### API

```@autodocs
Modules = [TERMIOS]
```
