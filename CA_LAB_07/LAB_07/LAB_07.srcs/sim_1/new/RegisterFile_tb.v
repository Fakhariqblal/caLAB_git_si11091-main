`timescale 1ns / 1ps

module tb_RegisterFile;

    // DUT Inputs
    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    // DUT Outputs
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Error counter
    integer errors = 0;

    // Instantiate the Device Under Test (DUT)
    RegisterFile dut (
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

    // 100 MHz Clock Generation (10ns period)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Verification Task
    task check_outputs(
        input [4:0] r1_addr, input [31:0] exp1,
        input [4:0] r2_addr, input [31:0] exp2,
        input [8*30:1] test_name
    );
        begin
            rs1 = r1_addr;
            rs2 = r2_addr;
            #1; // allow combinational read paths to settle
            if (ReadData1 !== exp1) begin
                $display("[FAIL] %0s | ReadData1 (reg %0d) = 0x%08h, Expected = 0x%08h", test_name, r1_addr, ReadData1, exp1);
                errors = errors + 1;
            end else if (ReadData2 !== exp2) begin
                $display("[FAIL] %0s | ReadData2 (reg %0d) = 0x%08h, Expected = 0x%08h", test_name, r2_addr, ReadData2, exp2);
                errors = errors + 1;
            end else begin
                $display("[PASS] %0s | reg[%0d]=0x%08h, reg[%0d]=0x%08h", test_name, r1_addr, ReadData1, r2_addr, ReadData2);
            end
        end
    endtask

    // Main Test Sequence
    initial begin
        // 1. Initialize signals and assert Reset
        rst = 1'b1;
        WriteEnable = 1'b0;
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd  = 5'd0;
        WriteData = 32'd0;
        
        #20;
        @(posedge clk);
        rst = 1'b0;
        #1;

        // Test 1: Verify Initial / Reset Values (regs[i] == i)
        check_outputs(5'd0, 32'd0, 5'd5, 32'd5, "Reset Values (x0 & x5)");
        check_outputs(5'd10, 32'd10, 5'd31, 32'd31, "Reset Values (x10 & x31)");

        // Test 2: Standard Write to Register x5
        @(negedge clk);
        rd = 5'd5;
        WriteData = 32'h1234_5678;
        WriteEnable = 1'b1;
        
        @(negedge clk);
        WriteEnable = 1'b0; // Deassert write enable
        check_outputs(5'd5, 32'h1234_5678, 5'd0, 32'd0, "Write to x5");

        // Test 3: Attempt writing to Register x0 (Must remain 0)
        @(negedge clk);
        rd = 5'd0;
        WriteData = 32'hDEAD_BEEF;
        WriteEnable = 1'b1;
        
        @(negedge clk);
        WriteEnable = 1'b0;
        check_outputs(5'd0, 32'h0000_0000, 5'd5, 32'h1234_5678, "Write to x0 Ignored");

        // Test 4: Simultaneous dual-port read after writing to x6
        @(negedge clk);
        rd = 5'd6;
        WriteData = 32'h0000_00AA;
        WriteEnable = 1'b1;
        
        @(negedge clk);
        WriteEnable = 1'b0;
        check_outputs(5'd5, 32'h1234_5678, 5'd6, 32'h0000_00AA, "Dual Read x5 & x6");

        // Test 5: Overwrite existing value in x5
        @(negedge clk);
        rd = 5'd5;
        WriteData = 32'h0000_0055;
        WriteEnable = 1'b1;
        
        @(negedge clk);
        WriteEnable = 1'b0;
        check_outputs(5'd5, 32'h0000_0055, 5'd6, 32'h0000_00AA, "Overwrite x5");

        // Test 6: Verify Reset restores regs[i] = i
        @(negedge clk);
        rst = 1'b1;
        @(posedge clk);
        #1;
        rst = 1'b0;
        #1;
        check_outputs(5'd5, 32'd5, 5'd6, 32'd6, "Reset Restores Defaults");

        // Final Report
        #20;
        $display("----------------------------------------------");
        if (errors == 0)
            $display("ALL TESTS PASSED SUCCESSFULLY!");
        else
            $display("TEST FAILED WITH %0d ERRORS.", errors);
        $display("----------------------------------------------");
        $finish;
    end

endmodule