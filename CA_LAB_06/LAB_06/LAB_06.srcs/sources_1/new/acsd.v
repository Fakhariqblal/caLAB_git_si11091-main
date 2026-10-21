`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 02:54:14
// Design Name: 
// Module Name: acsd
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

module ALU_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,  // 4-bit ALU control
    output reg  [31:0] Result,
    output wire        Zero
);

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;        // AND (Switches: None) -> 0x0000
            4'b0001: Result = A | B;        // OR  (Switches: 0)    -> 0x1111
            4'b0010: Result = A + B;        // ADD (Switches: 1)    -> 0x1111
            4'b0011: Result = A ^ B;        // XOR (Switches: 0, 1) -> 0x1111
            4'b0100: Result = A << B[4:0];  // SLL (Switches: 2)    -> 0x2020
            4'b0101: Result = A >> B[4:0];  // SRL (Switches: 0, 2) -> 0x0808
            4'b0110: Result = A - B;        // SUB (Switches: 1, 2) -> 0x0F0F
            4'b0111: Result = A - B;        // BEQ (Switches: 0, 1, 2) -> 0x0F0F
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule