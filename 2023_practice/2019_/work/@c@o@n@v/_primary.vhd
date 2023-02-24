library verilog;
use verilog.vl_types.all;
entity CONV is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        WRITE_L0        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        READ_L0         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        WRITE_L1        : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        FINISH          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        busy            : out    vl_logic;
        ready           : in     vl_logic;
        iaddr           : out    vl_logic_vector(11 downto 0);
        idata           : in     vl_logic_vector(19 downto 0);
        cwr             : out    vl_logic;
        caddr_wr        : out    vl_logic_vector(11 downto 0);
        cdata_wr        : out    vl_logic_vector(19 downto 0);
        crd             : out    vl_logic;
        caddr_rd        : out    vl_logic_vector(11 downto 0);
        cdata_rd        : in     vl_logic_vector(19 downto 0);
        csel            : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of WRITE_L0 : constant is 1;
    attribute mti_svvh_generic_type of READ_L0 : constant is 1;
    attribute mti_svvh_generic_type of WRITE_L1 : constant is 1;
    attribute mti_svvh_generic_type of FINISH : constant is 1;
end CONV;
