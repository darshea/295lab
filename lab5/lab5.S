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

   mov %rdi, %rax       
    imul %rdi, %rax     
    imul %rdi, %rax     # rax = x*x*x

    imul %rsi, %rax     
    mov %rax, %r9       # a*x*x*x = r9

    mov %rdi, %rax      
    imul %rdi, %rax     # rax = x*x
    imul %rdx, %rax     # rax = b*x*x

    add %rax, %r9       # r9 += b*x*x
    imul %rcx, %rdi     # rdi = c*x
    add %rdi, %r9       # r9 += c*x
    add %r8, %r9        # r9 += d

    mov %r9, %rax       
    ret

.global polynomial2

polynomial2:
    
    mov %rdi, %rax      
    imul %rsi, %rax     
    add %rdx, %rax      
    imul %rdi, %rax     # rax = x*(a*x+b)
    add %rcx, %rax      # rax += c
    imul %rdi, %rax     # rax = x*(x*(a*x+b)+c)
    add %r8, %rax       # rax += d

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
    add %rdi, %rax      # rax = rdi * 65537.
    ret