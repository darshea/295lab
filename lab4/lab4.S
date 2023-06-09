    .section .note.GNU-stack,""
    .text


.global is_prime

is_prime:
    cmpq $2, %rdi       # If n = 2
    je is_special_prime # Directly jump to ret

    movl $2, %ecx       # ECX = i

loop_start:
    movq %rdi, %rax     # RAX is a dividend for DIV.
    xorq %rdx, %rdx     # clearing %rdx to 0 for calculation
    divq %rcx           # Divide n by i. 
    test %rdx, %rdx     # If remainder = 0 => not prime. ZF 
    je not_prime        # ZF set = not a prime.
    addl $1, %ecx       # Increase i by 1
    cmpq %rdi, %rcx     # If i < n -> cont.
    jb loop_start       

    movl $1, %eax       # return val = 1
    ret

is_special_prime:
    movl $1, %eax       # return val = 1
    ret

not_prime:
    # n is not a prime number.
    movl $0, %eax       # return val = 0.
    ret



.global largest_power_unsigned

largest_power_unsigned:
    mov $1, %rax           # Start with 1 
    mov %rdi, %rbx         # Store n in rbx

multiply:
    mov %rax, %r8          # Store current power in %r8 
    mul %rbx              
    jc done                
    jmp multiply          

done:
    mov %r8, %rax          
    ret                    



.global overflowing_subtract

# take two signed integer arguments. It should usually return a-b, unless that calculation is a signed overflow then it should return zero.
#     rdi, rsi

overflowing_subtract:
    mov %rdi, %rax           # a -> %rax
    sub %rsi, %rax           # b-a
    jo overflow_occurred     # if OF -> jump
    ret                      # (already saved in rax)

overflow_occurred:
    mov $0, %rax          
    ret                      # Return 0


.global dumb

dumb:
    # if a == 0 return b
    cmp $0, %rdi
    je return_b

    # if b == 0 return a
    cmp $0, %rsi
    je return_a

    # Prep stack
    sub $32, %rsp

    # Save a, b
    mov %rdi, (%rsp)       #a
    mov %rsi, 8(%rsp)      #b

    dec %rdi                
    dec %rsi
    mov %rdi, 16(%rsp)     #a - 1
    mov %rsi, 24(%rsp)     #b - 1

 
    call dumb

    mov (%rsp), %rdi       #restore a
    mov 8(%rsp), %rsi      #restore b

    # clean up
    add $32, %rsp

    # add to return val
    add %rdi, %rax
    add %rsi, %rax
    add %rsi, %rax
    ret

return_b:
    mov %rsi, %rax
    ret

return_a:
    mov %rdi, %rax
    ret