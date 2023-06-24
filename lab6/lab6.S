.section .note.GNU-stack,""
.text

.global strlen_mine

strlen_mine:
    movq %rdi, %rax  
    xorq %rcx, %rcx  # initializing rcx = 0 for counter

1:  
    cmpb $0, (%rax)  # compare the byte to 0
    je 2f  # if 0 -> jump 2
    incq %rax  # increment by 64bits
    incq %rcx  # increment counter
    jmp 1b  

2:  
    movq %rcx, %rax  
    ret



.global strlen_utf8


strlen_utf8:
    movq %rdi, %rax  
    xorq %rcx, %rcx 

1:  
    movzbl (%rax), %edx  # current byte -> edx, zero extend to 64bit
    testb $0x80, %dl  #MSB
    jz inc_count  # If not set -> 1B

    testb $0x40, %dl  #Second MSB
    jz next_byte  # If not set -> continuation 

inc_count: 
    incq %rcx  # increment rcx for counting char

next_byte:  
    incq %rax  # next byte
    cmpb $0, (%rax)  # Compare with 0
    jne 1b  # if not zero -> jump back loop

    movq %rcx, %rax  
    ret