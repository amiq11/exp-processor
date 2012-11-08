`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

// `define INST_CONST 32'b00_000_001_11_000_001_00000000_00000000 // zADD r0 r1
// `define INST_CONST 32'b00_101_001_11_000_001_00000000_00000000 // zSUB r0 r1
// `define INST_CONST 32'b00_111_001_11_000_001_00000000_00000000 // zCMP r0 r1
// `define INST_CONST 32'b00_100_001_11_000_001_00000000_00000000 // zAND r0 r1
// `define INST_CONST 32'b00_001_001_11_000_001_00000000_00000000 // zOR  r0 r1
// `define INST_CONST 32'b00_110_001_11_000_001_00000000_00000000 // zXOR r0 r1
// `define INST_CONST 32'b00_000_001_11_000_001_00000000_00000000 // zADD r0 r1

`define INST_CONST1 32'b1000_1011_01_000_001_00000000_00000000  // zLD  r0 r1 0
`define INST_CONST2 32'b00_000_001_11_000_111_00000000_00000000 // zADD r0 r7
`define INST_CONST3 32'b00_000_001_11_010_111_00000000_00000000 // zADD r2 r7
`define INST_CONST4 32'b1000_1001_01_000_001_00000000_00000000  // zST  r0 r1 0

`define memsize 9               // MEMBITS+1 bit 

`define zLD0  10'b 1000_1010_01        // rg1, rg2, sim8
`define zST0  10'b 1000_1000_01        // rg1, rg2, sim8
`define zLIL  13'b 0110_0110_10_111    //      rg2, im16
`define zMOV  10'b 1000_1000_11        // rg1, rg2
`define zADD  10'b 0000_0001_11        // rg1, rg2
`define zSUB  10'b 0010_1001_11        // rg1, rg2
`define zCMP  10'b 0011_1001_11        // rg1, rg2 
`define zAND  10'b 0010_0001_11        // rg1, rg2  
`define zOR   10'b 0000_1001_11        // rg1, rg2 
`define zXOR  10'b 0011_0001_11        // rg1, rg2  
`define zADDI 13'b 1000_0000_11_000    //      rg2, sim8
`define zSUBI 13'b 1000_0000_11_101    //      rg2, sim8
`define zCMPI 13'b 1000_0000_11_111    //      rg2, sim8 
`define zANDI 13'b 1000_0000_11_100    //      rg2, sim8  
`define zOR I 13'b 1000_0000_11_001    //      rg2, sim8 
`define zXORI 13'b 1000_0000_11_110    //      rg2, sim8  
`define zNEG  13'b 1111_0110_11_011    //      rg2
`define zNOT  13'b 1111_0110_11_010    //      rg2
`define zSLL  13'b 1100_0000_11_100    //      rg2, sim8
`define zSLA  13'b 1100_0000_11_100    //      rg2, sim8
`define zSRL  13'b 1100_0000_11_101    //      rg2, sim8
`define zSRA  13'b 1100_0000_11_111    //      rg2, sim8
`define zB    16'b 1001_0000_1110_1011 //           sim8
`define zBcc  12'b 1001_0000_0111      //           sim8, tttn
`define zJALR 13'b 1111_1111_11_010    //      rg2
`define zRET  8'b  1100_0011           // 
`define zJR   13'b 1111_1111_11_100    //      rg2
`define zPUSH 5'b  0101_0              //      rg2
`define zPOP  5'b  0101_1              //      rg2
`define zNOP  16'b 1001_0000_1001_0000 // nop
`define zHLT  8'b  1111_0100           // hlt




module top_module(input              CLK,
                  input              N_RST,
                  output wire [63:0] SEG_OUT,
                  output wire [7:0]  SEG_SEL);

    reg [7:0]                         r_controller; // 7seg disp
    wire [31:0]                       r_reg [0:7];  // 7seg disp
    
    wire [2:0]                        ra1, ra2, wa; // register file address
    wire [31:0]                       rd1, rd2, wd; // register file data
    wire                              hlt, we;
    wire [`ph_w:`ph_f]                phase;

    reg    [31:0]                     ir1, ir2, ir3, ir4,
                                      tr,
                                      sr1, sr2,
                                      dr1, dr2,
                                      mdr; // core register
    
    wire   [31:0]                     aluA, aluB, aluOUT; // alu in/out
    wire   [2:0]                      aluI;         // alu instruction
    
    wire   [31:0]                     mem_wd1, mem_wd2, mem_rd1, mem_rd2; // memory data
    wire   [`memsize:0]               mem_a1, mem_a2;                     // memory address
    reg                               mem_we1, mem_we2;                   // memory write enable

    wire   [31:0]                     pc; // program counter
    reg                               ct_taken; // conditional branch

    wire   [5:0]                      i_1_6;          // 1byte top 6bits
    wire   [1:0]                      i_2_2;          // 2byte top 2bits
    wire                              s,w;            // sign, opsize
    wire   [7:0]                      sim8;

    reg    [1:0]                      teststate; // for simulation

    assign we  = phase[`ph_w];       // phase writebackのときに書き戻し
    assign ra1 = ir[21:19];
    assign ra2 = ir[18:16];
    assign wa  = ir[21:19];
    
    assign aluI = ir[29:27];
    assign aluA = tr;
    assign aluB = sr;
    
    assign wd = dr;

    // assign i_s = ir[25];
    // assign i_w = ir[24];
    // assign sim8 = ir[15:8];

    // assign mem_a1 = tr[9:0]+sim8;
    // assign mem_wd1 = sr;

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
                            CLK, 
                            N_RST,
                            r_reg[0], r_reg[1], r_reg[2], r_reg[3], r_reg[4], r_reg[5], r_reg[6], r_reg[7]);


    /* ------------------------------------------------------ */
    // alu(adder)
    alu alu( aluI, aluA, aluB, aluOUT );

    /* ------------------------------------------------------ */
    // mem
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
            ir <= 0; 
            tr <= 0;
            sr <= 0;
            dr <= 0;
            mem_we1 <= 0; mem_we2 <= 0;
            ct_taken <= 0;
            teststate <= 0;     // for simulation
        end
        else begin
            if ( phase[`ph_f] ) begin
                ir1 <= mem_rd1;  // MD -> IR1
                // 適当                
                // case ( teststate )
                //   0: ir <= `INST_CONST1;
                //   1: ir <= `INST_CONST2;
                //   2: ir <= `INST_CONST3;
                //   3: ir <= `INST_CONST4;
                // endcase // case ( teststate )
                // teststate <= teststate + 1;
                // if ( teststate == 2 ) teststate <= 0;
                // else teststate <= teststate + 1;
            end
            if ( phase[`ph_r] ) begin
                ir2 <= ir1;
                sr1 <= rd1;
                
                tr <= rd2;
            end
            if ( phase[`ph_x] ) begin
                // LDはここで待ち
                // STはここでweを1
                if ( i_1_6 == `zLDSTh && i_2_2 ==  `zLDSTl && s == 0 ) begin
                    wmemen <= 1;
                end
                if ( ir[31:30] == 2'b00 ) begin // alu
                    dr <= aluOUT;
                end else begin
                    dr <= sr; // とりあえず適当
                end
            end
            if ( phase[`ph_x] ) begin
                // memory
                if ( i_1_6 == `zLDSTh && i_2_2 ==  `zLDSTl && s == 1 ) begin
                    dr <= rmemd;
                end
                if ( i_1_6 == `zLDSTh && i_2_2 ==  `zLDSTl && s == 0 ) begin
                    wmemen <= 0;
                end
            end
            if ( phase[`ph_w] ) begin
                // 勝手に書き込む
            end
        end // else: !if( N_RST == 0 )
    end // always @ ( posedge CLK, negedge N_RST )

    
    

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

