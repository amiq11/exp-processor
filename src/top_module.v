// `define ph_f 0
// `define ph_r 1
// `define ph_x 2
// `define ph_m 3
// `define ph_w 4

`define eax 3'b000
`define ecx 3'b001
`define edx 3'b010
`define ebx 3'b011
`define esp 3'b100
`define ebp 3'b101
`define esi 3'b110
`define edi 3'b111

`define ct_o   4'b0000
`define ct_no  4'b0001
`define ct_b   4'b0010
`define ct_nb  4'b0011
`define ct_e   4'b0100
`define ct_ne  4'b0101
`define ct_be  4'b0110
`define ct_nbe 4'b0111
`define ct_s   4'b1000
`define ct_ns  4'b1001
`define ct_p   4'b1010
`define ct_np  4'b1011
`define ct_l   4'b1100
`define ct_nl  4'b1101
`define ct_le  4'b1110
`define ct_nle 4'b1111

`define memsize 9               // memsize+1ビットのアドレスを持つメモリを確保

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




module top_module(input              CLK,
                  input              N_RST,
                  output wire [63:0] SEG_OUT,
                  output wire [7:0]  SEG_SEL);

    // reset
    reg                               rst;
    
    // 7seg
    reg [7:0]                         r_controller; // 7seg disp
    wire [31:0]                       r_reg [0:7];  // 7seg disp

    // register file
    wire [2:0]                        ra1, ra2, wa; // register file address
    wire [31:0]                       rd1, rd2, wd, resp, wespd; // register file data
    wire                              we, wespen;
    reg                               hlt;

    // phase controller
    // wire [`ph_w:`ph_f]                phase;

    // core register
    reg    [31:0]                     ir1, ir2, ir3, ir4,
                                      tr,
                                      sr1, sr2,
                                      dr1, dr2,
                                      mdr;
    reg                               sf, zf, cf, vf, pf; // flags
    
    // alu
    wire   [31:0]                     alui, alutr, alusr; // alu in
    wire   [32:0]                     aluout;       // alu out
    wire                              alustf, alusf, aluzf, alucf, aluvf, alupf; // alu flag 

    // memory
    wire   [31:0]                     mem_wd1, mem_rd1, mem_rd2; // memory data
    wire   [`memsize:0]               mem_a1, mem_a2;            // memory address
    wire                              mem_we1, mem_we2;          // memory write enable
    reg    [31:0]                     mem_wd2;

    // program counter
    wire   [31:0]                     pc1;             // program counter
    reg    [31:0]                     pc2,pc3,pc4,pc5; // program counter for pipeline
    reg    [31:0]                     ct_pc;           // distination
    wire                              ct_taken;        // conditional branch
    wire                              ct_mdr;          // conditional branch by mdr

    // hazard detector
    wire                              n_f, n_r, n_x, n_m, n_w;

    // ************************************************ //
    // assign
    
    // register file
    assign ra1    = ir1[21:19];
    assign ra2    = ir1[18:16];
    assign we     = rfctl_wen( ir4, n_w ); // phase writebackのときに書き戻し
    assign wa     = rfctl_wa( ir4 );
    assign wd     = rfctl_wd( ir4, dr2, mdr );
    assign wespen = rfctl_wespen( ir4, n_w ); // esp write enable
    assign wespd  = rfctl_wespd( ir4, pc5, dr2 );

    // alu
    assign alui  = ir2;
    assign alutr = tr;
    assign alusr = sr1;
    
    // program counter
    assign ct_taken = (n_w & ct_takenctl( ir4, sf, zf, cf, vf ));

    // memory
    assign mem_a1  = pc1[`memsize+2:2];
    assign mem_we1 = 1'b0;
    assign mem_wd1 = 32'h00000000;
    assign mem_a2  = memctl_a2( ir2, aluout[31:0] );
    // assign mem_a2  = tr[`memsize+2:2];
    // assign mem_wd2 = mwd;
    assign mem_we2 = n_x & memctl_wen2( ir2 );

    /* ------------------------------------------------------ */
    // phase generator
    // phase_gen pg(hlt, phase, CLK, N_RST);

    /* ------------------------------------------------------ */
    // register
    register_file register( ra1,
                            ra2,
                            wa, 
                            rd1,  
                            rd2, 
                            wd,
                            we,
                            wespd,
                            wespen,
                            resp,
                            CLK, 
                            N_RST,
                            r_reg[0], r_reg[1], r_reg[2], r_reg[3], r_reg[4], r_reg[5], r_reg[6], r_reg[7]);


    /* ------------------------------------------------------ */
    // alu
    alu alu( alui, alutr, alusr, aluout, alustf, alusf, aluzf, alucf, aluvf, alupf );

    /* ------------------------------------------------------ */
    // memory
    // 主記憶
    mem memory( mem_a1, mem_a2, CLK, mem_wd1, mem_wd2, mem_we1, mem_we2, mem_rd1, mem_rd2 );

    /* ------------------------------------------------------ */
    // pc
    program_counter program_counter( n_f, n_w, ct_taken, ct_pc, pc1, CLK, N_RST, hlt );

    /* ------------------------------------------------------ */
    // hazard detector
    // データハザードを検知したらフラグを立てて、次のステージに進んでいいかどうかを判断する。
    hazard_detector hd( ir1, ir2, ir3, ir4, n_f, n_r, n_x, n_m, n_w );
    
    
    
    /* ------------------------------------------------------ */
    // control
    always @( posedge CLK or negedge N_RST ) begin
        rst <= N_RST;
        if ( N_RST == 0 ) begin
            hlt <= 0;
            ir1 <= {`zNOP, 16'b0 }; ir2 <= {`zNOP, 16'b0 }; ir3 <= {`zNOP, 16'b0 }; ir4 <= {`zNOP, 16'b0 };
            tr <= 0;
            sr1 <= 0; sr2 <= 0;
            dr1 <= 0; dr2 <= 0;
            sf <= 0; zf <= 0; cf <= 0; vf <= 0; pf <= 0;
            pc2 <= 0; pc3 <= 0; pc4 <= 0; pc5 <= 0;
            mdr <= 0; mem_wd2 <= 0;
            ct_pc <= 0;
        end
        else if ( !hlt ) begin
            if ( n_f ) begin
                pc2 <= pc1;
                ir1 <= mem_rd1;  // MD -> IR1
                // ra1, ra2の更新はir1を使ってfunctionで行われる
            end 
            if ( n_r ) begin
                pc3 <= pc2;
                ir2 <= ir1;
                mem_wd2 <= mem_wd2ctl( ir1, rd1, rd2, pc2 );
                sr1 <= srctl( ir1, rd1, rd2 );
                tr  <= trctl( ir1, pc2, resp, rd2 );
                if ( ~n_f & ~ct_taken ) ir1 <= {`zNOP, 16'b0 };
            end
            if ( n_x ) begin
                pc4 <= pc3;
                // irの更新
                ir3 <= ir2;
                sr2 <= sr1;
                dr1 <= aluout[31:0];                
                // status registerの更新
                if ( alustf ) begin
                    sf <= alusf;
                    zf <= aluzf;
                    cf <= alucf;
                    vf <= aluvf;
                end
                if ( ~n_r & ~ct_taken ) ir2 <= {`zNOP, 16'b0 };
            end
            if ( n_m ) begin
                pc5   <= pc4;
                ir4   <= ir3;
                mdr   <= mem_rd2; // いつも入れてもいいもんなのかは微妙？ wフェーズで無視すればOKなはず
                dr2   <= dr1;
                ct_pc <= ct_pcctl( ir3, dr1, sr2, mem_rd2 );
                if ( ~n_x & ~ct_taken ) ir3 <= {`zNOP, 16'b0 };
            end
            if ( n_w ) begin
                hlt <= ( {ir4[31:24],8'bxxxxxxxx} === `zHLT ) ? 1'b1 : 1'b0;
                if ( ~n_m & ~ct_taken ) ir4 <= {`zNOP, 16'b0 };
            end
            if ( ct_taken ) begin
                ir1 <=  {`zNOP, 16'b0 };
                ir2 <=  {`zNOP, 16'b0 };
                ir3 <=  {`zNOP, 16'b0 };
                ir4 <=  {`zNOP, 16'b0 };
            end
        end // else: !if( N_RST == 0 )
    end // always @ ( posedge CLK, negedge N_RST )

    
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // register file controller
    // 
    function rfctl_wen;
        input  [31:0] inst;
        input  phase;
        begin
            if ( phase ) begin
                casex ( inst[31:16] )
                  `zST:    rfctl_wen = 0;
                  `zBcc:   rfctl_wen = 0;
                  `zJR:    rfctl_wen = 0;
                  `zNOP:   rfctl_wen = 0;
                  `zHLT:   rfctl_wen = 0;
                  `zRET:   rfctl_wen = 0;
                  `zJALR:  rfctl_wen = 0;
                  `zB:     rfctl_wen = 0;
                  `zCMP:   rfctl_wen = 0;
                  `zCMPI:  rfctl_wen = 0;
                  `zPUSH:  rfctl_wen = 0;
                  default: rfctl_wen = 1;
                endcase // casex ( inst[31:16] )
            end
            else begin
              rfctl_wen = 0;
            end
        end
    endfunction // if
    function [2:0] rfctl_wa;
        input  [31:0] inst;
        begin
            casex ( inst[31:16] )
              `zLD:    rfctl_wa = inst[21:19]; // rg1
              default: rfctl_wa = inst[18:16]; // rg2
            endcase // case ( inst[31:16] )
        end
    endfunction // casex
    function [31:0] rfctl_wd;
        input  [31:0] inst, d, md;
        begin
            casex ( inst[31:16] )
              `zLD:    rfctl_wd = md;
              `zPOP:   rfctl_wd = md;
              default: rfctl_wd = d;
            endcase // case ( inst[31:16] )
        end
    endfunction // rfctl_wd
    function rfctl_wespen;
        input  [31:0] inst;
        input  phase;
        begin
            if ( phase ) begin
                casex ( inst[31:16] )
                  `zPOP:   rfctl_wespen = 1;
                  `zPUSH:  rfctl_wespen = 1;
                  `zJALR:  rfctl_wespen = 1;
                  `zRET:   rfctl_wespen = 1;
                  default: rfctl_wespen = 0;
                endcase // case ( inst[31:16] )
            end
            else begin
                rfctl_wespen = 0;
            end
        end
    endfunction // if
    function [31:0] rfctl_wespd;
        input  [31:0] inst, pc, dr;
        begin
            casex( inst[31:16] )
              `zPOP:    rfctl_wespd = dr;
              `zPUSH:   rfctl_wespd = dr;
              `zJALR:   rfctl_wespd = dr;
              `zRET:    rfctl_wespd = dr;
              default:  rfctl_wespd = 32'h00000000;
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    

    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // sr
    function [31:0] srctl;
        input  [31:0] inst, rd1, rd2;
        begin
            casex( inst[31:16] )
              `zJALR : srctl = rd2;
              default: srctl = rd1;
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    
    // tr
    function [31:0] trctl;
        input  [31:0] inst, pc, resp, rd;
        begin
            casex ( inst[31:16] )
              `zB   : trctl = pc;
              `zBcc : trctl = pc;
              `zPOP : trctl = resp;
              `zPUSH: trctl = resp;
              `zJALR: trctl = resp;
              `zRET : trctl = resp;  
              default: trctl = rd;
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // tttn
    function  ct_takenctl;
        input [31:0] inst;
        input sf, zf, cf, vf;
        begin
            casex ( inst[31:16] )
              `zBcc: begin
                  case ( inst[19:16] )
                    `ct_o  : ct_takenctl = vf;
                    `ct_no : ct_takenctl = ~vf;
                    `ct_b  : ct_takenctl = cf;  
                    `ct_nb : ct_takenctl = ~cf; 
                    `ct_e  : ct_takenctl = zf;  
                    `ct_ne : ct_takenctl = ~zf; 
                    `ct_be : ct_takenctl = cf | zf;  
                    `ct_nbe: ct_takenctl = ~(cf | zf); 
                    `ct_s  : ct_takenctl = sf;  
                    `ct_ns : ct_takenctl = ~sf; 
                    `ct_p  : ct_takenctl = pf;  
                    `ct_np : ct_takenctl = ~pf; 
                    `ct_l  : ct_takenctl = sf ^ vf;  
                    `ct_nl : ct_takenctl = ~( sf ^ vf ); 
                    `ct_le : ct_takenctl = ( sf ^ vf ) | zf;  
                    `ct_nle: ct_takenctl = ~( ( sf ^ vf ) | zf );
                  endcase // case ( inst[19:16] )
              end
              `zB:
                ct_takenctl = 1'b1;
              `zJR:
                ct_takenctl = 1'b1;
              `zJALR:
                ct_takenctl = 1'b1;
              `zRET:
                ct_takenctl = 1'b1;
              default:
                ct_takenctl = 1'b0;
            endcase // casex ( inst )
        end
    endfunction // casex
    function [31:0] ct_pcctl;
        input  [31:0] inst, dr, rg, md;
        begin
            casex ( inst[31:16] )
              `zBcc  : ct_pcctl = dr + 3;
              `zB    : ct_pcctl = dr + 3;
              `zJR   : ct_pcctl = rg;
              `zJALR : ct_pcctl = rg;
              `zRET  : ct_pcctl = md;
              default: ct_pcctl = 32'h00000000;
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    

    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // memory controller
    
    function [31:0] mem_wd2ctl;
        input  [31:0] inst, rd1, rd2, pc;
        begin
            casex ( inst[31:16] )
              `zPUSH:  mem_wd2ctl = rd2;
              `zJALR:  mem_wd2ctl = pc + 4;
              `zST  :  mem_wd2ctl = rd1;
              default: mem_wd2ctl = 32'h00000000;
            endcase // casex ( inst[31:16] )
        end
    endfunction // casex
    function [`memsize:0] memctl_a2;
        input [31:0] inst, t;
        begin
            casex ( inst[31:16] )
              `zLD:   memctl_a2 = t[`memsize+2:2];
              `zST:   memctl_a2 = t[`memsize+2:2];
              `zPUSH: memctl_a2 = (t[`memsize+2:0] + 4) >> 2;
              `zPOP : memctl_a2 = t[`memsize+2:2];
              `zJALR: memctl_a2 = (t[`memsize+2:0] + 4) >> 2;
              `zRET : memctl_a2 = t[`memsize+2:2];
              default: memctl_a2 = 0;
            endcase // case ( inst[31:16] )
        end
    endfunction // pg
    
    function memctl_wen2;
        input  [31:0] inst;
        begin
            casex ( inst[31:16] )
              `zST:    memctl_wen2 = 1;
              `zPUSH:  memctl_wen2 = 1;
              `zJALR:  memctl_wen2 = 1;
              default: memctl_wen2 = 0;
            endcase
        end
    endfunction // seg_out_select
    

    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // segment controller
    // ホントはモジュール化したいところ
    assign SEG_OUT = seg_out_select(r_controller);
    assign SEG_SEL = r_controller;

    /* ------------------------------------------------------ */
    // seg_controller 
    always @(posedge CLK or negedge N_RST) begin
        if(~N_RST) begin
            r_controller <= 8'b0000_0000;
        end else if(r_controller == 8'b0000_0000) begin
            r_controller <= 8'b0000_0001;
        end else begin
            r_controller <= {r_controller[6:0] , r_controller[7]};
        end
    end
    /* ------------------------------------------------------ */
    // seg_out_selector
    function [63:0] seg_out_select;
        input [7:0] controller;
        case(controller)
          8'b0000_0001 : seg_out_select = seg_decoder_32(r_reg[0]);
          8'b0000_0010 : seg_out_select = seg_decoder_32(r_reg[1]);
          8'b0000_0100 : seg_out_select = seg_decoder_32(r_reg[2]);
          8'b0000_1000 : seg_out_select = seg_decoder_32(r_reg[3]);
          8'b0001_0000 : seg_out_select = seg_decoder_32(r_reg[4]);
          8'b0010_0000 : seg_out_select = seg_decoder_32(r_reg[5]);
          8'b0100_0000 : seg_out_select = seg_decoder_32(r_reg[6]);
          8'b1000_0000 : seg_out_select = seg_decoder_32(r_reg[7]);
          default        : seg_out_select = 64'd0;
        endcase
    endfunction 
    /* ------------------------------------------------------ */
    // seg_decoder
    function [7:0] seg_decoder_4;
        input [3:0] value;
        case(value)
          4'h0 : seg_decoder_4 = 8'b1111_1100;
          4'h1 : seg_decoder_4 = 8'b0110_0000;
          4'h2 : seg_decoder_4 = 8'b1101_1010;
          4'h3 : seg_decoder_4 = 8'b1111_0010;
          4'h4 : seg_decoder_4 = 8'b0110_0110;
          4'h5 : seg_decoder_4 = 8'b1011_0110;
          4'h6 : seg_decoder_4 = 8'b1011_1110;
          4'h7 : seg_decoder_4 = 8'b1110_0000;
          4'h8 : seg_decoder_4 = 8'b1111_1110;
          4'h9 : seg_decoder_4 = 8'b1111_0110;
          4'ha : seg_decoder_4 = 8'b1110_1110;
          4'hb : seg_decoder_4 = 8'b0011_1110;
          4'hc : seg_decoder_4 = 8'b0001_1010;
          4'hd : seg_decoder_4 = 8'b0111_1010;
          4'he : seg_decoder_4 = 8'b1001_1110;
          4'hf : seg_decoder_4 = 8'b1000_1110;
        endcase
    endfunction
    function [63:0] seg_decoder_32;
        input [31:0] value;
        seg_decoder_32 = {seg_decoder_4(value[31:28]), 
                          seg_decoder_4(value[27:24]), 
                          seg_decoder_4(value[23:20]), 
                          seg_decoder_4(value[19:16]),
                          seg_decoder_4(value[15:12]), 
                          seg_decoder_4(value[11:8]), 
                          seg_decoder_4(value[7:4]), 
                          seg_decoder_4(value[3:0])};
    endfunction

endmodule

