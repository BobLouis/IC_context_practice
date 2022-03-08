
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output		busy,	
	input		ready,	
			
	output		iaddr,
	input		idata,	
	
	output	 	cwr,
	output	 	caddr_wr,
	output	 	cdata_wr,
	
	output	 	crd,
	output	 	caddr_rd,
	input	 	cdata_rd,
	
	output	 	csel
	);
	reg busy;
	reg [11:0] iaddr;   		//read L0 data
	reg crd;					//enable caddr rd
	reg [11:0] caddr_rd; 		//read L1 data
	reg cwr;					//enable cdata write
	reg signed [19:0] cdata_wr; 
	reg [11:0] caddr_wr;		//write L1 data
	reg [2:0] csel;				//cell select 0=> no 1=>L0 3=>L1

	reg [3:0] current_state;   		
	reg [3:0] next_state;
	reg [3:0] counter_rd;
	reg [5:0] col,row;

	reg signed [43:0] convTemp, resultTemp; //2^20 * 2^20 * 2^4 = 2^44  2^4 > 9 pixel
	reg signed [20:0]roundTemp;

	reg signed [19:0] kernelTemp;
	reg signed [19:0] BiasTemp;

	parameter IDLE = 4'd0;
	parameter READ_CONV = 4'd1;
	parameter WRITE_L0 = 4'd2;
	parameter READ_L0 = 4'd3;
	parameter WRITE_L1 = 4'd4;
	parameter FINISH = 4'd5;

	always @(*) begin
		case(counterRead)
        4'd2: kernelTemp = 20'h0A89E;
        4'd3: kernelTemp = 20'h092D5;
        4'd4: kernelTemp = 20'h06D43;
        4'd5: kernelTemp = 20'h01004;
        4'd6: kernelTemp = 20'hF8F71;
        4'd7: kernelTemp = 20'hF6E54;
        4'd8: kernelTemp = 20'hFA6D7;
        4'd9: kernelTemp = 20'hFC834;
        4'd10: kernelTemp = 20'hFAC19;
        default: kernelTemp = 20'd0;
        endcase
	end


endmodule




