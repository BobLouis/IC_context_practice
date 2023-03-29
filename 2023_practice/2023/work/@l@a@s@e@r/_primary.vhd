library verilog;
use verilog.vl_types.all;
entity LASER is
    generic(
        IDLE            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        READ            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        TRANS_READ      : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        CIR1            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        TRANS           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        CIR2            : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        TRANS2          : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        ITER            : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        \OUT\           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0)
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        X               : in     vl_logic_vector(3 downto 0);
        Y               : in     vl_logic_vector(3 downto 0);
        C1X             : out    vl_logic_vector(3 downto 0);
        C1Y             : out    vl_logic_vector(3 downto 0);
        C2X             : out    vl_logic_vector(3 downto 0);
        C2Y             : out    vl_logic_vector(3 downto 0);
        DONE            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of TRANS_READ : constant is 1;
    attribute mti_svvh_generic_type of CIR1 : constant is 1;
    attribute mti_svvh_generic_type of TRANS : constant is 1;
    attribute mti_svvh_generic_type of CIR2 : constant is 1;
    attribute mti_svvh_generic_type of TRANS2 : constant is 1;
    attribute mti_svvh_generic_type of ITER : constant is 1;
    attribute mti_svvh_generic_type of \OUT\ : constant is 1;
end LASER;
