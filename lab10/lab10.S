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