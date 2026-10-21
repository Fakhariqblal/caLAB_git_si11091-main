`timescale 1ns / 1ps
module RegisterFile(
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);
    reg [31:0] regs [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = i;
        end
    end
    always @(*) begin
        ReadData1 = regs[rs1];
        ReadData2 = regs[rs2];
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= i;
            end
        end else if (WriteEnable && (rd != 5'b00000)) begin
            regs[rd] <= WriteData;
        end
    end

endmodule