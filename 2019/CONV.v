
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
	reg [3:0] counterRead;
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


	//col row
	always @(posedge clk or posedge reset) begin
		if(reset) {row,col} <= 12'd0;
		else if(current_state == WRITE_L0)begin
			if(col == 6'd63)begin
				col <= 6'd0;
				row <= row + 1;
			end
			else col <= + 6'd1;
		end
		else if(current_state == WRITE_L1)begin
			if(col == 62) begin
				col <= 0;
				row <= row + 2;
			end
			else col <= col + 6'd2;
		end
	end

	//state 
	always @(posedge clk or posedge reset) begin
		if(reset) current_state <= IDLE;
		else current_state <= next_state;
	end

	always @(*) begin
		case(current_state)
			IDLE:
				begin
					if(ready == 1) next_state = READ_CONV;
					else next_state = IDLE;
				end
			READ_CONV:
				begin
					if(counterRead == 12) next_state = WRITE_L0;
					else next_state = READ_CONV;
				end
			WRITE_L0:
				begin
					if(col == 63 && row == 63) next_state = READ_L0;
					else next_state = READ_CONV;
				end
			READ_L0:
				begin
					if(counterRead == 5) next_state = WRITE_L1;
					else next_state = READ_L0;
				end
			WRITE_L1:
				begin
					if(col == 62 && row == 62) next_state = FINISH;
					else next_state = READ_L0; 
				end
			FINISH:
				begin
					next_state = FINISH;
				end
		endcase
	end

	//counter
	always @(posedge clk posedge reset) begin
		if(reset) counterRead <= 4'd0;
		else if(counterRead == 4'd13) counterRead <= 0;
		else if(counterRead == 5 && (current_state == READ_L0)) counterRead <= 0;
		else if(current_state == READ_CONV || current_state == READ_L0) counterRead <= counterRead + 1;
	end

	//Busy
	always @(posedge clk or posedge reset) begin
		if(reset) busy <= 0;
		else if(ready == 1) busy <= 1;
		else if(current_state == FINISH) busy <= 0;
	end
endmodule




