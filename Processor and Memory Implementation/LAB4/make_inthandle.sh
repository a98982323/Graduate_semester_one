sde-as inthandle.s -g -o inthandle.o
sde-ld inthandle.o -Ttext 0x00001000 -o inthandle.image
sde-conv inthandle.image -o inthandle.conv
sde-objdump inthandle.image -D > inthandle.txt
rm *.o
rm *.image
