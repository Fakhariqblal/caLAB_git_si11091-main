.globl main

.text
main:
    addi sp, sp, -20       
    addi x5, x0, 1
    sw   x5, 0(sp)         
    addi x5, x0, 2
    sw   x5, 4(sp)          
    addi x5, x0, 3
    sw   x5, 8(sp)          
    addi x5, x0, 4
    sw   x5, 12(sp)         
    addi x5, x0, 5
    sw   x5, 16(sp)         

    addi x10, sp, 0        
    addi x11, x0, 1         
    jal  x1, swap

    lw   x11, 4(sp)         
    li   x10, 1             
    ecall

    li   x11, 32            
    li   x10, 11            
    ecall

    lw   x11, 8(sp)         
    li   x10, 1
    ecall                   

    addi sp, sp, 20         
    li   x10, 10            
    ecall

swap:
    slli x6, x11, 2         
    add  x6, x10, x6        
    lw   x5, 0(x6)          
    lw   x7, 4(x6)          
    sw   x7, 0(x6)          
    sw   x5, 4(x6)          
    jalr x0, 0(x1)         