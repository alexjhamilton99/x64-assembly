icalc: icalc.o
	gcc -o icalc icalc.o -no-pie
icalc.o: icalc.asm
	nasm -f elf64 -g -F dwarf -l icalc.lst icalc.asm
