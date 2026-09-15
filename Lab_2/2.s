# listing 3
main:
li x20, 5        # g
li x21, 3         # h
li x22, 4         # i
li x23, 4         # j

bne x22, x23, Else
add x19, x20, x21
beq x0, x0, Exit    
Else: sub x19, x20, x21

Exit:
end:
j end