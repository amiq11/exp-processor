library verilog;
use verilog.vl_types.all;
entity register_file is
    port(
        ra1             : in     vl_logic_vector(2 downto 0);
        ra2             : in     vl_logic_vector(2 downto 0);
        wa              : in     vl_logic_vector(2 downto 0);
        rd1             : out    vl_logic_vector(31 downto 0);
        rd2             : out    vl_logic_vector(31 downto 0);
        wd              : in     vl_logic_vector(31 downto 0);
        we              : in     vl_logic;
        clk             : in     vl_logic;
        n_rst           : in     vl_logic;
        rf0             : out    vl_logic_vector(31 downto 0);
        rf1             : out    vl_logic_vector(31 downto 0);
        rf2             : out    vl_logic_vector(31 downto 0);
        rf3             : out    vl_logic_vector(31 downto 0);
        rf4             : out    vl_logic_vector(31 downto 0);
        rf5             : out    vl_logic_vector(31 downto 0);
        rf6             : out    vl_logic_vector(31 downto 0);
        rf7             : out    vl_logic_vector(31 downto 0)
    );
end register_file;
