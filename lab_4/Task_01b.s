.text
.globl main

main:
    addi x10, x0, 7        
    jal  x1, fact         

    # x10 = 5040
    addi x11, x10, 0       

    # print integer
    addi x10, x11, 0
    addi x17, x0, 1
    ecall

    # exit
    addi x17, x0, 10
    ecall

fact:
    addi x5, x0, 1        

loop:
    ble  x10, x0, done    
    mul  x5, x5, x10      
    addi x10, x10, -1      # n = n - 1
    j    loop

done:
    add  x10, x5, x0       # return acc
    jalr x0, 0(x1)