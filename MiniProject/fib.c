#include <stdint.h>
#include <stdio.h>
#include "fib.h"

uint64_t recursive_fib(uint64_t n) {
    if (n <= 1)
        return n;
    else
        return recursive_fib(n-1) + recursive_fib(n-2);
}


uint64_t dynamic_fib(uint64_t n) {
    uint64_t f[n+2];  // 1 extra to handle case n = 0
    uint64_t i;
   
    // base case
    f[0] = 0;
    f[1] = 1;
   
    for (i = 2; i <= n; i++) {
        // adding the two preceding numbers in the series
        f[i] = f[i-1] + f[i-2];
    }
   
    return f[n];
}

uint64_t matrix_fib(uint64_t n) {
    uint64_t F[2][2] = {{1,1},{1,0}};
    if (n == 0)
        return 0;
    power(F, n - 1);
    return F[0][0];
}

void multiply(uint64_t F[2][2], uint64_t M[2][2]) {
    uint64_t x =  F[0][0]*M[0][0] + F[0][1]*M[1][0];
    uint64_t y =  F[0][0]*M[0][1] + F[0][1]*M[1][1];
    uint64_t z =  F[1][0]*M[0][0] + F[1][1]*M[1][0];
    uint64_t w =  F[1][0]*M[0][1] + F[1][1]*M[1][1];
  
    F[0][0] = x;
    F[0][1] = y;
    F[1][0] = z;
    F[1][1] = w;
}

void power(uint64_t F[2][2], uint64_t n) {
    if( n == 0 || n == 1)
        return;
    uint64_t M[2][2] = {{1,1},{1,0}};
  
    power(F, n/2);
    multiply(F, F);
  
    if (n % 2 != 0)
        multiply(F, M);
}

void fastdoubling_fib(uint64_t n, uint64_t* a, uint64_t* b) {
    if (n == 0) {
        *a = 0;
        *b = 1;
        return;
    }
    
    uint64_t d, e;
    fastdoubling_fib(n >> 1, &d, &e);
    
    uint64_t c = d * ((e << 1) - d);
    uint64_t f = d * d + e * e;
    
    if (n & 1) {
        *a = f;
        *b = c + f;
    } else {
        *a = c;
        *b = f;
    }
}

uint64_t fibonacci_fast_doubling(uint64_t n) {
    uint64_t a, b;
    fastdoubling_fib(n, &a, &b);
    return a;
}

/*
int main() {
    uint64_t n = 30;
    
    printf("Recursive Fibonacci of %lu is: %lu\n", n, recursive_fib(n));
    printf("Dynamic Fibonacci of %lu is: %lu\n", n, dynamic_fib(n));
    printf("Matrix Fibonacci of %lu is: %lu\n", n, matrix_fib(n));
    printf("Fast Doubling Fibonacci of %lu is: %lu\n", n, fibonacci_fast_doubling(n));
    
    return 0;
}
*/