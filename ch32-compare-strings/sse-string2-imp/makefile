sse_string2_imp: sse_string2_imp.o
	gcc -o sse_string2_imp sse_string2_imp.o -no-pie
sse_string2_imp.o: sse_string2_imp.asm
	nasm -f elf64 -g -F dwarf sse_string2_imp.asm -l sse_string2_imp.lst
