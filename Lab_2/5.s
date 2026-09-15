# listing 6
main:
li x25, 0x400
li x24, 8

li x22, 0
L1:
bge x22, x24, L1e
slli x10, x22, 2
add x10, x10, x25
sw x22, 0(x10)
addi x22, x22, 1
beq x0, x0, L1
L1e:

li x23, 0
li x22, 0
L2:
bge x22, x24, L2e
slli x10, x22, 2
add x10, x10, x25
lw x9, 0(x10)
add x23, x23, x9
addi x22, x22, 1
beq x0, x0, L2
L2e:

end: j end