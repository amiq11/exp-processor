`timescale 1ns / 1ps   // シミュレーションの単位時間/精度
`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

module dp_testbench;
    reg clk, n_rst;
    wire [63:0] seg_out;
    wire [7:0]  seg_sel;
    
    always begin    
        #5 clk = ~clk;
    end

    top_module top( clk, n_rst, seg_out, seg_sel );

    initial begin
        clk = 0; n_rst = 1;
        #20 n_rst = 0;
        #20 n_rst = 1;
        #1000 $finish;
    end
    
 
endmodule
