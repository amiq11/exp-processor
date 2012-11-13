`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

`define eax 3'b000
`define ecx 3'b001
`define edx 3'b010
`define ebx 3'b011
`define esp 3'b100
`define ebp 3'b101
`define esi 3'b110
`define edi 3'b111

// `define INST_CONST 32'b00_000_001_11_000_001_00000000_00000000 // zADD r0 r1
// `define INST_CONST 32'b00_101_001_11_000_001_00000000_00000000 // zSUB r0 r1
// `define INST_CONST 32'b00_111_001_11_000_001_00000000_00000000 // zCMP r0 r1
// `define INST_CONST 32'b00_100_001_11_000_001_00000000_00000000 // zAND r0 r1
// `define INST_CONST 32'b00_001_001_11_000_001_00000000_00000000 // zOR  r0 r1
// `define INST_CONST 32'b00_110_001_11_000_001_00000000_00000000 // zXOR r0 r1
// `define INST_CONST 32'b00_000_001_11_000_001_00000000_00000000 // zADD r0 r1

// `define INST_CONST1 32'b1000_1011_01_000_001_00000000_00000000  // zLD  r0 r1 0
// `define INST_CONST2 32'b00_000_001_11_000_111_00000000_00000000 // zADD r0 r7
// `define INST_CONST3 32'b00_000_001_11_010_111_00000000_00000000 // zADD r2 r7
// `define INST_CONST4 32'b1000_1001_01_000_001_00000000_00000000  // zST  r0 r1 0

// LIL test
// `define INST_0 32'b0110_0110_10_111_000_0101_0101_1010_1010 // zLIL 0x55AA r0
// `define INST_1 32'b0110_0110_10_111_001_0101_0101_1010_1010 // zLIL 0x55AA r1
// `define INST_2 32'b0110_0110_10_111_010_0101_0101_1010_1010 // zLIL 0x55AA r2
// `define INST_3 32'b0110_0110_10_111_011_0101_0101_1010_1010 // zLIL 0x55AA r3

// ST/LD
// `define INST_0 32'b0110_0110_10_111_000_0101_0101_1010_1010 // zLIL 0x55AA r0
// `define INST_1 32'b1000_1001_01_000_001_1111_1111_0000_0000 // zST  r0 r1 -1
// `define INST_2 32'b0110_0110_10_111_000_1010_1010_0101_0101 // zLIL 0xAA00 r0
// `define INST_3 32'b1000_1011_01_000_001_1111_1111_0000_0000 // zLD  r0 r1 -1

// MOV/ADD
// `define INST_0 32'b00_000_001_11_000_001_00000000_00000000  // zADD r0 r1
// `define INST_1 32'b1000_1001_01_001_111_1111_1111_0000_0000 // zST  r1 r7 -1
// `define INST_2 32'b1000_1000_11_001_010_0000_0000_0000_0000 // zMOV r1 r2
// `define INST_3 32'b1000_1011_01_011_111_1111_1111_0000_0000 // zLD  r3 r7 -1

// SUB/CMP
// `define INST_0 32'b00_101_001_11_000_001_00000000_00000000  // zSUB r0 r1
// `define INST_1 32'b00_101_001_11_000_001_00000000_00000000  // zSUB r0 r1
// `define INST_2 32'b00_111_001_11_000_001_00000000_00000000  // zCMP r0 r1
// `define INST_3 32'b00_111_001_11_010_001_00000000_00000000  // zCMP r2 r1

// SUB/ADD
// `define INST_0 32'b00_101_001_11_000_001_00000000_00000000  // zSUB r0 r1
// `define INST_1 32'b00_101_001_11_000_001_00000000_00000000  // zSUB r0 r1
// `define INST_2 32'b00_000_001_11_000_001_00000000_00000000  // zADD r0 r1
// `define INST_3 32'b00_000_001_11_000_001_00000000_00000000  // zADD r0 r1

// ADDI/SUBI
// `define INST_0 32'b1000_0000_11_101_001_01000000_00000000  // zSUBI    r1, 64
// `define INST_1 32'b1000_0000_11_111_001_11000000_00000000  // zCMPI    r1, 
// `define INST_2 32'b1000_0000_11_000_001_00111111_00000000  // zADDI    r1, 63
// `define INST_3 32'b1000_0000_11_000_001_00000010_00000000  // zADDI    r1, 2

// NEG/NOT
// `define INST_0 32'b0110_0110_10_111_000_00000000_00000001  // zLIL     r0 1
// `define INST_1 32'b1111_0110_11_011_000_00000000_00000000  // zNEG     r0
// `define INST_2 32'b0110_0110_10_111_000_00000000_00000001  // zLIL     r0 1
// `define INST_3 32'b1111_0110_11_010_000_00000000_00000000  // zNOT     r0
  

`define memsize 9               // MEMBITS+1 bit 

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

    // 7seg
    reg [7:0]                         r_controller; // 7seg disp
    wire [31:0]                       r_reg [0:7];  // 7seg disp

    // register file
    wire [2:0]                        ra1, ra2, wa; // register file address
    wire [31:0]                       rd1, rd2, wd, resp, wespd; // register file data
    wire                              hlt, we, wespen;

    // phase controller
    wire [`ph_w:`ph_f]                phase;

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
    wire   alustf, alusf, aluzf, alucf, aluvf, alupf; // alu flag 

    // memory
    wire   [31:0]                     mem_wd1, mem_wd2, mem_rd1, mem_rd2; // memory data
    wire   [`memsize:0]               mem_a1, mem_a2;                     // memory address
    wire                              mem_we1, mem_we2;                   // memory write enable

    // program counter
    wire   [31:0]                     pc; // program counter
    wire                              ct_taken; // conditional branch

    // instruction decoder
    wire                              s,w;            // sign, opsize
    wire   [7:0]                      sim8;

    // test state controller
    reg    [1:0]                      teststate; // for simulation

    // ************************************************ //
    // assign
    
    // register file
    assign ra1 = ir1[21:19];
    assign ra2 = ir1[18:16];
    assign we  = rfctl_wen( ir4, phase[`ph_w] ); // phase writebackのときに書き戻し
    assign wa  = rfctl_wa( ir4 );
    assign wd  = rfctl_wd( ir4, dr2, mdr );
    assign wespd  = dr2;                               // esp data
    assign wespen = rfctl_wespen( ir4, phase[`ph_w] ); // esp write enable

    // alu
    assign alui  = ir2;
    assign alutr = tr;
    assign alusr = sr1;

    // program counter
    assign ct_taken = (ir4[31:16] == `zBcc || ir4[31:16] == `zB ) ? 1'b1 : 1'b0;

    // memory
    assign mem_a1  = (ir4[31:16] == `zBcc || ir4[31:16] == `zB ) ? dr2 : pc;
    assign mem_a2  = memctl_a2( ir2, tr );
    assign mem_wd2 = sr1;
    assign mem_we2 = memctl_wen2( ir2 );

    /* ------------------------------------------------------ */
    // phase generator
    phase_gen pg(0, phase, CLK, N_RST);

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
    program_counter program_counter( phase, ct_taken, dr2, pc, CLK, N_RST );
    
    
    /* ------------------------------------------------------ */
    // control
    // ホントはphase counterのお仕事？
    always @( posedge CLK or negedge N_RST ) begin
        if ( N_RST == 0 ) begin
            ir1 <= 0; ir2 <= 0; ir3 <= 0; ir4 <= 0;
            tr <= 0;
            sr1 <= 0; sr2 <= 0;
            dr1 <= 0; dr2 <= 0;
            teststate <= 0;     // for simulation
            sf <= 0; zf <= 0; cf <= 0; vf <= 0; pf <= 0;
        end
        else begin
            if ( phase[`ph_f] ) begin
                // ir1 <= mem_rd1;  // MD -> IR1
                // ra1, ra2の更新はir1を使ってfunctionで行われる
                case ( teststate )
                  0: ir1 <= `INST_0;
                  1: ir1 <= `INST_1;
                  2: ir1 <= `INST_2;
                  3: ir1 <= `INST_3;
                endcase
                teststate <= teststate + 1;
            end
            if ( phase[`ph_r] ) begin
                ir2 <= ir1;
                sr1 <= rd1;                
                tr  <= ( (ir2[31:16] == `zPOP) || (ir2[31:16] == `zPUSH) ) ? resp : rd2;
            end
            if ( phase[`ph_x] ) begin
                // irの更新
                ir3 <= ir2;
                dr1 <= ( (ir2[31:16] == `zB) || (ir2[31:16] == `zBcc) ) ? pc + ir2[15:8] : aluout[31:0];
                
                // status registerの更新
                if ( alustf ) begin
                    sf <= alusf;
                    zf <= aluzf;
                    cf <= alucf;
                    vf <= aluvf;
                end
            end
            if ( phase[`ph_m] ) begin
                ir4 <= ir3;
                mdr <= mem_rd2; // いつも入れてもいいもんなのかは微妙？ wフェーズで無視すればOKなはず
                dr2 <= dr1;
            end
            if ( phase[`ph_w] ) begin
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
                  default: rfctl_wespen = 0;
                endcase // case ( inst[31:16] )
            end
            else begin
                rfctl_wespen = 0;
            end
        end
    endfunction
    

    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ //
    // memory controller
    function [`memsize:0] memctl_a2;
        input [31:0] inst, t;
        begin
            casex ( inst[31:16] )
              `zLD:   memctl_a2 = t + inst[15:8] ;
              `zST:   memctl_a2 = t + inst[15:8] ;
              `zPUSH: memctl_a2 = t;
              `zPOP : memctl_a2 = t;
            endcase // case ( inst[31:16] )
        end
    endfunction // pg

    function memctl_wen2;
        input  [31:0] inst;
        begin
            casex ( inst[31:16] )
              `zST:    memctl_wen2 = 1;
              `zPUSH:  memctl_wen2 = 1;
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

