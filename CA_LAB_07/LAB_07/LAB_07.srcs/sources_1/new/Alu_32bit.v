`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 11:05:30
// Design Name: 
// Module Name: Alu_32bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module ALU_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire Zero
);

    always @(*) begin
        case (ALUControl)
            4'b0010: Result = A + B;             // ADD 2 + 5 = 7
            4'b0110: Result = A - B;             // SUB 2-5= 3 (unsigned)
            4'b0000: Result = A & B;             // AND 00101  & 0010 = 0
            4'b0001: Result = A | B;             // OR  (1)
            4'b1100: Result = A ^ B;             // XOR (12)
            4'b0100: Result = A << B[4:0];       // SLL (4)
            4'b0101: Result = A >> B[4:0];       // SRL (5)
            default: Result = 32'd0;
        endcase
    end

    // Zero flag is high when Result is exactly 0
    assign Zero = (Result == 32'd0);

endmodule
