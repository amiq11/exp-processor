`define ADD 3'b000
`define SUB 3'b101
`define CMP 3'b111
`define AND 3'b100
`define OR  3'b001
`define XOR 3'b110

module alu ( inst, da, db, out );
    input  [2:0] inst;
    input  [31:0] da, db;
    output [31:0] out;

    assign out = calc( inst, da, db );
    
    function [31:0] calc;
        input  [2:0] i;
        input  [31:0] a, b;
        case ( i )
          `ADD: calc = a + b;
          `SUB: calc = b - a;
          `CMP: calc = b - a;
          `AND: calc = a & b;
          `OR : calc = a | b;
          `XOR: calc = a ^ b;
        endcase // case ( i )
    endfunction 
    
endmodule // alu
