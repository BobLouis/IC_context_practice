library verilog;
use verilog.vl_types.all;
entity FFT_PE is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        power           : in     vl_logic_vector(2 downto 0);
        ab_valid        : in     vl_logic;
        fft_a           : out    vl_logic_vector(31 downto 0);
        fft_b           : out    vl_logic_vector(31 downto 0);
        fft_pe_valid    : out    vl_logic
    );
end FFT_PE;
