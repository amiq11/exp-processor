library verilog;
use verilog.vl_types.all;
entity top_module is
    port(
        CLK             : in     vl_logic;
        N_RST           : in     vl_logic;
        SEG_OUT         : out    vl_logic_vector(63 downto 0);
        SEG_SEL         : out    vl_logic_vector(7 downto 0)
    );
end top_module;
