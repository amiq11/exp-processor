`define esp 3'b100

`define zLD   16'b 1000_101x_01_xxxxxx     // rg1, rg2, sim8
`define zST   16'b 1000_100x_01_xxxxxx     // rg1, rg2, sim8
`define zLIL  16'b 0110_0110_10_111_xxx    //      rg2, im16
`define zMOV  16'b 1000_100x_11_xxxxxx     // rg1, rg2
`define zADD  16'b 0000_000x_11_xxxxxx     // rg1, rg2
`define zSUB  16'b 0010_100x_11_xxxxxx     // rg1, rg2
`define zCMP  16'b 0011_100x_11_xxxxxx     // rg1, rg2 
`define zAND  16'b 0010_000x_11_xxxxxx     // rg1, rg2  
`define zOR   16'b 0000_100x_11_xxxxxx     // rg1, rg2 
`define zXOR  16'b 0011_000x_11_xxxxxx     // rg1, rg2
`define zADDI 16'b 1000_00xx_11_000_xxx    //      rg2, sim8
`define zSUBI 16'b 1000_00xx_11_101_xxx    //      rg2, sim8
`define zCMPI 16'b 1000_00xx_11_111_xxx    //      rg2, sim8 
`define zANDI 16'b 1000_00xx_11_100_xxx    //      rg2, sim8  
`define zORI  16'b 1000_00xx_11_001_xxx    //      rg2, sim8 
`define zXORI 16'b 1000_00xx_11_110_xxx    //      rg2, sim8  
`define zNEG  16'b 1111_011x_11_011_xxx    //      rg2
`define zNOT  16'b 1111_011x_11_010_xxx    //      rg2
`define zSLL  16'b 1100_000x_11_100_xxx    //      rg2, sim8
`define zSLA  16'b 1100_000x_11_100_xxx    //      rg2, sim8
`define zSRL  16'b 1100_000x_11_101_xxx    //      rg2, sim8
`define zSRA  16'b 1100_000x_11_111_xxx    //      rg2, sim8
`define zB    16'b 1001_0000_1110_1011     //           sim8
`define zBcc  16'b 1001_0000_0111_xxxx     //           sim8, tttn
`define zJALR 16'b 1111_1111_11_010_xxx    //      rg2
`define zRET  16'b 1100_0011_xxxx_xxxx     // 
`define zJR   16'b 1111_1111_11_100_xxx    //      rg2
`define zPUSH 16'b 1001_0000_0101_0_xxx    //      rg2
`define zPOP  16'b 1001_0000_0101_1_xxx    //      rg2
`define zNOP  16'b 1001_0000_1001_0000     // nop
`define zHLT  16'b 1111_0100_xxxx_xxxx     // hlt

module hazard_detector ( ir_r, ir_x, ir_m, ir_w,
                         next_f, next_r, next_x, next_m, next_w
                         );
    input  [31:0] ir_r, ir_x, ir_m, ir_w;
    output next_f, next_r, next_x, next_m, next_w;

    wire   w, m, x, r, f;

    assign f = next_fctl( ir_r, ir_x, ir_m, ir_w );
    assign r = next_rctl( ir_r, ir_x, ir_m, ir_w );
    assign x = next_xctl( ir_r, ir_x, ir_m, ir_w );
    assign m = next_mctl( ir_r, ir_x, ir_m, ir_w );
    assign w = next_wctl( ir_r, ir_x, ir_m, ir_w );
    assign next_f = w & m & x & r & f;
    assign next_r = w & m & x & r;
    assign next_x = w & m & x;
    assign next_m = w & m;
    assign next_w = w;

    function next_fctl;
        input  [31:0] ir_r, ir_x, ir_m, ir_w;
        begin
            next_fctl = 1'b1;
        end
    endfunction //
    function next_rctl;
        input  [31:0] ir_r, ir_x, ir_m, ir_w;
        begin
                 if ( readreg1(ir_r)==changedreg(ir_x) ) next_rctl = 1'b0;
            else if ( readreg1(ir_r)==changedreg(ir_m) ) next_rctl = 1'b0;
            else if ( readreg1(ir_r)==changedreg(ir_w) ) next_rctl = 1'b0;
            else if ( readreg2(ir_r)==changedreg(ir_x) ) next_rctl = 1'b0;
            else if ( readreg2(ir_r)==changedreg(ir_m) ) next_rctl = 1'b0;
            else if ( readreg2(ir_r)==changedreg(ir_w) ) next_rctl = 1'b0;
            else if ( is_stack(ir_r) & 
                      ( is_stack(ir_x) |
                        is_stack(ir_m) |
                        is_stack(ir_w) ) )               next_rctl = 1'b0;
            else                                         next_rctl = 1'b1;
        end
    endfunction //
    function next_xctl;
        input  [31:0] ir_r, ir_x, ir_m, ir_w;
        begin
            casex ( ir_x[31:16] )
              `zLD   : next_xctl = ~is_jump(ir_m);
              `zST   : next_xctl = ~is_jump(ir_m);
              `zPUSH : next_xctl = ~is_jump(ir_m);
              default: next_xctl = 1'b1;
            endcase // casex ( ir_x[31:16] )
        end
    endfunction //
    function next_mctl;
        input  [31:0] ir_r, ir_x, ir_m, ir_w;
        begin
            casex ( ir_m[31:16] )
              `zLD   : next_mctl = ~is_jump(ir_w);
              `zST   : next_mctl = ~is_jump(ir_w);
              `zPUSH : next_mctl = ~is_jump(ir_w);
              default: next_mctl = 1'b1;
            endcase // casex ( ir_m[31:16] )
        end
    endfunction //
    function next_wctl;
        input  [31:0] ir_r, ir_x, ir_m, ir_w;
        begin
            next_wctl = 1'b1;
        end
    endfunction //

    // ===========================================
    // スタックポインタ干渉チェック
    function is_stack;
        input  [31:0] ir;
        begin
            casex ( ir[31:16] )
              `zJALR:  is_stack = 1'b1;
              `zRET:   is_stack = 1'b1;
              `zPUSH:  is_stack = 1'b1;
              `zPOP:   is_stack = 1'b1;
              default: is_stack = (changedreg( ir ) == {2'b0,`esp})?1'b1:1'b0;
            endcase // casex ( ir[31:16] )
        end
    endfunction // casex
    

    // ===========================================
    // レジスタ干渉チェック
    function [4:0] readreg1;
        input  [31:0] ir;
        begin
            casex ( ir[31:16] )
              `zST:   readreg1 = {2'b0,ir[21:19]};
              `zMOV:  readreg1 = {2'b0,ir[21:19]};
              `zADD:  readreg1 = {2'b0,ir[21:19]};
              `zSUB:  readreg1 = {2'b0,ir[21:19]};
              `zCMP:  readreg1 = {2'b0,ir[21:19]};
              `zAND:  readreg1 = {2'b0,ir[21:19]};
              `zOR:   readreg1 = {2'b0,ir[21:19]};
              `zXOR:  readreg1 = {2'b0,ir[21:19]};
              default:readreg1 = 5'b10000;
            endcase // casex ( ir[31:16] )
        end
    endfunction // casex

    function [4:0] readreg2;
        input  [31:0] ir;
        begin
            casex ( ir[31:16] )
              `zLD:   readreg2 = {2'b0,ir[18:16]};
              `zST:   readreg2 = {2'b0,ir[18:16]};
              `zMOV:  readreg2 = {2'b0,ir[18:16]};
              `zADD:  readreg2 = {2'b0,ir[18:16]};
              `zSUB:  readreg2 = {2'b0,ir[18:16]};
              `zCMP:  readreg2 = {2'b0,ir[18:16]};
              `zAND:  readreg2 = {2'b0,ir[18:16]};
              `zOR:   readreg2 = {2'b0,ir[18:16]};
              `zXOR:  readreg2 = {2'b0,ir[18:16]};
              `zADDI: readreg2 = {2'b0,ir[18:16]};
              `zSUBI: readreg2 = {2'b0,ir[18:16]};
              `zCMPI: readreg2 = {2'b0,ir[18:16]};
              `zANDI: readreg2 = {2'b0,ir[18:16]};
              `zORI:  readreg2 = {2'b0,ir[18:16]};
              `zXORI: readreg2 = {2'b0,ir[18:16]};
              `zNEG:  readreg2 = {2'b0,ir[18:16]};
              `zNOT:  readreg2 = {2'b0,ir[18:16]};
              `zSLL:  readreg2 = {2'b0,ir[18:16]};
              `zSRL:  readreg2 = {2'b0,ir[18:16]};
              `zSRA:  readreg2 = {2'b0,ir[18:16]};
              `zJR:   readreg2 = {2'b0,ir[18:16]};
              `zJALR: readreg2 = {2'b0,ir[18:16]};
              `zPUSH: readreg2 = {2'b0,ir[18:16]};
              default:readreg2 = 5'b10000;
            endcase // casex ( ir[31:16] )
        end
    endfunction // casex
    

    // 5bit幅にして、changedregの4bit目が1なら変更なしとする。
    // 読み込み側のレジスタがないとき5bit目が1としておけば、5bitの完全一致を比較することで簡単に評価出来る。
    function [4:0] changedreg;
        input  [31:0] ir;
        begin
            casex ( ir[31:16] )
              `zST:   changedreg = 5'b01000;
              `zBcc:  changedreg = 5'b01000;
              `zJR:   changedreg = 5'b01000;
              `zNOP:  changedreg = 5'b01000;
              `zHLT:  changedreg = 5'b01000;
              `zRET:  changedreg = 5'b01000;
              `zJALR: changedreg = 5'b01000;
              `zB:    changedreg = 5'b01000;
              `zCMP:  changedreg = 5'b01000;
              `zCMPI: changedreg = 5'b01000;
              `zPUSH: changedreg = 5'b01000;
              `zLD:   changedreg = {2'b0,ir[21:19]}; // rg1
              default:changedreg = {2'b0,ir[18:16]}; // rg2
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    
    // =======================================
    // ジャンプ命令チェック

    function is_jump;
        input  [31:0] ir;
        begin
            casex ( ir[31:16] )
              `zBcc  : is_jump = 1'b1;
              `zB    : is_jump = 1'b1;
              `zJALR : is_jump = 1'b1;
              `zJR   : is_jump = 1'b1;
              default: is_jump = 1'b0;
            endcase // casex ( ir_w[31:16] )
        end
    endfunction //
    
endmodule // hazard_detector
