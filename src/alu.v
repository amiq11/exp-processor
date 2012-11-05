`define ADD 8'b0000_0001
`define SUB 8'b0010_1001
`define AND 8'b0010_0001
`define OR  8'b0000_1001
`define XOR 8'b0011_0001

module alu ( inst, da, db, out );
    input  [15:0] inst;
    input  [31:0] da, db;
    output [31:0] out;

    assign out = calc( inst, da, db );
    
    function [31:0] calc;
        input  [15:0] i;
        input  [31:0] a, b;
        case ( i )
          `ADD: calc = a + b;
          `SUB: calc = a - b;
          `AND: calc = a & b;
          `OR : calc = a | b;
          `XOR: calc = a ^ b;
        endcase // case ( i )
    endfunction 
    
endmodule // alu
