all:
	ca65 --cpu 65c02 -t none src/main.s -l src/main.lst
	ld65 -t none src/main.o -o rom.bin -m rom.map

disasm:
	da65 -S 0xC000 --cpu 65c02 rom.bin --verbose

clean:
	find . -name "*.o" -o -name "*.lst" -o -name "*.bin" -o -name "*.map" | xargs rm -f

program: all
	minipro -p W27C512@DIP28 -w rom.bin -S
