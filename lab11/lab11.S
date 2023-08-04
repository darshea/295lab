.section .note.GNU-stack,""
.text

.globl dot_double
dot_double:
    xorpd %xmm0, %xmm0

.loop:
    cmpq $0, %rdx
    je .done

    movsd (%rdi), %xmm1
    mulsd (%rsi), %xmm1
    addsd %xmm1, %xmm0

    addq $8, %rdi
    addq $8, %rsi
    subq $1, %rdx

    jmp .loop

.done:
    ret


.globl map_poly_double
map_poly_double:
    xor %rax, %rax

.map_loop:
    cmp %rdx, %rax
    je .map_done

    movsd (%rdi), %xmm0  
    movaps %xmm0, %xmm4  

    mulsd %xmm0, %xmm0   
    mulsd %xmm0, %xmm5   

    movsd %xmm0, %xmm6   
    mulsd %xmm3, %xmm6   

    movsd %xmm0, %xmm5   
    mulsd %xmm2, %xmm5   

    mulsd %xmm1, %xmm4   

    addsd %xmm6, %xmm5
    addsd %xmm5, %xmm4
    addsd %xmm4, %xmm0
    addsd %xmm7, %xmm0

    movsd %xmm0, (%rsi)

    addq $8, %rdi
    addq $8, %rsi
    incq %rax

    jmp .map_loop

.map_done:
    ret



.globl dot_single
dot_single:
    xorps %xmm0, %xmm0

.single_loop:
    test %rdx, %rdx
    jz .single_done

    movss (%rdi), %xmm1
    mulss (%rsi), %xmm1
    addss %xmm1, %xmm0

    addq $4, %rdi
    addq $4, %rsi
    decq %rdx

    jmp .single_loop

.single_done:
    ret


.globl map_poly_single
map_poly_single:
    xor %rax, %rax

.map_loop_single:
    cmp %rdx, %rax
    je .map_done_single

    movss (%rdi), %xmm0  
    movaps %xmm0, %xmm4  

    mulss %xmm0, %xmm0   
    mulss %xmm0, %xmm5   

    movss %xmm0, %xmm6   
    mulss %xmm3, %xmm6   

    movss %xmm0, %xmm5   
    mulss %xmm2, %xmm5   

    mulss %xmm1, %xmm4   

    addss %xmm6, %xmm5
    addss %xmm5, %xmm4
    addss %xmm4, %xmm0
    addss %xmm7, %xmm0

    movss %xmm0, (%rsi)

    addq $4, %rdi
    addq $4, %rsi
    incq %rax

    jmp .map_loop_single

.map_done_single:
    ret


#Copy done




# dot_double_vec: Calculate dot product of two double arrays using SIMD instructions
.global dot_double_vec
dot_double_vec:
    vxorpd %ymm0, %ymm0, %ymm0  # Zero out ymm0 to store the sum

.ddv_loop:
    cmpq $0, %rdx
    je .ddv_done

    vmovupd (%rdi), %ymm1
    vmovupd (%rsi), %ymm2

    vmulpd %ymm1, %ymm2, %ymm1  # Multiply elements
    vaddpd %ymm1, %ymm0, %ymm0  # Add to the total sum

    addq $32, %rdi
    addq $32, %rsi
    subq $4, %rdx  # We process 4 doubles at a time

    jmp .ddv_loop

.ddv_done:
    vhaddpd %ymm0, %ymm0, %ymm0  # Pairwise add to get final sum
    vextractf128 $1, %ymm0, %xmm1  # Extract upper 128 bits
    vaddpd %xmm1, %xmm0, %xmm0  # Add upper and lower sums
    ret


.global dot_single_vec
dot_single_vec:
    vxorps %ymm0, %ymm0, %ymm0  # Zero out ymm0 to store the sum

.dsv_loop:
    cmpq $0, %rdx
    je .dsv_done

    vmovups (%rdi), %ymm1
    vmovups (%rsi), %ymm2

    vmulps %ymm1, %ymm2, %ymm1  # Multiply elements
    vaddps %ymm1, %ymm0, %ymm0  # Add to the total sum

    addq $32, %rdi
    addq $32, %rsi
    subq $8, %rdx  # We process 8 floats at a time

    jmp .dsv_loop

.dsv_done:
    vhaddps %ymm0, %ymm0, %ymm0 # Horizontal add to accumulate the 8 values into the lower half
    vhaddps %ymm0, %ymm0, %ymm0 # Repeat to have the final sum in the first position
    vextractf128 $1, %ymm0, %xmm1 # Extract the high 128 bits
    vaddps %xmm1, %xmm0, %xmm0 # Add the high 128 bits to the low 128 bits
    ret


# map_poly_double_vec: Evaluate a polynomial with double coefficients for a double array using SIMD instructions
.global map_poly_double_vec
map_poly_double_vec:
    movq %rdx, %rax            # Copy length to a general-purpose register for loop counter

    vbroadcastsd %xmm0, %ymm7  # Load a and broadcast to all YMM elements
    vbroadcastsd %xmm1, %ymm8  # Load b and broadcast to all YMM elements
    vbroadcastsd %xmm2, %ymm9  # Load c and broadcast to all YMM elements
    vbroadcastsd %xmm3, %ymm10 # Load d and broadcast to all YMM elements

.mp_loop:
    cmpq $0, %rax
    je .mp_done

    vmovupd (%rdi), %ymm0     # Load 4 double-precision values from input (a vector)
    vmulpd %ymm0, %ymm0, %ymm1 # Compute x^2
    vmulpd %ymm0, %ymm1, %ymm2 # Compute x^3
    vmulpd %ymm7, %ymm2, %ymm3 # Compute a*x^3

    vmulpd %ymm8, %ymm1, %ymm4 # Compute b*x^2
    vmulpd %ymm9, %ymm0, %ymm5 # Compute c*x

    vaddpd %ymm4, %ymm5, %ymm4 # Compute b*x^2 + c*x
    vaddpd %ymm4, %ymm10, %ymm4 # Compute b*x^2 + c*x + d

    vaddpd %ymm3, %ymm4, %ymm4 # Compute a*x^3 + b*x^2 + c*x + d

    vmovupd %ymm4, (%rsi)      # Store the result to the output (a vector)

    addq $32, %rdi
    addq $32, %rsi
    subq $4, %rax  # Decrement the loop counter by 4 (as we process 4 doubles at a time)

    jmp .mp_loop

.mp_done:
    ret


# map_poly_single_vec: Evaluate a polynomial with single coefficients for a single array using SIMD instructions
.global map_poly_single_vec
map_poly_single_vec:
    movq %rdx, %rax             # Copy length to a general-purpose register for loop counter

    vbroadcastss %xmm0, %ymm7  # Load a and broadcast to all YMM elements
    vbroadcastss %xmm1, %ymm8  # Load b and broadcast to all YMM elements
    vbroadcastss %xmm2, %ymm9  # Load c and broadcast to all YMM elements
    vbroadcastss %xmm3, %ymm10 # Load d and broadcast to all YMM elements

.mp_loop_single:
    cmpq $0, %rax
    je .mp_done_single

    vmovups (%rdi), %ymm0      # Load 8 single-precision values from input (a vector)
    vmulps %ymm0, %ymm0, %ymm1 # Compute x^2
    vmulps %ymm0, %ymm1, %ymm2 # Compute x^3
    vmulps %ymm7, %ymm2, %ymm3 # Compute a*x^3

    vmulps %ymm8, %ymm1, %ymm4 # Compute b*x^2
    vmulps %ymm9, %ymm0, %ymm5 # Compute c*x

    vaddps %ymm4, %ymm5, %ymm4 # Compute b*x^2 + c*x
    vaddps %ymm4, %ymm10, %ymm4 # Compute b*x^2 + c*x + d

    vaddps %ymm3, %ymm4, %ymm4 # Compute a*x^3 + b*x^2 + c*x + d

    vmovups %ymm4, (%rsi)       # Store the result to the output (a vector)

    addq $32, %rdi
    addq $32, %rsi
    subq $8, %rax   # Decrement the loop counter by 8 (as we process 8 floats at a time)

    jmp .mp_loop_single

.mp_done_single:
    ret