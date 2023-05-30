    .section .note.GNU-stack,""
    .global calculate
    .text

calculate:
    
    mov %r15, %r11      # using one of the call-preserved (%r15) register for x. Also %r10 and %r9 will be used for non-preserved registers.
    push %r11
    mov %rdi, %r15      # moving argument into a preserved register. %r15 = x 

    mov %r15, %r10      # copy x value into a %r10 = a
    add $3, %r10        # a = x + 3, a = %r10

    mov %r15, %rdi      # x -> first argument
    mov %r10, %rsi      # a -> second argument
    push %r10
    call f              # b = f(x, a)
    pop %r10
    mov %rax, %r9       # temp = r9, b = r9
    add %r9, %r10       # switch %r10 from a to a+b   a+b = %r10

    mov %r9, %rdi       # b -> first argument
    mov %r15, %rsi      # x -> second argument
    push %r10
    call f              # c = f(b, x)
    pop %r10
    mov %rax, %r9       # switch r9 from b to c, %r9 = c
    add %r9, %r10       # update result (r10) to a+b+c 

    mov %r15, %rdi      # x -> first argument
    mov %r9, %rsi       # c -> second argument
    push %r10
    call f              # d = f(x, c)
    pop %r10
    mov %rax, %r9       # switch r9 from c to d, %r9 = d
    add %r9, %r10       # update result (r10) to a+b+c+d

    pop %r11
    mov %r11, %r15      # returning the call-preserved register value before returning the function call
    mov %r10, %rax

    ret                 # return a + b + c + d
