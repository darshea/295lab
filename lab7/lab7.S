.section .note.GNU-stack,""

.section .data
.align 8
seed:
    .quad 0


.section .text
.global randint
randint:
    # Load seed into rax
    movabs seed, %rax
    mov (%rax), %rax

    # Multiply seed by 6364136223846793005 and store in rax
    movabs $6364136223846793005, %r8
    imul %r8, %rax

    # Add 1442695040888963407 to rax
    movabs $1442695040888963407, %r9
    add %r9, %rax

    # Store result back into seed
    mov %rax, seed(%rip)

    # Return value in rax
    ret


.global fill_array
fill_array:
    # Arguments:
    # rdi = array pointer
    # rsi = number of elements

    # Initialize loop counter
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
    # Arguments:
    # rdi = array 1 pointer
    # rsi = array 2 pointer
    # rdx = number of elements

    # Initialize the result to 0
    mov $0, %rax

    # Initialize loop counter
    mov %rdx, %rcx

    .Dotloop:
        # Load elements from both arrays
        mov (%rdi), %r8
        mov (%rsi), %r9

        # Multiply elements
        imul %r9, %r8

        # Accumulate product to the result
        add %r8, %rax

        # Advance the array pointers
        add $8, %rdi
        add $8, %rsi

        # Decrement the counter
        dec %rcx

        # Check if the counter is zero, if not, loop again
        jnz .Dotloop

    ret


.global dot_pairs
dot_pairs:
    # Arguments:
    # rdi = array pointer
    # rsi = number of elements

    # Initialize the result to 0
    mov $0, %rax

    # Initialize loop counter
    mov %rsi, %rcx

    .Ldot_pairs_loop:
        # Load elements from the pair struct
        mov 0(%rdi), %r8  # a
        mov 8(%rdi), %r9  # b

        # Multiply elements
        imul %r9, %r8

        # Accumulate product to the result
        add %r8, %rax

        # Advance the array pointer
        add $16, %rdi  # Move to next struct in the array

        # Decrement the counter
        dec %rcx

        # Check if the counter is zero, if not, loop again
        jnz .Ldot_pairs_loop

    ret