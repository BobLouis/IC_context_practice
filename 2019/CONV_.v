
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output reg  busy,	
	input		ready,	
			
	output reg [11:0]	iaddr,
	input	[19:0]	idata,	
	
	output reg cwr,
	output reg [11:0]caddr_wr,
	output reg [19:0]cdata_wr,
	
	output reg  crd,
	output reg	[11:0]caddr_rd,
	input	[19:0] 	cdata_rd,
	
	output	reg [2:0] 	csel
	);
	// reg busy;
	//reg [11:0] iaddr;   		//read L0 data
	// reg crd;					//enable caddr rd
	// reg [11:0] caddr_rd; 		//read L1 data
	// reg cwr;					//enable cdata write
	// reg signed [19:0] cdata_wr; 
	// reg [11:0] caddr_wr;		//write L1 data
	// reg [2:0] csel;				//cell select 0=> no 1=>L0 3=>L1

	reg [3:0] current_state;   		
	reg [3:0] next_state;
	reg [3:0] counterRead;
	reg [5:0] col,row;

	reg signed [43:0] convTemp, resultTemp; //2^20 * 2^20 * 2^4 = 2^44  2^4 > 9 pixel
	wire signed [20:0] roundTemp;

	reg signed [19:0] kernelTemp;
	//reg signed [19:0] BiasTemp;

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
	always @(posedge clk or posedge reset) begin
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

	//cwr 
	always @(posedge clk or posedge reset) begin
		if(reset) cwr <= 0;
		else if(next_state == WRITE_L0) cwr <= 1;
		else if(next_state == WRITE_L1) cwr <= 1;
		else cwr <= 0 ;
	end
	//crd
	always @(posedge clk or posedge reset) begin
		if(reset) crd <= 0;
		else if(current_state == READ_L0) crd <= 1;
		else crd <= 0;
	end

	//csel
	always @(posedge clk or posedge reset) begin
		if(reset) csel <= 0;
		else if(current_state == WRITE_L1) csel <= 3'b011;
		else if(current_state == WRITE_L0) csel <= 3'b001;
		else if(current_state == READ_L0) csel <=  3'b001;
	end

	//iaddr
	always @(posedge clk or posedge reset) begin
		if(reset) iaddr <= 0;
		else if(current_state == READ_CONV)
		begin
			case (counterRead)
				4'd0: iaddr <= {row-6'd1,col-6'd1}; 
				4'd1: iaddr <= {row-6'd1,col}; 
				4'd2: iaddr <= {row-6'd1,col+6'd1}; 
				4'd3: iaddr <= {row,col-6'd1}; 
				4'd4: iaddr <= {row,col}; 
				4'd5: iaddr <= {row,col+6'd1}; 
				4'd6: iaddr <= {row+6'd1,col-6'd1}; 
				4'd7: iaddr <= {row+6'd1,col}; 
				4'd8: iaddr <= {row-6'd1,col+6'd1}; 
				default: iaddr <= 0;
			endcase
		end
	end
	//caddr_rd
	always @(posedge clk or posedge reset) begin
		if(reset) caddr_rd <= 0;
		else if(current_state == READ_L0)
		begin
			case(counterRead)
			4'd0: caddr_rd <= {row,col};
			4'd1: caddr_rd <= {row,col+6'd1};
			4'd2: caddr_rd <= {row+6'd1,col};
			4'd3: caddr_rd <= {row+6'd1,col+6'd1};
			default : caddr_rd <= 0;
			endcase
		end
	end

	always @(posedge clk or posedge reset) begin
		if(reset) caddr_wr <= 0;
		else if(next_state == WRITE_L0) caddr_wr <= {row,col};
		else if(next_state == WRITE_L1) caddr_wr <= {row[5:1],col[5:1]};//divide by 2
	end

	assign roundTemp = resultTemp[35:15]+resultTemp[15];

	//cdata_wr
	always @(posedge clk or posedge reset) begin
		if(reset) cdata_wr <= 0;
		else if(next_state == WRITE_L0)
		begin
			if(roundTemp[20]) cdata_wr <= 0; //negative Relu
			else cdata_wr <= roundTemp[20:1];
		end
		else if(current_state == READ_L0) //find the max data dugin READ_L0
		begin
			if(counterRead == 1) cdata_wr <= cdata_rd;
			else
			begin
				if(cdata_rd > cdata_wr) cdata_wr <= cdata_rd;
				else cdata_wr <= cdata_wr;
			end
		end
	end

	reg signed [19:0] idataTemp;
	wire signed [43:0] mulTemp;
	assign mulTemp = kernelTemp * idataTemp;

	//conv && bias
	always @(posedge clk or posedge reset) begin
		idataTemp <= (reset) ? 0:idata;
	end

	always @(posedge clk or posedge reset) begin
		if(reset) convTemp <= 0;
		else if(current_state == READ_CONV)
		begin
			case(counterRead)
				4'd0: convTemp <= 0;
				4'd2: if(col != 0 && row != 0) convTemp <= mulTemp;
				4'd3: if(row != 0) convTemp <= convTemp + mulTemp;
				4'd4: if(row != 0 && col != 63) convTemp <= convTemp + mulTemp;

				4'd5: if(col != 0) convTemp <= convTemp + mulTemp;
				4'd6: convTemp <= convTemp + mulTemp;
				4'd7: if(col != 63) convTemp <= convTemp + mulTemp;
				4'd8: if(row != 0 && col != 63) convTemp <= convTemp + mulTemp;
				4'd9: if(row != 63) convTemp <= convTemp + mulTemp;
				4'd10: if(row != 63 && col != 63) convTemp <= convTemp + mulTemp;
				4'd11: resultTemp <= convTemp + $signed({20'h01310,16'hd0});
			endcase
		end
	end
endmodule




