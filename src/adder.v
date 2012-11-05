module adder ( da, db, out );
    input  [31:0] da, db;
    output [31:0] out;

    assign out = da + db;
endmodule // adder
