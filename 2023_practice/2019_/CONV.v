
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


	reg [2:0]state, next_state;
	parameter IDLE = 3'd0,
		READ = 3'd1,
		WRITE_L0 = 3'd2,
		READ_L0 = 3'd3,
		WRITE_L1 = 3'd4,
		FINISH = 3'd5;


	reg signed [43:0] conv_sum;
	reg [3:0] cnt;
	reg give_pos;
	reg [5:0] row, col;

	always@(posedge clk or posedge reset)begin
		if(reset)
			state <= IDLE;
		else 
			state <= next_state;
	end

	always@(*)begin
		if(reset)
			next_state = IDLE;
		else begin
			case(state)
				IDLE:
					next_state = READ;
				READ:begin
					if() next_state = CAL;
					else next_state = READ;  
				end
				WRITE_L0:begin
					if() next_state = OUT;
					else next_state = CAL;
				end 
				READ_L0:
					next_state = READ; 
				WRITE_L1:

				default:    next_state = IDLE;
			endcase
		end 
	end


	//DATA INPUT
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			cnt <= 0;
			give_pos <= 0;
			row <= 0;
			col <= 0;
		end
		else begin
			if(next_state == READ)begin
				case(cnt)
					0:begin
						iaddr <= {row-6'd1, col-6'd1};

					end



				endcase
		
				

				if(col < 127)begin
					col <= 0;
					row <= row + 1;
				end
				else 
					col <= col + 1;
			end
			else if(next_state == READ_L0)begin
				case(cnt)
					


				endcase

			end

		end
	end
endmodule




