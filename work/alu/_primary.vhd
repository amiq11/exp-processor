library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        inst            : in     vl_logic_vector(15 downto 0);
        da              : in     vl_logic_vector(31 downto 0);
        db              : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end alu;
