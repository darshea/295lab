    .section .note.GNU-stack,""
    .text



.global abs_value
abs_value:
    mov %rdi, %rax  # Move the value in rdi to rax
    sar $63 , %rdi  # Arithmetic shift right by 63 positions (copies the sign bit to all bits)
    
    xor %rdi, %rax  # XOR the value in rdi with rax (flips the sign if negative)
    sub %rdi, %rax  # Subtract the sign bit back

    ret



.global power2
power2:

    mov %rdi, %r8             # Move the input argument n to r8
    add $1, %r8
    mov $1, %rax              # Initialize rax with the starting value 1

power2_loop_start:
    cmp $0, %r8               # Compare n with 0
    jle power2_loop_end       # Jump to loop_end if n <= 0

    mov %rax, %rdi            # Move current value to rdi for print
    push %rax                 # Push the value of rax onto the stack (argument for print_uint64)
    call print_uint64         # Call the print_uint64 function to print the value
    pop %rax

    sal $1, %rax              # Double the value in rax
    dec %r8                   # Decrement n by 1

    jmp power2_loop_start     # Jump back to loop_start to continue the loop

power2_loop_end:
    ret                       # Return from the function




.global hailstone_length
hailstone_length:
    mov $0, %rax          # setting rax to 0
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





