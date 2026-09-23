.text
.globl main

main:
    addi x10, x0, 4      # num = 5
    jal x1, func       # callling fucniton func taking argument number
    addi x11, x10, 0     # result is in x10
    addi x10, x0, 1      # exit
    ecall
    end: 
    j end

func:
    addi sp, sp, -16
    sw x1, 12(sp)        # save return address
    sw x10, 8(sp)        #saving sapce in stack

    li x12, 1
    ble x10, x12, base   # if (num <= 1)

    addi x10, x10, -1    # num = num - 1
    jal x1, func         # calling func(n-1) recursively.

    lw x5, 8(sp)         
    add x10, x10, x5     # returning the sum
    lw x1, 12(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)

base:
    addi x10, x0, 1      # return 1 ( obviously )
    lw x1, 12(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)