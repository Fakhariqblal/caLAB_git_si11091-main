`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 02:55:05
// Design Name: 
// Module Name: ALU_tb
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
module top_alu32bit_fpga(
    input  wire        clk,
    input  wire        btnC,
    input  wire [15:0]   sw,
    output wire [15:0] led
);



    wire rst_db;
    debouncer db_rst (
        .clk(clk),
        .pbin(btnC),
        .pbout(rst_db)
    );

    // Switch interface
    wire [31:0] sw_readData;
    wire [15:0] sw_led_mirror;

    switches sw_if (
        .clk(clk),
        .rst(rst_db),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'b0),
        .sw(sw),
        .readData(sw_readData),
        .leds(sw_led_mirror)
    );

    // Switch mapping (from sw_readData)
    wire [3:0]  op  = sw_readData[3:0];
    wire [5:0]  A6  = sw_readData[9:4];
    wire [5:0]  B6  = sw_readData[15:10];

    wire [31:0] A32 = {26'b0, A6};
    wire [31:0] B32 = {26'b0, B6};

    wire [31:0] result;
    wire        zero;

    ALU_32bit alu (
        .A(A32),
        .B(B32),
        .ALUControl(op),
        .Result(result),
        .Zero(zero)
    );

    // Board LEDs: lower 15 bits + zero flag on LED0
    assign led[15:1] = result[14:0];
    assign led[0]    = zero;

    // Seven-seg shows lower nibble of result
    wire [3:0] display_value = result[3:0];

    leds led_if (
        .clk(clk),
        .rst(rst_db),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .display_value(display_value),
        .readData()
    );

endmodule
