# Laser 128 ROM dumper

This dumps the ROM from a Laser 128 while the system is live. Useful if you don't have an EEPROM programmer/reader of your own.

This utility will work on both "old" and "new" model Laser 128s, but the ROM map is quite different, so you must tell the tool which model you have.

On the "old" models, you will need to manually toggle between Parallel and Serial to get both versions of the slot 1 ROM. You will be prompted to do this.

On the "new" models, you should leave the switch in the Parallel position the whole time, otherwise you will get two copies of the serial option ROM and zero copies of the parallel option ROM. You must also ensure that slot 5 and 7 are set to Internal, or you will be dumping the ROMs from your attached cards (or random electrical noise).

## Accuracy / known issues

Output is correct for ROM version 2.9 (on an old model) and ROM version 6.0 (on a new model).

The only part of this I don't quite understand is that 16 bytes from slot 1 don't end up matching the original ROM. They should be all $FF, but there is an odd pattern there instead. The tool manually rewrites it. I suspect it is either (a) some convoluted logic with the Parallel/Serial switch or (b) something to do with the port configuration you can set by holding "P" while powering up the machine.

## ROM layout

### "Old" Laser 128

```
0000 - 00FF = empty (reserved for soft switches)
0100 - 07FF = C100-C7FF (INTCXROMON)
0800 - 0FFF = C800-CFFF slot 1 option ROM (INTCXROMON)
1000 - 1FFF = D000-DFFF ROM
2000 - 2FFF = E000-EFFF ROM
3000 - 3FFF = F000-FFFF ROM
4000 - 40FF = empty (reserved for soft switches)
4100 - 42FF = C100-C2FF (INTCXROMOFF, Parallel mode)
4300 - 43FF = empty (no ROM for slot 3)
4400 - 44FF = C400-C4FF (INTCXROMOFF)
4500 - 45FF = empty (slot 5 is always external)
4600 - 46FF = C600-C6FF (INTCXROMOFF)
4700 - 47FF = empty (slot 7 is always external)
4800 - 4FFF = C800-CFFF Slot 1 option ROM (INTCXROMOFF)
5000 - 50FF = empty (reserved for soft switches)
5100 - 51FF = C100-C2FF (INTCXROMOFF, Serial mode)
5200 - 57FF = empty (no alternate slot 2-7)
5800 - 5FFF = C800-CFFF Slot 2 option ROM
6000 - 67FF = empty (inaccessible?)
6800 - 6FFF = CC00-CFFF Slot 6 option ROM bank 1
7000 - 77FF = empty (inaccessible?)
7800 - 7FFF = C800-CFFF Slot 6 option ROM bank 2
```

Slot 6 option ROM bank 2 is empty in ROM 2.9, but it might be populated on other models. I've confirmed that it's accessible.

### "New" Laser 128 (also EX and EX/2)

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
6000 - 63FF = CC00-CFFF Slot 7 option ROM bank 1
6400 - 67FF = CC00-CFFF Slot 7 option ROM bank 2
6800 - 6BFF = CC00-CFFF Slot 7 option ROM bank 3
6C00 - 6FFF = CC00-CFFF Slot 7 option ROM bank 4
7000 - 73FF = CC00-CFFF Slot 7 option ROM bank 5
7400 - 77FF = CC00-CFFF Slot 7 option ROM bank 6
7800 - 7FFF = C800-CFFF Slot 6 option ROM / CC00-CFFF Slot 7 option ROM bank 7+8
```

There's an overlap because the slot 7 banking register uses 3 bits, which gives you 8 banks, but they only use 6. The other two really belong to the slot 6 option ROM. C800-CBFF for slot 7 is actually RAM dedicated to the disk controller.

## License

Copyright 2021 Renee Harke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
