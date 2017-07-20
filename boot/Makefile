

CFLAGS=-Wall -m32 -ffreestanding -nostdlib -nostdinc -I ./include
.PHONY: all


all:
	nasm -f bin stage1/stage1.asm -o stage1.bin
	nasm -f elf stage2/start.asm -o start.o
	nasm -f elf stage2/system.asm -o system.o

	gcc ${CFLAGS} -c stage2/*.c


	ld -T stage2/boot.ld start.o system.o main.o boot.o io.o -o stage2.bin


	cat stage1.bin stage2.bin > BOOTLOADER.SYS

	rm *.o

	qemu-system-i386 -hda BOOTLOADER.SYS
