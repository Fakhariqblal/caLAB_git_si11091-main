.data
numbers:
    .word 1, 2, 3, 4, 5

.text
.globl main

main:
    la x10, numbers       # x10 = address of first element
    addi x11, x0, 5       # x11 = number of elements
    jal x1, array_subtract # call array_subtract(numbers, 5)

    addi x14, x10, 0      # keep result in x12 
    addi x10, x0, 10      # exit program
    ecall

array_subtract:
    addi sp, sp, -8       # reserve space for ra and x8
    sw x1, 4(sp)          # save return address
    sw x8, 0(sp)          # save preserved register x8

    lw x8, 0(x10)         # result = first element
    addi x10, x10, 4      # move to second element
    addi x11, x11, -1     # remaining elements = 4

subtract_loop:
    beq x11, x0, subtract_done # if count == 0, finish
    lw x5, 0(x10)         # load current array element
    sub x8, x8, x5        # result -= current element
    addi x10, x10, 4      # move to next element
    addi x11, x11, -1     # count--
    jal x0, subtract_loop  # repeat loop

subtract_done:
    add x10, x8, x0       # return result in x10
    lw x8, 0(sp)          # restore preserved register x8
    lw x1, 4(sp)          # restore return address
    addi sp, sp, 8        # release stack space
    jalr x0, 0(x1)        # return to main