#Task 4
.text
.globl main

main:
    li   x10, 0x100         
    li   x11, 0x200         

    li   x5, 'h'           
    sb   x5, 0(x11)
    li   x5, 'i'
    sb   x5, 1(x11)
    sb   x0, 2(x11)         

    jal  x1, strcpy

    j    exit

strcpy:
    addi sp, sp, -4         
    sw   x19, 0(sp)        

    li   x19, 0           

Loop:
    add  x5, x19, x11      
    lbu  x6, 0(x5)          
    add  x7, x19, x10       
    sb   x6, 0(x7)         
    beq  x6, x0, Done       
    addi x19, x19, 1        
    j    Loop

Done:
    lw   x19, 0(sp)         
    addi sp, sp, 4          
    jalr x0, 0(x1)          

exit:
end:
    j    end