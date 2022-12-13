sde-as intprocess.s -g -o intprocess.o
sde-ld intprocess.o -Ttext 0x00001400 -o intprocess.image
sde-conv intprocess.image -o intprocess.conv
sde-objdump intprocess.image -D > intprocess.txt
rm *.o
rm *.image
