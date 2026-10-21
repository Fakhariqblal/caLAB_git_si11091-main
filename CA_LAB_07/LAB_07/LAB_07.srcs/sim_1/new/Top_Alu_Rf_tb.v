`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 11:13:37
// Design Name: 
// Module Name: Top_Alu_Rf_tb
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


`timescale 1ns/1ps

module tb_top_rf_alu;
    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    RegisterFile rf (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ALU_32bit alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );

    // Clock generator: 100MHz (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    localparam IDLE            = 3'd0;
    localparam WRITE_REGS      = 3'd1;
    localparam READ_REGISTERS  = 3'd2;
    localparam ALU_OPERATION   = 3'd3;
    localparam WRITE_REGISTERS = 3'd4;

    reg [2:0] state;
    reg [1:0] init_idx;
    reg [3:0] op;
    reg [4:0] dest;

    initial begin
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;
        repeat (120) @(posedge clk);
        $finish;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            WriteEnable <= 0;
            rs1 <= 0; rs2 <= 0; rd <= 0;
            WriteData <= 0;
            ALUControl <= 4'b0010;
            init_idx <= 0;
            op <= 0;
            dest <= 0;
        end else begin
            case (state)
                IDLE: begin
                    WriteEnable <= 0;
                    init_idx <= 0;
                    op <= 0;
                    state <= WRITE_REGS;
                end

                WRITE_REGS: begin
                    WriteEnable <= 1;
                    case (init_idx)
                        2'd0: begin
                            rd <= 5'd1;
                            WriteData <= 32'h1010_1010;
                            init_idx <= 1;
                        end
                        2'd1: begin
                            rd <= 5'd2;
                            WriteData <= 32'h0101_0101;
                            init_idx <= 2;
                        end
                        2'd2: begin
                            rd <= 5'd3;
                            WriteData <= 32'h0000_0005;
                            init_idx <= 0;
                            WriteEnable <= 0;
                            state <= READ_REGISTERS;
                        end
                    endcase
                end

                READ_REGISTERS: begin
                    WriteEnable <= 0;
                    rs1 <= 5'd1;
                    rs2 <= 5'd2;
                    case (op)
                        4'd0: begin ALUControl <= 4'b0010; dest <= 5'd4;  end // ADD
                        4'd1: begin ALUControl <= 4'b0110; dest <= 5'd5;  end // SUB
                        4'd2: begin ALUControl <= 4'b0000; dest <= 5'd6;  end // AND
                        4'd3: begin ALUControl <= 4'b0001; dest <= 5'd7;  end // OR
                        4'd4: begin ALUControl <= 4'b1100; dest <= 5'd8;  end // XOR
                        4'd5: begin ALUControl <= 4'b0100; dest <= 5'd9;  end // SLL
                        4'd6: begin ALUControl <= 4'b0101; dest <= 5'd10; end // SRL
                        4'd7: begin
                            rs1 <= 5'd1;
                            rs2 <= 5'd1;
                            ALUControl <= 4'b0110; // x1 - x1 => 0
                            dest <= 5'd11;
                        end
                        4'd8: begin
                            ALUControl <= 4'b0010;
                            dest <= 5'd12;
                        end
                        4'd9: begin
                            rs1 <= 5'd12;
                            rs2 <= 5'd0;
                            ALUControl <= 4'b0010;
                            dest <= 5'd0;          // Test write to x0 (should be discarded)
                        end
                    endcase
                    state <= ALU_OPERATION;
                end

                ALU_OPERATION: begin
                    state <= WRITE_REGISTERS;
                end

                WRITE_REGISTERS: begin
                    case (op)
                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6: begin
                            rd <= dest;
                            WriteData <= ALUResult;
                            WriteEnable <= 1;
                            op <= op + 1;
                            state <= READ_REGISTERS;
                        end
                        4'd7: begin
                            rd <= dest; // x11
                            WriteData <= (Zero ? 32'd1 : 32'd0);
                            WriteEnable <= 1;
                            op <= 8;
                            state <= READ_REGISTERS;
                        end
                        4'd8: begin
                            rd <= 5'd12;
                            WriteData <= 32'hAAAA_5555;
                            WriteEnable <= 1;
                            op <= 9;
                            state <= READ_REGISTERS;
                        end
                        4'd9: begin
                            WriteEnable <= 0;
                            rs1 <= 5'd4; // read x4 at the end
                            rs2 <= 5'd5; // read x5 at the end
                            state <= IDLE;
                        end
                    endcase
                end
            endcase
        end
    end

endmodule