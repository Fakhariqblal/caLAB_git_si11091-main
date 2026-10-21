`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 11:04:22
// Design Name: 
// Module Name: debouncer
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

module debouncer (
    input wire clk,
    input wire pbin,
    output reg pbout
);

    // 16-bit counter creates ~0.65ms debounce window at 100MHz clock
    reg [15:0] counter = 16'd0;
    reg state = 1'b0;

    always @(posedge clk) begin
        if (pbin != state) begin
            counter <= counter + 1'b1;
            if (counter == 16'hFFFF) begin
                state <= pbin;
                counter <= 16'd0;
            end
        end else begin
            counter <= 16'd0;
        end
        pbout <= state;
    end

endmodule
