library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        \CMD\           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        WRITE           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        \DONE\          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cmd             : in     vl_logic_vector(3 downto 0);
        cmd_valid       : in     vl_logic;
        IROM_Q          : in     vl_logic_vector(7 downto 0);
        IROM_rd         : out    vl_logic;
        IROM_A          : out    vl_logic_vector(5 downto 0);
        IRAM_valid      : out    vl_logic;
        IRAM_D          : out    vl_logic_vector(7 downto 0);
        IRAM_A          : out    vl_logic_vector(5 downto 0);
        busy            : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of \CMD\ : constant is 1;
    attribute mti_svvh_generic_type of WRITE : constant is 1;
    attribute mti_svvh_generic_type of \DONE\ : constant is 1;
end LCD_CTRL;
