library verilog;
use verilog.vl_types.all;
entity FC is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ_CMD        : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        READ_F          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        READ_M          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cmd             : in     vl_logic_vector(32 downto 0);
        done            : out    vl_logic;
        M_RW            : out    vl_logic;
        M_A             : out    vl_logic_vector(6 downto 0);
        M_D             : inout  vl_logic_vector(7 downto 0);
        F_IO            : inout  vl_logic_vector(7 downto 0);
        F_CLE           : out    vl_logic;
        F_ALE           : out    vl_logic;
        F_REN           : out    vl_logic;
        F_WEN           : out    vl_logic;
        F_RB            : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ_CMD : constant is 1;
    attribute mti_svvh_generic_type of READ_F : constant is 1;
    attribute mti_svvh_generic_type of READ_M : constant is 1;
end FC;
