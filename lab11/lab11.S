section .text
global dot_double_vec
global dot_single_vec
global map_poly_double_vec
global map_poly_single_vec

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

    movsd %xmm5, %xmm6   
    mulsd %xmm3, %xmm6   

    movsd %xmm0, %xmm5   
    mulsd %xmm2, %xmm5   

    mulsd %xmm1, %xmm4   

    addsd %xmm6, %xmm0
    addsd %xmm5, %xmm0
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

.poly_loop:
    cmpq %rax, %rdx
    je .poly_done

    movss (%rdi, %rax, 4), %xmm4  
    movaps %xmm4, %xmm5            

    mulss %xmm5, %xmm5             
    mulss %xmm5, %xmm6             

    movss %xmm6, %xmm7             
    mulss %xmm3, %xmm7             

    movss %xmm5, %xmm6            
    mulss %xmm2, %xmm6            

    mulss %xmm1, %xmm4           

    addss %xmm7, %xmm0
    addss %xmm6, %xmm0
    addss %xmm4, %xmm0
    addss %xmm7, %xmm0

    movss %xmm0, (%rsi, %rax, 4)

    incq %rax

    jmp .poly_loop

.poly_done:
    ret

.global sin_x87
sin_x87:
    mov $0, %rcx
s87_loop:
    cmp %rdx, %rcx
    jae s87_ret
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp s87_loop
s87_ret:
    ret


#Copy done




# dot_double_vec: Calculate dot product of two double arrays using SIMD instructions
dot_double_vec:
    vxorpd %ymm0, %ymm0, %ymm0  # Zero out ymm0 to store the sum

.loop:
    cmpq $0, %rdx
    je .done

    vmovupd (%rdi), %ymm1
    vmovupd (%rsi), %ymm2

    vmulpd %ymm1, %ymm2, %ymm1  # Multiply elements
    vaddpd %ymm1, %ymm0, %ymm0  # Add to the total sum

    addq $32, %rdi
    addq $32, %rsi
    subq $4, %rdx  # We process 4 doubles at a time

    jmp .loop

.done:
    vhaddpd %ymm0, %ymm0, %ymm0  # Pairwise add to get final sum
    vextractf128 $1, %ymm0, %xmm1  # Extract upper 128 bits
    vaddpd %xmm1, %xmm0, %xmm0  # Add upper and lower sums
    ret


# dot_single_vec: Calculate dot product of two single arrays using SIMD instructions
dot_single_vec:
    vxorps %ymm0, %ymm0, %ymm0  # Zero out ymm0 to store the sum

.single_loop:
    test %rdx, %rdx
    jz .single_done

    vmovups (%rdi), %ymm1
    vmovups (%rsi), %ymm2

    vmulps %ymm1, %ymm2, %ymm1  # Multiply elements
    vaddps %ymm1, %ymm0, %ymm0  # Add to the total sum

    addq $32, %rdi
    addq $32, %rsi
    subq $8, %rdx  # We process 8 singles at a time

    jmp .single_loop

.single_done:
    vhaddps %ymm0, %ymm0, %ymm0  # Pairwise add to get final sum
    vextractf128 $1, %ymm0, %xmm1  # Extract upper 128 bits
    vaddps %xmm1, %xmm0, %xmm0  # Add upper and lower sums
    ret


# map_poly_double_vec: Evaluate a polynomial with double coefficients for a double array using SIMD instructions
map_poly_double_vec:
    vmovupd (%rdi), %ymm0     # Load the polynomial coefficients
    vbroadcastsd 0(%rdi), %ymm1
    vbroadcastsd 8(%rdi), %ymm2
    vbroadcastsd 16(%rdi), %ymm3
    vbroadcastsd 24(%rdi), %ymm4

.mp_loop:
    cmpq $0, %rdx
    je .mp_done

    vmovupd (%rsi), %ymm5   # Load the x values
    vmovapd %ymm5, %ymm6
    vmovapd %ymm5, %ymm7

    vmulpd %ymm5, %ymm5, %ymm5   # Compute x^2
    vmulpd %ymm5, %ymm6, %ymm6   # Compute x^3

    # Compute ax^3
    vmulpd %ymm1, %ymm6, %ymm6

    # Compute bx^2
    vmulpd %ymm2, %ymm5, %ymm5

    # Compute cx
    vmulpd %ymm3, %ymm7, %ymm7

    # Compute ax^3 + bx^2 + cx + d
    vaddpd %ymm6, %ymm5, %ymm5
    vaddpd %ymm7, %ymm5, %ymm5
    vaddpd %ymm4, %ymm5, %ymm5

    vmovupd %ymm5, (%rsi)

    addq $32, %rsi
    subq $4, %rdx  # We process 4 doubles at a time

    jmp .mp_loop

.mp_done:
    ret

# map_poly_single_vec: Evaluate a polynomial with single coefficients for a single array using SIMD instructions
map_poly_single_vec:
    vmovups (%rdi), %ymm0     # Load the polynomial coefficients
    vbroadcastss 0(%rdi), %ymm1
    vbroadcastss 4(%rdi), %ymm2
    vbroadcastss 8(%rdi), %ymm3
    vbroadcastss 12(%rdi), %ymm4

.mpoly_loop:
    cmpq $0, %rdx
    je .mpoly_done

    vmovups (%rsi), %ymm5   # Load the x values
    vmovaps %ymm5, %ymm6
    vmovaps %ymm5, %ymm7

    vmulps %ymm5, %ymm5, %ymm5   # Compute x^2
    vmulps %ymm5, %ymm6, %ymm6   # Compute x^3

    # Compute ax^3
    vmulps %ymm1, %ymm6, %ymm6

    # Compute bx^2
    vmulps %ymm2, %ymm5, %ymm5

    # Compute cx
    vmulps %ymm3, %ymm7, %ymm7

    # Compute ax^3 + bx^2 + cx + d
    vaddps %ymm6, %ymm5, %ymm5
    vaddps %ymm7, %ymm5, %ymm5
    vaddps %ymm4, %ymm5, %ymm5

    vmovups %ymm5, (%rsi)

    addq $32, %rsi
    subq $8, %rdx  # We process 8 singles at a time

    jmp .mpoly_loop

.mpoly_done:
    ret

