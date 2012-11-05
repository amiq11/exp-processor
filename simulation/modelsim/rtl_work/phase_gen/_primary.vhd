library verilog;
use verilog.vl_types.all;
entity phase_gen is
    port(
        hlt             : in     vl_logic;
        phase           : out    vl_logic_vector(4 downto 0);
        clk             : in     vl_logic;
        n_rst           : in     vl_logic
    );
end phase_gen;
