`define eax 3'b000
`define ecx 3'b001
`define edx 3'b010
`define ebx 3'b011
`define esp 3'b100
`define ebp 3'b101
`define esi 3'b110
`define edi 3'b111

module register_file ( ra1, ra2, wa, rd1, rd2, wd, we, wespd, wespen, resp, clk, n_rst, 
                       rf0, rf1, rf2, rf3, rf4, rf5, rf6, rf7 );
    input  [ 2:0] ra1, ra2, wa;
    output [31:0] rd1, rd2, resp,
                  rf0, rf1, rf2, rf3, rf4, rf5, rf6, rf7;
    input  [31:0] wd, wespd;
    input  we, wespen, clk, n_rst;
    integer i;

    reg [31:0] rf [0:7];


    always @( posedge clk or negedge n_rst ) begin
        if ( !n_rst ) begin
            for ( i=0; i<8; i=i+1 ) begin
                rf[i] <= 1;
            end
        end
        else begin
            if ( we ) begin
                rf[wa] <= wd;
            end
            if ( wespen ) begin
                rf[`esp] <= wespd;
            end
        end
    end
    
    assign rd1 = rf[ra1];
    assign rd2 = rf[ra2];
    assign resp = rf[`esp];

    assign rf0 = rf[0];
    assign rf1 = rf[1];
    assign rf2 = rf[2];
    assign rf3 = rf[3];
    assign rf4 = rf[4];
    assign rf5 = rf[5];
    assign rf6 = rf[6];
    assign rf7 = rf[7];
endmodule // resister_file


