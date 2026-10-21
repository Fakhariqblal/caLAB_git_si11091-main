`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 11:04:59
// Design Name: 
// Module Name: switches
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

module switches(
    input wire clk,
    input wire rst,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    input wire [29:0] memAddress,
    input wire [15:0] sw,
    output reg [31:0] readData,
    output wire [15:0] leds
);

    // Mirror the switch states directly to the LEDs output bus
    assign leds = sw;

    // Read the 16 board switches into the lower 16 bits of readData when readEnable is asserted
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            readData <= 32'b0;
        end else if (readEnable) begin
            readData <= {16'b0, sw};
        end else begin
            readData <= 32'b0;
        end
    end

endmodule