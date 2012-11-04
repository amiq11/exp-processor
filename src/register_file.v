module register_file ( ra1, ra2, wa, rd1, rd2, wd, we, clk, n_rst ) ;
    input  [ 2:0] ra1, ra2, wa;
    output [31:0] rd1, rd2;
    input  [31:0] wd;
    input  we, clk, n_rst;
    integer i;

    reg [31:0] rf [0:7];

    always @( posedge clk or negedge n_rst ) begin
        if ( !n_rst ) begin
            for ( i=0; i<8; i=i+1 ) begin
                rf[i] <= 0;
            end
        end
        else if ( we ) begin
            rf[wa] <= wd;
        end
    end
    
    assign rd1 = rf[ra1];
    assign rd2 = rf[ra2];
endmodule // resister_file


