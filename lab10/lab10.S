.section .note.GNU-stack,""
.text

.global dot_double
dot_double:
    xorpd xmm0, xmm0         # Clear the xmm0 register to hold the sum (total)

.loop:
    cmp rdx, 0               # Check if the length is zero
    je .done                 # If zero, exit the loop

    movsd xmm1, QWORD [rdi]  # Load a double from arr1 into xmm1
    mulsd xmm1, QWORD [rsi]  # Multiply the element from arr1 with the corresponding element from arr2
    addsd xmm0, xmm1         # Add the result to the sum in xmm0

    add rdi, 8               # Move to the next element in arr1 (double precision is 8 bytes)
    add rsi, 8               # Move to the next element in arr2
    sub rdx, 1               # Decrement the length counter

    jmp .loop                # Repeat the loop

.done:
    ret                      # Return with the result in xmm0



.global map_poly_double
map_poly_double:
    xor rax, rax              # Clear rax to use as a loop counter

.map_loop:
    cmp rax, rdx              # Check if the loop counter reaches the length
    je .map_done              # If so, exit the loop

    movsd xmm0, QWORD [rdi]   # Load input[i] into xmm0
    mulsd xmm0, xmm0          # Multiply x with x (x^2) -> xmm0 = x^2
    mulsd xmm0, QWORD [xmm3]  # Multiply xmm0 (x^2) with d -> xmm0 = d*x^2

    mulsd xmm1, xmm0          # Multiply xmm1 (b) with xmm0 (d*x^2) -> xmm1 = b*x^2
    addsd xmm1, QWORD [xmm2]  # Add xmm1 (b*x^2) with c -> xmm1 = b*x^2 + c

    mulsd xmm0, xmm1          # Multiply xmm0 (d*x^2) with xmm1 (b*x^2 + c) -> xmm0 = d*x^2 + b*x^4 + c*x^2
    addsd xmm0, QWORD [xmm1]  # Add xmm0 (d*x^2 + b*x^4 + c*x^2) with b*x^2 + c -> xmm0 = a*x^3 + b*x^2 + c*x + d

    movsd QWORD [rsi], xmm0   # Store the result in output[i]

    add rdi, 8                # Move to the next element in the input array (double precision is 8 bytes)
    add rsi, 8                # Move to the next element in the output array
    inc rax                   # Increment the loop counter

    jmp .map_loop             # Repeat the loop

.map_done:
    ret   




.global dot_single
dot_single:
    xorps xmm0, xmm0        # Clear the xmm0 register to hold the sum (total)

.single_loop:
    test rdx, rdx           # Check if the length is zero
    jz .single_done         # If zero, exit the loop

    movss xmm1, DWORD [rdi] # Load a float from arr1 into xmm1
    mulss xmm1, DWORD [rsi] # Multiply the element from arr1 with the corresponding element from arr2
    addss xmm0, xmm1        # Add the result to the sum in xmm0

    add rdi, 4              # Move to the next element in arr1 (single precision is 4 bytes)
    add rsi, 4              # Move to the next element in arr2
    dec rdx                 # Decrement the length counter

    jmp .single_loop        # Repeat the loop

.single_done:
    ret                     # Return with the result in xmm0



.globl map_poly_single

# Inputs:
# rdi: Pointer to the input array (input)
# rsi: Pointer to the output array (output)
# rdx: Length of the arrays (number of elements)
# xmm0, xmm1, xmm2, xmm3: Coefficients a, b, c, d (will be loaded into registers)
map_poly_single:
    xor rax, rax            # Clear rax to use as a loop counter

.poly_loop:
    test rdx, rdx           # Check if the length is zero
    jz .poly_done           # If zero, exit the loop

    movss xmm0, DWORD [rdi] # Load input[i] into xmm0
    mulss xmm0, xmm0        # Multiply x with x (x^2) -> xmm0 = x^2
    mulss xmm0, DWORD [xmm3]# Multiply xmm0 (x^2) with d -> xmm0 = d*x^2

    mulss xmm1, xmm0        # Multiply xmm1 (b) with xmm0 (d*x^2) -> xmm1 = b*x^2
    addss xmm1, DWORD [xmm2]# Add xmm1 (b*x^2) with c -> xmm1 = b*x^2 + c

    mulss xmm0, xmm1        # Multiply xmm0 (d*x^2) with xmm1 (b*x^2 + c) -> xmm0 = d*x^2 + b*x^4 + c*x^2
    addss xmm0, DWORD [xmm1]# Add xmm0 (d*x^2 + b*x^4 + c*x^2) with b*x^2 + c -> xmm0 = a*x^3 + b*x^2 + c*x + d

    movss DWORD [rsi], xmm0 # Store the result in output[i]

    add rdi, 4              # Move to the next element in the input array (single precision is 4 bytes)
    add rsi, 4              # Move to the next element in the output array
    dec rdx                 # Decrement the length counter

    jmp .poly_loop          # Repeat the loop

.poly_done:
    ret                     # Return from the function


