# listing 4
main:
li x22, 0
li x24, 2
li x25, 0x100

li x9, 2
sw x9, 0(x25)
sw x9, 4(x25)
li x9, 2
sw x9, 12(x25)

loop:
    slli x10, x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    bne x9, x24, Exit
    addi x22, x22, 1
    beq x0, x0, loop

Exit:
end:
j end