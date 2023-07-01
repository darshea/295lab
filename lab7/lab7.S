.section .note.GNU-stack,""

.section .data
.align 8
seed:
    .quad 0


.section .text
.global randint
randint:

    mov seed(%rip), %rax

    movabs $6364136223846793005, %r8
    imul %r8, %rax

    # Add 1442695040888963407 to rax
    movabs $1442695040888963407, %r9
    add %r9, %rax

    # Store result back into seed
    mov %rax, seed(%rip)

    # Return value in rax
    ret


.section .text
.global fill_array
fill_array:
    mov %rsi, %rcx

.Lloop:
     # Call randint to get a random value in rax
    call randint

    # Limit value to the range -128 to 127
    and $0xff, %rax
    sub $128, %rax

    # Store the value in the array
    mov %rax, (%rdi)

    # Advance the array pointer
    add $8, %rdi

    # Decrement the counter
    dec %rcx

    # Check if the counter is zero, if not, loop again
    jnz .Lloop

ret


.global dot
dot:

    mov $0, %rax
    mov %rdx, %rcx #initialize counter

.Dotloop:
   
   # Load elements from both arrays
    mov (%rdi), %r8
    add $8, %rdi
    mov (%rsi), %r9
    imul %r9, %r8
    add $8, %rsi
    add %r8, %rax

    dec %rcx # Decrement counter
    jnz .Dotloop # if not zero - loop

    ret


.section .text
.global dot_struct
dot_struct:
   
    mov $0, %rax
    mov %rsi, %rcx

    .Ldot_pairs_loop:

        mov 0(%rdi), %r8  # a
        mov 8(%rdi), %r9  # b

        imul %r9, %r8

        add %r8, %rax

        add $16, %rdi  

        dec %rcx

        jnz .Ldot_pairs_loop

    ret
