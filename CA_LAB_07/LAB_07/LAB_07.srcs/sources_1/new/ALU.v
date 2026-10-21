`timescale 1ns / 1ps
module top_rf_alu(
    input wire clk,
    input wire btnC,             // Reset button
    input wire [15:0] sw,        // Switches
    output wire [15:0] led,      // LEDs
    output wire [6:0] seg,       // Seven segment display
    output wire [3:0] an         // Seven segment anode
);
    wire rst_db;
    debouncer db_rst (
        .clk(clk),
        .pbin(btnC),
        .pbout(rst_db)
    );
    wire [31:0] sw_readData;
    wire [15:0] sw_led_mirror;
    switches sw_if (
        .clk(clk),
        .rst(rst_db),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b1),       //we always read the switches
        .memAddress(30'b0),
        .sw(sw),
        .readData(sw_readData),
        .leds(sw_led_mirror)
    );

// Switch 0 controls writing to the register file
    wire WriteEnable = sw_readData[0];

    // sw[4:1] (4 bits) selects the second source register rs2 (x0 to x15)
    wire [4:0] rs2 = {1'b0, sw_readData[4:1]};

    // sw[9:5] (5 bits) selects the first source register rs1 (x0 to x31)
    wire [4:0] rs1 = sw_readData[9:5];

    // sw[10] can be left as an extra bit or used for write data
    wire [31:0] WriteData = {31'b0, sw_readData[10]};

    // sw[14:11] (4 bits) selects the ALU operation
    wire [3:0] ALUControl = sw_readData[14:11];

    // Target register rd can match rs2 (or keep as 5'd2)
    wire [4:0] rd = rs2;        //rd=x2
    wire [31:0] ReadData1;      //output 1
    wire [31:0] ReadData2;      //output 2
    wire [31:0] alu_result;
    wire alu_zero;
    //Register File
    RegisterFile rf (
        .clk(clk),
        .rst(rst_db),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    // ALU FILE
    ALU_32bit alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .Result(alu_result),
        .Zero(alu_zero)
    );
    assign led[14:0] = alu_result[14:0];
    assign led[15] = alu_zero;

    leds led_if (
        .clk(clk),
        .rst(rst_db),
        .btns(16'b0),
        .writeData(alu_result),
        .writeEnable(1'b0),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .display_value(alu_result[3:0]),
        .readData(),
        .seg(seg),               // Seven-segment display output
        .an(an)                  // Seven-segment anode control
    );

endmodule