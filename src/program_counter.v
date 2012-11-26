`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

module program_counter(phase, ct_taken, ct_pc, pc, clk, n_rst);
    input [`ph_w : `ph_f]   phase;      // フェーズ信号.
    input                   ct_taken;   // 分岐成立．zB, zJR などで 1
    input  [31:0]       ct_pc;
    output [31:0]       pc;
    input               clk, n_rst; // リセットは負論理

    reg [31:0] pcr;
    
    always @(posedge clk) begin
        if (n_rst == 0) 
          pcr <= 0;
        else
          if ( phase[`ph_w] )
            pcr <= pcctl( pcr, ct_pc, ct_taken, phase[`ph_w] );
    end // always

    assign pc = pcctl( pcr, ct_pc, ct_taken, phase[`ph_w] );

    function [31:0] pcctl;
        input [31:0] pc, dr;
        input ct_taken;
        input phase;
        begin
            if ( phase ) begin
                if ( ct_taken ) pcctl =  dr      & 32'hFFFFFFFC;
                else            pcctl = (pc + 4) & 32'hFFFFFFFC;
            end else begin
                pcctl = pc;
            end
        end
    endfunction //

endmodule
