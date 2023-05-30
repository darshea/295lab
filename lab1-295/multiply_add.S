    .section .note.GNU-stack, ""
    .global multiply_add
    .text

# return a + b * c;
# Argument 1 in %rdi.
# Argument 2 in %rsi.
# Argument 3 in %rdx.
# Return value in %rax.

multiply_add:
    mov %rsi, %rax
    imul %rdx, %rax
    add %rdi, %rax
    ret
