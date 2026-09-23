.data
arr:
    .word 1,2,3

.text
.globl main
.globl bubble
.globl bubblesort

main:
    la x10, arr
    li x11, 3
    jal x1, bubble

    li x10, 10
    ecall
    j end

bubble:
bubblesort:
    beq x10, x0, done       # if a == NULL, return
    beq x11, x0, done       # if len == 0, return

    addi x5, x0, 0          
o_loop:
    bge x5, x11, done        # for i < len

    slli x6, x5, 2           # i * 4
    add x6, x10, x6          # x6 = &a[i]
    addi x7, x5, 1          

i_loop:
    bge x7, x11, end  # for j < len

    slli x28, x7, 2          # j * 4
    add x29, x10, x28         # x29 = &a[j]

    lw x30, 0(x6)            # a[i]
    lw x31, 0(x29)           

    blt x30, x31, swap       # if a[i] < a[j]
    j j

swap:
    sw x31, 0(x6)            # a[i] = a[j]
    sw x30, 0(x29)           

j:
    addi x7, x7, 1           
    j i_loop

end:
    addi x5, x5, 1           # i++
    j o_loop

done:
    ret