.globl main

.text
main:
    addi x10, x0, 13     
    addi x11, x0, 8     
    addi x12, x0, 3      
    addi x13, x0, 1     
    jal  x1, leaf_example

    addi x11, x10, 0     
    li   x10, 1          
    ecall                

    li   x10, 10         
    ecall

leaf_example:
    addi sp, sp, -12     
    sw   x18, 8(sp)      
    sw   x19, 4(sp)     
    sw   x20, 0(sp)      

    add  x18, x10, x11   
    add  x19, x12, x13   
    sub  x20, x18, x19   
    addi x10, x20, 0     

    lw   x20, 0(sp)      
    lw   x19, 4(sp)      
    lw   x18, 8(sp)      
    addi sp, sp, 12      

    jalr x0, 0(x1)       