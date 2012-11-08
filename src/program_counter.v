`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

module program_counter(phase, ct_taken, dr, pc, clk, n_rst);
    input [`ph_w : `ph_f]   phase;      // フェーズ信号.
    input                   ct_taken;   // 分岐成立．zB, zJR などでも 1
    input  [31:0]       dr;
    output [31:0]       pc;
    input               clk, n_rst; // リセットは負論理

    reg [31:0] pc;
    always @(posedge clk) begin
        if (n_rst == 0) 
            pc <= 0;
        else if (phase[`ph_w] == 1  &&  ct_taken == 0)
            pc <= pc + 4;
        else if (phase[`ph_w] == 1  &&  ct_taken == 1)
            pc <= dr;
    end // always
endmodule
