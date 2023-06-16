    .section .note.GNU-stack,""
    .text


.global fibonacci

fibonacci:
    cmp $1, %rdi
    jle base_case       # send to Base_case when small or equal to 1

    push %rbp           # saving stack base pointer
    push %rbx           # save used registers

    dec %rdi
    mov %rdi, %rbx 
    call fibonacci
    mov %rax, %rbp      # save the result of F(n-1)
    
    dec %rbx  
    mov %rbx, %rdi
    call fibonacci
    add %rbp, %rax      # add F(n-1) + F(n-2)
   
    pop %rbx            # restore used registers
    pop %rbp

    ret

base_case:

    mov %rdi, %rax
    ret



.global polynomial1

polynomial1: 

    push %rsi           # a
    push %rdx           # b 

                        # r8  == already d. 
    
    mov %rcx, %r12      # c to r12
    mov %rdi, %rax      # moving x to rax
    mul %r12

    mov %rax, %r12      # r12 = c*x
    add %r12, %r8       # adding c*x + d = r12
    mov %rdi, %rax      # reset rax to x
    
    pop %r8             # pop the b value to r8
    mul %rdi            # x*x
    mul %r8             # b*x*x
    add %r12, %rax      # adding b*x*x + c*x + d = r12

    pop %r8             # pop the a value to r8
    mov %rdi, %rax      # reset rax to x
    mul %rdi
    mul %rdi            # x*x*x
    mul %r8             # a*x*x*x
    add %r12, %rax      # adding a*x*x*x + b*x*x + c*x + d = r12

    mov %r12, %rax      # move final result to rax

    ret 
    

.global polynomial2

polynomial2:
    
    mov %rdi, %rax      # moving x to rax
    mul %rsi            # a*x = rax
    add %rdx, %rax      # a*x + b = rdx
    mov %rdi, %rax      # moving x to rax
    mul %rdx
    add %rcx, %rax      # x*(a*x + b) + c = rcx
    mov %rdi, %rax      # moving x to rax
    mul %rcx        
    add %r8, %rax       # x*(x*(a*x + b) + c) + d

    mov %r8, %rax       

    ret



.global is_odd1

is_odd1: 
    mov %rdi, %rax       # rdi to rax
    xor %rdx, %rdx       # clearing rdx 
    mov $2, %rcx         # rcx = 2
    idiv %rcx            # rax = rdi / 2, rdx = rdi % 2.
    mov %rdx, %rax       # Move the remainder to rax, because rax is used for the return value.
    ret

    
.global is_odd2

is_odd2:
    mov %rdi, %rax       
    and $1, %rax         # leaving only the LSB
    ret


.global mul1

mul1:
    mov %rdi, %rax      
    mov $65537, %rcx   
    mul %rcx            # rax = rdi * 65537.
    ret


.global mul2

mul2:
    mov %rdi, %rax      
    shl $16, %rax        
    add %rax, %rdi      # rax = rdi * 65537.
    ret