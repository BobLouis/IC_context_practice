`timescale 1ns/10ps

module CODEC (DATA, CODE, RESET, ENCODE_, CLK);

input CLK, ENCODE_, RESET; 
inout [15:0] DATA;
inout [3:0]  CODE;

endmodule 
