`timescale 1ns / 1ps      // /

module rf_testbench;

    //  input  reg 
    reg clk, n_rst; 

    reg [2:0]  ra1, ra2, wa;
    reg [31:0] wd;
    reg we;

    //  output  wire 
    wire [31:0] rd1, rd2;

    // 
    register_file rf(ra1, ra2, wa, rd1, rd2, wd, we, clk, n_rst);
 
    // input  initial 
    initial begin
        clk  = 0;  n_rst = 0;   
        ra1 = 0;  ra2 = 1;  wa = 0;
        we = 0;

        // Wait 100 ns for global reset to finish   
        #100  n_rst = 1;

        // , 
        #1;

        // 
        #10 
        wa = 0;  wd =  1;  we = 1;  //  0 1 
        #10 
        we = 0;             // we  0 
        #10
        wa = 1;  wd = -1;  we = 1;  //  1 -1 
        #10
        we = 0;
    end
 
    // 10 ns  always 
    always begin    
        #5 clk = ~clk;
    end
endmodule // testbench

