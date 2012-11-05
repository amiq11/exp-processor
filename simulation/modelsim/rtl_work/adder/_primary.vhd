library verilog;
use verilog.vl_types.all;
entity adder is
    port(
        da              : in     vl_logic_vector(31 downto 0);
        db              : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end adder;
