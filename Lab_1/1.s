    .text 
    .globl main 

    main:



        li x22 , 5
        li x23 , 0
        li x01 , 5

        addi x22 , x23 ,32
        add, x24 , x22 , x23 
        sub , x25, x24 , x01
        sub , x26 , x22 ,x25
        sub , x27, x23 , x22
        add , x20 , x27 , x26
        add, x19 , x20 , x25
        add x18 , x22 , x23
        add x17 , x25 , x19 
        add x19 , x18 , x17  
        

    end: 
        j end 