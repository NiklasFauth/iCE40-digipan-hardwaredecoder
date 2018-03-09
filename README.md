# iCE40 DigiPan hardware decoder

This is some verilog and python code to capture xray images from digipan sensors in real-time.

## Prerequisites

- [Yosys][1]
- [arachne-pnr][2]
- [IceStorm][3]

Python:

- PIL
- numpy
- pygame

## Building

    git clone https://github.com/cyrozap/iCEstick-UART-Demo.git
    cd iCEstick-UART-Demo
    git submodule update --init
    make

## Flashing

Plug in your iCEstick, then run `make flash`. Depending on your permissions, you
may need to run it with `sudo`.


[1]: http://www.clifford.at/yosys/
[2]: https://github.com/cseed/arachne-pnr
[3]: http://www.clifford.at/icestorm/

## Usage

- python setbaudrate.py /dev/ttyUSB0 8000000
- python image_rt.py /dev/ttyUSB0

## Other boards
Only tested on the HX8 eval board. Should work on the iCEstick as well, just change the constrain file in the Makefile.
