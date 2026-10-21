

`timescale 1ns / 1ps

module ALU_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALUControl;
    wire [31:0] Result;
    wire        Zero;

    ALU_32bit uut (
        .A          (A),
        .B          (B),
        .ALUControl (ALUControl),
        .Result     (Result),
        .Zero       (Zero)
    );

    initial begin
        // Fixed operands per step (e)
        A = 32'h10101010;
        B = 32'h01010101;
        ALUControl = 4'b0000;
        #50;

        // 1. AND (0000) -> 0x00000000
        ALUControl = 4'b0000;
        #50;

        // 2. OR (0001)  -> 0x11111111
        ALUControl = 4'b0001;
        #50;

        // 3. ADD (0010) -> 0x11111111
        ALUControl = 4'b0010;
        #50;

        // 4. XOR (0011) -> 0x11111111
        ALUControl = 4'b0011;
        #50;

        // 5. SLL (0100) -> 0x20202020
        ALUControl = 4'b0100;
        #50;

        // 6. SRL (0101) -> 0x08080808
        ALUControl = 4'b0101;
        #50;

        // 7. SUB (0110) -> 0x0F0F0F0F
        ALUControl = 4'b0110;
        #50;

        // 8. BEQ (0111) -> 0x0F0F0F0F
        ALUControl = 4'b0111;
        #50;

        // 9. Zero Flag Check (Equal inputs)
        A = 32'hA5A5A5A5;
        B = 32'hA5A5A5A5;
        ALUControl = 4'b0110; // SUB -> Result = 0, Zero = 1
        #50;

        $finish;
    end

endmodule