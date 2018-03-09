#!/usr/bin/python
# set nonstandard baudrate. http://unix.stackexchange.com/a/327366/119298
import sys,array,fcntl

# from /usr/lib/python2.7/site-packages/serial/serialposix.py
# /usr/include/asm-generic/termbits.h for struct termios2
#  [2]c_cflag [9]c_ispeed [10]c_ospeed
def set_special_baudrate(fd, baudrate):
    TCGETS2 = 0x802C542A
    TCSETS2 = 0x402C542B
    BOTHER = 0o010000
    CBAUD = 0o010017
    buf = array.array('i', [0] * 64) # is 44 really
    fcntl.ioctl(fd, TCGETS2, buf)
    buf[2] &= ~CBAUD
    buf[2] |= BOTHER
    buf[9] = buf[10] = baudrate
    assert(fcntl.ioctl(fd, TCSETS2, buf)==0)
    fcntl.ioctl(fd, TCGETS2, buf)
    if buf[9]!=baudrate or buf[10]!=baudrate:
        print("failed. speed is %d %d" % (buf[9],buf[10]))
        sys.exit(1)

set_special_baudrate(0, int(sys.argv[1]))
