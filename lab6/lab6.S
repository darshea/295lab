//.section .note.GNU-stack,""
.text

.global strlen_mine

strlen_mine:
    movq %rdi, %rax  # Move the string pointer to RAX
    xorq %rcx, %rcx  # Zero out RCX for counting

loop:  # This is a local label for our loop
    cmpb $0, (%rax)  # Compare the byte at the memory location in RAX to zero
    je endf  # If it's zero (end of string), jump to label end
    incq %rax  # Increment RAX to the next byte of the string
    incq %rcx  # Increment RCX (our counter)
    jmp loopb  # Jump back to the start of the loop

end:  # This is our end label
    movq %rcx, %rax  # Move our final count into RAX (the return register)
    ret

