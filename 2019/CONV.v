
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output	reg	busy,	
	input		ready,	
			
	output	reg	iaddr,
	input		idata,	
	
	output	reg cwr,
	output	reg	caddr_wr,
	output	reg cdata_wr,
	output	reg crd,
	output	reg caddr_rd,
	input	 	cdata_rd,
	output	reg csel
	);

	reg [19:0] img [0:63];
	 

	always @(posedge clk) begin
		if(reset)begin
			busy <= 0;

		end
	end
	





endmodule




