`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 11:06:24
// Design Name: 
// Module Name: Led
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

module leds(
    input wire clk,
    input wire rst,
    input wire [15:0] btns,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    input wire [29:0] memAddress,
    input wire [3:0] display_value,
    output wire [31:0] readData,
    output reg [6:0] seg,
    output reg [3:0] an
);

    // Unused readData bus tied off safely
    assign readData = 32'b0;

    // Clock divider to generate ~1 kHz refresh rate for 7-segment display
    // 100 MHz / 2^18 ? 381 Hz overall (refreshing each digit ~95 Hz)
    reg [17:0] refresh_counter = 0;
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 18'd0;
        else
            refresh_counter <= refresh_counter + 1'b1;
    end

    // Use top 2 bits of the counter to cycle through anodes
    wire [1:0] active_digit = refresh_counter[17:16];

    // Determine 4-bit nibble to display
    // Digit 0 (rightmost) displays display_value (alu_result[3:0]), others display 0
    reg [3:0] hex_digit;
    always @(*) begin
        case (active_digit)
            2'b00: begin
                an = 4'b1110;          // Turn on rightmost digit (Active LOW)
                hex_digit = display_value;
            end
            2'b01: begin
                an = 4'b1101;          // Turn on digit 1
                hex_digit = 4'h0;
            end
            2'b10: begin
                an = 4'b1011;          // Turn on digit 2
                hex_digit = 4'h0;
            end
            2'b11: begin
                an = 4'b0111;          // Turn on leftmost digit
                hex_digit = 4'h0;
            end
            default: begin
                an = 4'b1111;
                hex_digit = 4'h0;
            end
        endcase
    end

    // 7-Segment Decoder (Cathodes are Active LOW on Basys 3: seg = {g, f, e, d, c, b, a})
    always @(*) begin
        case (hex_digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111; // Off
        endcase
    end

endmodule
