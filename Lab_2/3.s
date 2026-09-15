main:
li x22, 10
li x23, 3      
li x20, 3         

switch:
    li x5, 1
    beq x20, x5, case1
    li x5, 2
    beq x20, x5, case2
    li x5, 3
    beq x20, x5, case3
    li x5, 4
    beq x20, x5, case4
    beq x0, x0, default

case1:
    add x21, x22, x23       
    beq x0, x0, end_switch

case2:
    sub x21, x22, x23       
    beq x0, x0, end_switch

case3:
    slli x21, x22, 1          
    beq x0, x0, end_switch

case4:
    srai x21, x22, 1          
    beq x0, x0, end_switch

default:
    li x21, 0                 

end_switch:
end: 
j end