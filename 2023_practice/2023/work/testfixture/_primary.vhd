library verilog;
use verilog.vl_types.all;
entity testfixture is
    generic(
        pat_number      : integer := 6;
        ST_RESET        : integer := 0;
        ST_PATTERN      : integer := 1;
        ST_RUN          : integer := 2;
        ST_RETURN       : integer := 3
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of pat_number : constant is 1;
    attribute mti_svvh_generic_type of ST_RESET : constant is 1;
    attribute mti_svvh_generic_type of ST_PATTERN : constant is 1;
    attribute mti_svvh_generic_type of ST_RUN : constant is 1;
    attribute mti_svvh_generic_type of ST_RETURN : constant is 1;
end testfixture;
