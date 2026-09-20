.globl main

.text
main:
    addi x10, x0, 12     
    addi x11, x0, 12    
    jal  x1, sum         

    addi x11, x10, 0     
    li   x10, 1          
    ecall                

    li   x10, 10
    ecall

sum:
    add  x10, x11, x10   
    jalr x0, 0(x1)       