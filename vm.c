#include <stdio.h>
#include <stdint.h>
#include "hexdump.c"

#define SIZE 1<<16
#define LIMIT -1

int status(uint16_t pc, int16_t a, int16_t b, int16_t c, int16_t ma, int16_t mb) {
	printf("%04X: %04X %04X %04X | %04X %04X\n",
		pc, (uint16_t) a, (uint16_t) b, (uint16_t) c,
		(uint16_t) ma, (uint16_t) mb);
}

int16_t memory[SIZE];

int main() {
	FILE* fptr = fopen("out.bin", "r");
	if (fptr == NULL) return 1;

	uint16_t i = 0;
	while (fread(&memory[i], sizeof(int16_t), 1, fptr)) {
		// convert from big-endian to little-endian
		memory[i] = (memory[i] >> 8) | (memory[i] << 8);
		i++;
	}

	fclose(fptr);

	uint16_t pc = 0;

	int count = 0;

	while (count++ < 1000) {
		int16_t a = memory[pc];
		int16_t b = memory[pc + 1];
		int16_t c = memory[pc + 2];

		if (c == LIMIT) {
			break;
		}

		if (a == LIMIT) {
			memory[b] = getchar();
			pc += 3;
			continue;
		}

		if (b == LIMIT) {
			putchar(memory[a]);
			pc += 3;
			continue;
		}

		memory[b] -= memory[a];
		if (memory[b] <= 0) {
			pc = (uint16_t) c;
			continue;
		}

		pc += 3;
	}

	printf("CPU halted\n");

	return 0;
}
