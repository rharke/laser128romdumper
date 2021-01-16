# Laser 128 ROM dumper

This dumps the ROM from a Laser 128 while the system is live. Useful if you don't have an EEPROM programmer/reader of your own.

I've only tested this on "new style" Laser 128s, with the red badge on the case. The old black and silver badged models might have a different ROM layout, I'm not sure. It wouldn't surprise me, they're radically different pieces of hardware.

You need to have the Parallel/Serial switch set to Parallel to run. The reason is that the serial firmware for slot 1 is really just a copy of slot 2, so if you have the switch set to Serial, then you get two copies of the serial option ROM and zero copies of the parallel option ROM.

The only part of this I don't quite understand is that 16 bytes from slot 1 don't end up matching the original ROM. They should be all $FF, but there is an odd pattern there instead. I suspect it is either (a) some convoluted logic with the Parallel/Serial switch or (b) something to do with the port configuration you can set by holding "P" while powering up the machine.

## ROM layout

```
0000 - 00FF = empty (reserved for soft switches)
0100 - 07FF = C100-C7FF (INTCXROMON)
0800 - 0FFF = C800-CFFF slot 1 option ROM (INTCXROMON)
1000 - 1FFF = D000-DFFF ROM
2000 - 2FFF = E000-EFFF ROM
3000 - 3FFF = F000-FFFF ROM
4000 - 40FF = empty (reserved for soft switches)
4100 - 47FF = C100-C7FF (INTCXROMOFF, SLOTC3ROMON)
4800 - 4FFF = C800-CFFF Slot 1 option ROM (INTCXROMOFF)
5000 - 57FF = C800-CFFF Slot 5 option ROM
5800 - 5FFF = C800-CFFF Slot 2 option ROM
6000 - 63FF = CB00-CFFF Slot 7 option ROM bank 1
6400 - 67FF = CB00-CFFF Slot 7 option ROM bank 2
6800 - 6BFF = CB00-CFFF Slot 7 option ROM bank 3
6C00 - 6FFF = CB00-CFFF Slot 7 option ROM bank 4
7000 - 73FF = CB00-CFFF Slot 7 option ROM bank 5
7400 - 77FF = CB00-CFFF Slot 7 option ROM bank 6
7800 - 7FFF = C800-CFFF Slot 6 option ROM / CB00-CFFF Slot 7 option ROM bank 7+8
```

There's an overlap because the slot 7 banking register uses 3 bits, which gives you 8 banks, but they only use 6. The other two really belong to the slot 6 option ROM. C800-C3FF for slot 7 is actually RAM dedicated to the disk controller.

## License

Copyright 2021 Renee Harke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
