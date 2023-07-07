.section .note.GNU-stack,""
.text

.global hailstone_length
hailstone_length:
    mov $0, %rax          
hailstone_loop_start:
    cmp $1, %rdi          # Compare n with 1
    je hailstone_loop_end # Jump to hailstone_loop_end if n == 1
    
    add $1, %rax          # Increment the length counter
    
    test $1, %rdi         # Perform bitwise AND of n with 1
    jz even               # Jump to hailstone_even if ZF (zero flag) is set (n is even)
    
    imul $3, %rdi         # Multiply n by 3 (n = 3*n + 1 for odd numbers)
    add $1, %rdi          # Increment n by 1
    
    jmp hailstone_loop_start # Jump back to hailstone_loop_start to continue the loop
    
even:
    shr $1, %rdi                # Divide n by 2 (n = n / 2 for even numbers)
    
    jmp hailstone_loop_start    # Jump back to loop_start to continue the loop
    
hailstone_loop_end:
    ret                         # Return from the function



.global hailstone_length_cmov
hailstone_length_cmov:
    mov $0, %rax                  # initialize counter
    mov $0, %r8                     
    mov $0, %r9                     
hailstone_start:
    cmp $1, %rdi                  # compare n with 1
    je hailstone_end         # jump if n == 1

    add $1, %rax                  # increment the length counter

    mov %rdi, %r8                # copy n to rbx
    shr $1, %r8                  # rbx = n / 2

    imul $3, %rdi, %r9           # r9 = 3*n
    add $1, %r9                  # r9 = 3*n + 1

    test $1, %rdi                 # perform bitwise and of n with 1
    cmovne %r9, %r8             # if n is odd move r9 to r8

    mov %r8, %rdi                # move to rdi
    jmp hailstone_start      

hailstone_end:
    ret                           

