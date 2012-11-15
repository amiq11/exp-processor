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

// `define ADD 3'b000
// `define SUB 3'b101
// `define CMP 3'b111
// `define AND 3'b100
// `define OR  3'b001
// `define XOR 3'b110

module alu ( inst, tr, sr, out, st_refresh, sf, zf, cf, vf, pf );
    input  [31:0] inst;
    input  [31:0] tr, sr;
    output [32:0] out;

    output st_refresh, sf, zf, cf, vf, pf;

    assign out = calc( inst, tr, sr );
    assign st_refresh  = stflagctl( inst );
    assign sf = out[31];
    assign zf = (out[31:0] == 32'b0);
    assign cf = cfctl( inst, sr, out[32] );
    assign vf = vfctl( inst, sr, out[32], cf );
    assign pf = 1'b0;

    // todo: immの利用
    function [32:0] calc;
        input  [31:0] i;
        input  [31:0] t, s;
        casex ( i[31:16] )
          // w,rg2
          `zPOP :  calc = t + 4;
          `zPUSH:  calc = t - 4;
          `zLIL :  calc = {17'b0,i[15:0]};
          `zNEG :  calc = ~{t[31],t} + 1;
          `zNOT :  calc = ~t;
          `zSLL :  calc = t <<  i[12:8]; // 5bitにマスク
          `zSRL :  calc = t >>  i[12:8]; // 同上
          `zSRA :  calc = {{32{t[31]}},t} >>> i[12:8]; // 同上
          // `zJALR: まだ
          `zJR  :  calc = t;
          // s,w,rg1,rg2
          `zADDI:  calc = (i[25]) ? {1'b0,t} + {1'b0,{24{i[15]}},i[15:8]} : {1'b0,t} + {1'b0,24'b0,i[15:8]};
          `zSUBI:  calc = (i[25]) ? {1'b1,t} - {1'b0,{24{i[15]}},i[15:8]} : {1'b1,t} - {1'b0,24'b0,i[15:8]};
          `zCMPI:  calc = (i[25]) ? {1'b1,t} - {1'b0,{24{i[15]}},i[15:8]} : {1'b1,t} - {1'b0,24'b0,i[15:8]};
          `zANDI:  calc = t & {{24{i[15]}},i[15:8]};
          `zORI :  calc = t | {{24{i[15]}},i[15:8]};
          `zXORI:  calc = t ^ {{24{i[15]}},i[15:8]};
          // w,rg1,rg2
          `zADD:   calc = {1'b0,t} + {1'b0,s};
          `zSUB:   calc = {1'b1,t} - {1'b0,s};
          `zCMP:   calc = {1'b1,t} - {1'b0,s};
          `zAND:   calc = t & s;
          `zOR :   calc = t | s;
          `zXOR:   calc = t ^ s;
          `zLD :   calc = t + {{24{i[15]}},i[15:8]};
          `zST :   calc = t + {{24{i[15]}},i[15:8]};
          `zMOV:   calc = s;
          `zB  :   calc = t + {{24{i[15]}},i[15:8]};
          `zBcc:   calc = t + {{24{i[15]}},i[15:8]};
          default: calc = 33'b0;
        endcase // case ( i[31:16] )
    endfunction // case

    function stflagctl;
        input  [31:0] i;
        casex ( i[31:16] )
          // w,rg2
          `zNEG :  stflagctl = 1;
          `zSLL :  stflagctl = 1;
          `zSRL :  stflagctl = 1; 
          `zSRA :  stflagctl = 1; 
          // s,w,rg1,rg2 
          `zADDI:  stflagctl = 1;  
          `zSUBI:  stflagctl = 1;  
          `zCMPI:  stflagctl = 1;  
          `zANDI:  stflagctl = 1;  
          `zORI :  stflagctl = 1;   
          `zXORI:  stflagctl = 1;   
          // w,rg1,rg2
          `zADD:  stflagctl = 1;
          `zSUB:  stflagctl = 1;
          `zCMP:  stflagctl = 1;
          `zAND:  stflagctl = 1;
          `zOR :  stflagctl = 1;
          `zXOR:  stflagctl = 1;
          default: stflagctl = 1'b0;
        endcase // case ( i[31:16] )
    endfunction // case

    function cfctl;
        input  [31:0] i;
        input  [31:0] src;
        input  d;
        begin
            casex ( i[31:16] )
              // w,rg2
              `zNEG :  cfctl = (src==32'b0) ? 1'b0 : 1'b1;
              `zSLL :  cfctl = (inst[12:8]==0) ? 1'b0 : src[6'h20 - inst[12:8]];
              `zSRL :  cfctl = (inst[12:8]==0) ? 1'b0 : src[inst[12:8] - 5'h01]; 
              `zSRA :  cfctl = (inst[12:8]==0) ? 1'b0 : src[inst[12:8] - 5'h01]; 
              // s,w,rg1,rg2 
              `zADDI:  cfctl = d;  
              `zSUBI:  cfctl = ~d;  
              `zCMPI:  cfctl = ~d;  
              `zANDI:  cfctl = 0;  
              `zORI :  cfctl = 0;   
              `zXORI:  cfctl = 0;   
              // w,rg1,rg2
              `zADD:  cfctl = d;
              `zSUB:  cfctl = ~d;
              `zCMP:  cfctl = ~d;
              `zAND:  cfctl = 0;
              `zOR :  cfctl = 0;
              `zXOR:  cfctl = 0;
              default: cfctl = 1'b0;
            endcase // case ( i[31:16] )            
        end
    endfunction //

    function vfctl;
        input  [31:0] i;
        input  [31:0] src;
        input  d, c;
        begin
            casex ( i[31:16] )
              // w,rg2
              `zNEG :  vfctl = (src==32'h80000000) ? 1'b1 : 1'b0;
              `zSLL :  vfctl = 0; // とりあえず0
              `zSRL :  vfctl = 0; // 同上
              `zSRA :  vfctl = 0; // 同上
              // s,w,rg1,rg2 
              `zADDI:  vfctl = c;  
              `zSUBI:  vfctl = c;  
              `zCMPI:  vfctl = c;  
              `zANDI:  vfctl = c;  
              `zORI :  vfctl = c;   
              `zXORI:  vfctl = c;   
              // w,rg1,rg2
              `zADD:  vfctl = c;
              `zSUB:  vfctl = c;
              `zCMP:  vfctl = c;
              `zAND:  vfctl = c;
              `zOR :  vfctl = c;
              `zXOR:  vfctl = c;
              default: vfctl = 1'b0;
            endcase // case ( i[31:16] )            
        end
    endfunction //
    
    
endmodule // alu
