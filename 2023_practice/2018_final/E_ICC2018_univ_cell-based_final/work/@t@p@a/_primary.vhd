library verilog;
use verilog.vl_types.all;
entity TPA is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        WRITE_DATA      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        READ_DATA       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        \IDLE_\         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        \CHOOSE_\       : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        \WRITE_DATA_\   : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        \READ_DATA_\    : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        SCL             : in     vl_logic;
        SDA             : inout  vl_logic;
        cfg_req         : in     vl_logic;
        cfg_rdy         : out    vl_logic;
        cfg_cmd         : in     vl_logic;
        cfg_addr        : in     vl_logic_vector(7 downto 0);
        cfg_wdata       : in     vl_logic_vector(15 downto 0);
        cfg_rdata       : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of WRITE_DATA : constant is 1;
    attribute mti_svvh_generic_type of READ_DATA : constant is 1;
    attribute mti_svvh_generic_type of \IDLE_\ : constant is 1;
    attribute mti_svvh_generic_type of \CHOOSE_\ : constant is 1;
    attribute mti_svvh_generic_type of \WRITE_DATA_\ : constant is 1;
    attribute mti_svvh_generic_type of \READ_DATA_\ : constant is 1;
end TPA;
