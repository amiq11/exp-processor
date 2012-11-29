`define ph_f 0
`define ph_r 1
`define ph_x 2
module program_counter(phase_f, phase_w, ct_taken, ct_pc, pc, clk, n_rst, hlt);
    input               phase_f, phase_w;      // フェーズ信号.
    input               ct_taken;   // 分岐成立．zB, zJR などで 1
    input  [31:0]       ct_pc;
    output [31:0]       pc;
    input               clk, n_rst, hlt; // リセットは負論理

    reg [31:0] pcr;
    
    always @(posedge clk) begin
        if (!n_rst | hlt) 
          pcr <= 32'hFFFFFFFF;
        else begin
            // if ( phase_f ) pcr <= (pcr + 4) & 32'hFFFFFFFC;
            // else if ( phase_w && ct_taken ) pcr <= ct_pc & 32'hFFFFFFFC;
            pcr <= pcctl( pcr, ct_pc, ct_taken, phase_f, phase_w );
        end
    end // always

    // assign pc = pcr;

    assign pc = pcctl( pcr, ct_pc, ct_taken, phase_f, phase_w );

    function [31:0] pcctl;
        input [31:0] pc, dr;
        input ct_taken;
        input phase_f,phase_w;
        begin
            if      ( phase_f )             pcctl = (pc + 4) & 32'hFFFFFFFC;
            else if ( phase_w && ct_taken ) pcctl = dr & 32'hFFFFFFFC;
            else                            pcctl = pc;
        end
    endfunction //

endmodule
