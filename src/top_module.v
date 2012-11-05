`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

`define INST_CONST 32'b00_000_001_11_000_001_00000000_00000000 // zADD r0 r1
// `define INST_CONST 32'b00_101_001_11_000_001_00000000_00000000 // zSUB r0 r1
// `define INST_CONST 32'b00_111_001_11_000_001_00000000_00000000 // zCMP r0 r1
// `define INST_CONST 32'b00_100_001_11_000_001_00000000_00000000 // zAND r0 r1
// `define INST_CONST 32'b00_001_001_11_000_001_00000000_00000000 // zOR  r0 r1
// `define INST_CONST 32'b00_110_001_11_000_001_00000000_00000000 // zXOR r0 r1

module top_module(input              CLK,
                  input              N_RST,
                  output wire [63:0] SEG_OUT,
                  output wire [7:0]  SEG_SEL);

    reg [7:0]                         r_controller;
    wire [31:0]                       r_reg [0:7];
    wire [2:0]                        ra1, ra2, wa;
    wire [31:0]                       rd1, rd2, wd;
    wire                              hlt, we;
    wire [`ph_w:`ph_f]                phase;

    reg    [31:0]                     ir, tr, sr, dr;
    wire   [31:0]                     aluA, aluB, aluOUT;
    wire   [2:0]                     aluI;


    assign we = phase[`ph_w];
    assign ra1 = ir[21:19];
    assign ra2 = ir[18:16];
    assign wa  = ir[21:19];
    assign aluI = ir[29:27];
    assign aluA = tr;
    assign aluB = sr;
    assign wd = dr;

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
    // control
    // ホントはphase counterのお仕事？
    always @( posedge CLK, negedge N_RST ) begin
        if ( N_RST == 0 ) begin
            ir <= 0; 
            tr <= 0;
            sr <= 0;
            dr <= 0;
        end
        else begin
            case ( phase )
              `ph_f: 
                begin
                    ir <= `INST_CONST; // とりあえず定数を突っ込む
                end
              `ph_r: 
                begin
                    tr <= rd1;
                    sr <= rd2;
                end
              `ph_x:
                begin
                    dr <= aluOUT;
                end
              `ph_m:
                begin
                    // memory
                end
              `ph_w:
                begin
                end
            endcase // case ( phase )
        end
    end

    
    

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

