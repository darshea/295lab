#include <math.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

#define ARRAY_SIZE 10000000

extern void sin_x87(double* input, double* output, uint64_t length);

void sin_stdlib(double* input, double* output, uint64_t length) {
    for (uint64_t i = 0; i < length; ++i) {
        output[i] = sin(input[i]);
    }
}

int main() {
    double *input = malloc(ARRAY_SIZE * sizeof(double));
    double *output_x87 = malloc(ARRAY_SIZE * sizeof(double));
    double *output_stdlib = malloc(ARRAY_SIZE * sizeof(double));

    // Populate the input array with some values
    for (uint64_t i = 0; i < ARRAY_SIZE; ++i) {
        input[i] = i / 100.0;
    }

    // Time sin_x87
    clock_t start_x87 = clock();
    sin_x87(input, output_x87, ARRAY_SIZE);
    clock_t end_x87 = clock();
    double time_x87 = ((double) (end_x87 - start_x87)) / CLOCKS_PER_SEC;
    printf("Time for sin_x87: %f seconds\n", time_x87);

    // Time sin_stdlib
    clock_t start_stdlib = clock();
    sin_stdlib(input, output_stdlib, ARRAY_SIZE);
    clock_t end_stdlib = clock();
    double time_stdlib = ((double) (end_stdlib - start_stdlib)) / CLOCKS_PER_SEC;
    printf("Time for sin_stdlib: %f seconds\n", time_stdlib);

    // Check correctness
    for (uint64_t i = 0; i < ARRAY_SIZE; ++i) {
        if (abs(output_x87[i] - output_stdlib[i]) > 1e-6) {
            printf("Mismatch at position %" PRIu64 "\n", i);
            break;
        }
    }

    free(input);
    free(output_x87);
    free(output_stdlib);

    return 0;
}
