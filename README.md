# ASCII Bird
An ASCII graphics version of Flappy Bird, for the Dragon 32

## Building it

You need a 6809 cross-assembler. I use http://www.6809.org.uk/asm6809/

Build it with

asm6809 asciibird.s -s asciibird.sym -l  asciibird.ls -o asciibird.bin -D -e 20000

## Running it

You need an emulator, such as Xroar, from http://www.6809.org.uk/xroar/

Which you can then run with:

xroar -rompath $ROMPATH asciibird.bin

Note: You will need to acquire a suitable Dragon 32 ROM file, and place it in the directory given by $ROMPATH

## Technical background

Here are some useful resources to help code in 6809 on the Dragon

* http://www.6809.org.uk/dragon/6809e.txt
* http://dragon32.info/info/memmap.txt
* http://dragon32.info/info/romref.html
* http://atjs.mbnet.fi/mc6809/Information/6809.htm
