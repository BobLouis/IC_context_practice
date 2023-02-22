library verilog;
use verilog.vl_types.all;
entity DT is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ_ROM        : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        READ_RAM        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        WRITE_RAM       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        CHANGE_DIR      : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        FINISH          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        done            : out    vl_logic;
        sti_rd          : out    vl_logic;
        sti_addr        : out    vl_logic_vector(9 downto 0);
        sti_di          : in     vl_logic_vector(15 downto 0);
        res_wr          : out    vl_logic;
        res_rd          : out    vl_logic;
        res_addr        : out    vl_logic_vector(13 downto 0);
        res_do          : out    vl_logic_vector(7 downto 0);
        res_di          : in     vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ_ROM : constant is 1;
    attribute mti_svvh_generic_type of READ_RAM : constant is 1;
    attribute mti_svvh_generic_type of WRITE_RAM : constant is 1;
    attribute mti_svvh_generic_type of CHANGE_DIR : constant is 1;
    attribute mti_svvh_generic_type of FINISH : constant is 1;
end DT;
