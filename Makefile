myos.bin: boot.o kernel.o linker.ld
	i686-pc-linux-gnu-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

boot.o: boot.s
	i686-pc-linux-gnu-as boot.s -o boot.o

kernel.o: kernel.c
	i686-pc-linux-gnu-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

build: myos.bin
	@if grub-file --is-x86-multiboot myos.bin ;\
	then \
		echo multiboot confirmed ;\
		mkdir -p isodir/boot/grub ;\
		cp myos.bin isodir/boot/myos.bin ;\
		cp grub.cfg isodir/boot/grub/grub.cfg ;\
		grub-mkrescue -o myos.iso isodir ;\
	else \
		echo the file is not multiboot ;\
	fi

clean:
	rm *.o *.bin

clean-all:
	rm -r *.o *.bin *.iso isodir

qemu:
	qemu-system-x86_64 -cdrom myos.iso
