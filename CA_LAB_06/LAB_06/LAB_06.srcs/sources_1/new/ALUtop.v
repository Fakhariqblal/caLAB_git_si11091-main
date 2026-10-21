`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 08.10.2026 13:36:04
//// Design Name: 
//// Module Name: ALUtop
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: A
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////
module top_alu32bit_fpga (
    input  wire        clk,
    input  wire        btnC,
    input  wire [15:0] sw,
    output wire [15:0] led
);
    wire rst_db;
    debouncer db_rst (
        .clk   (clk),
        .pbin  (btnC),
        .pbout (rst_db)
    );
    wire [31:0] sw_readData;
    wire [15:0] sw_led_mirror;

    switches sw_if (
        .clk         (clk),
        .rst         (rst_db),
        .writeData   (32'b0),
        .writeEnable (1'b0),
        .readEnable  (1'b1),
        .memAddress  (30'b0),
        .sw          (sw),
        .readData    (sw_readData),
        .leds        (sw_led_mirror)
    );
    // Form 4-bit ALUControl: sw[2:0] mapped with MSB = 0
    wire [3:0]  op = {1'b0, sw_readData[2:0]};
    // Procedure Step (e): Fixed 32-bit operands
    wire [31:0] A  = 32'h10101010;
    wire [31:0] B  = 32'h01010101;

    wire [31:0] result;
    wire        zero;
    // ALU instantiation with 4-bit control
    ALU_32bit alu (
        .A          (A),
        .B          (B),
        .ALUControl (op),
        .Result     (result),
        .Zero       (zero)
    );
    // Drive 16 board LEDs
    assign led = result[15:0];
endmodule
