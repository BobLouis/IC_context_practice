library verilog;
use verilog.vl_types.all;
entity triangle is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        INPUT           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CAL             : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        OUTPUT          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        DONE            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        nt              : in     vl_logic;
        xi              : in     vl_logic_vector(2 downto 0);
        yi              : in     vl_logic_vector(2 downto 0);
        busy            : out    vl_logic;
        po              : out    vl_logic;
        xo              : out    vl_logic_vector(2 downto 0);
        yo              : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of INPUT : constant is 1;
    attribute mti_svvh_generic_type of CAL : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT : constant is 1;
    attribute mti_svvh_generic_type of DONE : constant is 1;
end triangle;
