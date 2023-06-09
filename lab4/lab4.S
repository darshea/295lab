.section .text


.global is_prime
is_prime:
    # First, we'll check if n is less than 2.
    # Those cases are not prime, so we return 0.
    movl $2, %ecx       # ECX is our i. We start from 2.
    cmpq %rdi, %rcx     # Compare n (in RDI) with 2.
    jle not_prime       # If n <= 2, it's not a prime.

loop_start:
    movq %rdi, %rax     # RAX is a dividend for IDIVQ.
    xorq %rdx, %rdx     # RDX:RAX should contain the 128-bit dividend before IDIVQ.
    idivq %rcx          # Divide n by i. Quotient in RAX, remainder in RDX.
    test %rdx, %rdx     # If the remainder is 0, n is not prime.
    je not_prime        # Zero flag set means it's not a prime.
    addl $1, %ecx       # Increase i by 1.
    cmpq %rdi, %rcx     # If i < n, continue the loop.
    jl loop_start       # Jump back to the start of the loop.

    # If we've made it here, n is a prime number.
    movl $1, %eax       # Set return value to 1.
    ret

not_prime:
    # n is not a prime number.
    movl $0, %eax       # Set return value to 0.
    ret



.global largest_power_unsigned


.global overflowing_subtract

.global dumb