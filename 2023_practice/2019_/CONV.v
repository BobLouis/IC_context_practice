
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output   busy,	
	input		ready,	
			
	output reg [11:0]	iaddr,
	input 	[19:0]	idata,	
	
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
	reg flag;
	reg flag2;
	reg signed [19:0] kernel;
	reg signed [19:0] max;

	wire signed [39:0] mul_tmp;

	assign mul_tmp = $signed(idata) * kernel;
	assign busy = !(state == FINISH || state == IDLE);


	wire signed [20:0]round_tmp;
	assign round_tmp = conv_sum[35:15] + conv_sum[15];
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
					if(ready == 1) next_state =READ;
					else next_state = IDLE;
				READ:begin
					if(flag == 1) next_state = READ_L0;
					else if(cnt == 11) next_state = WRITE_L0;
					else next_state = READ;  
				end
				WRITE_L0:begin
					next_state = READ;
				end 
				READ_L0:
					if(flag2 == 1) next_state = FINISH;
					else if(cnt == 5) next_state = WRITE_L1;
					else next_state = READ_L0; 
				WRITE_L1:
					next_state = READ_L0;
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
			
			csel <= 0;
			crd <= 0;
			cwr <= 0;
			flag <= 0;
			flag2 <= 0;
		end
		else begin
			if(next_state == READ)begin
				cwr <= 0;
				case(cnt)
					0:begin
						iaddr <= {row-6'd1, col-6'd1};
					end
					1:begin
						iaddr <= {row-6'd1, col};
						
					end
					2:begin
						iaddr <= {row-6'd1, col+6'd1};

					end
					3:begin
						iaddr <= {row, col-6'd1};

					end
					4:begin
						iaddr <= {row, col};

					end
					5:begin
						iaddr <= {row, col+6'd1};

					end
					6:begin
						iaddr <= {row+6'd1, col-6'd1};

					end
					7:begin
						iaddr <= {row+6'd1, col};

					end
					8:begin
						iaddr <= {row+6'd1, col+6'd1};

					end

				endcase


				if(cnt < 11 && flag == 0)
					cnt <= cnt + 1;
				else
					cnt <= 0;
			end
			else if(next_state == WRITE_L0)begin
				cwr <= 1;
				crd <= 0;
				csel <= 3'b001;
				cdata_wr <= (round_tmp[20])?0:round_tmp[20:1];
				caddr_wr <= {row, col};
				cnt <= 0;
				if(col == 63)begin
					col <= 0;
					row <= row + 1;
				end
				else 
					col <= col + 1;

				if(row == 63 && col == 63)
					flag <= 1;
			end
			else if(next_state == READ_L0)begin
				crd <= 1;
				cwr <= 0;
				csel <= 3'b001;
				case(cnt)
					0:begin
						caddr_rd <= {row, col};
					end
					1:begin
						caddr_rd <= {row, col+6'd1};
						max <= cdata_rd;
					end
					2:begin
						caddr_rd <= {row+6'd1, col};
						max <= (cdata_rd > max) ? cdata_rd : max;
					end
					3:begin
						caddr_rd <= {row+6'd1, col+6'd1};
						max <= (cdata_rd > max) ? cdata_rd : max;
					end
					4:begin
						max <= (cdata_rd > max) ? cdata_rd : max;
					end
				endcase

				if(cnt < 5)
					cnt <= cnt + 1;
				else 
					cnt <= 0;
			end
			else if(next_state == WRITE_L1)begin
				csel <= 3'b011;
				cwr <= 1;
				crd <= 0;
				caddr_wr <= {row[5:1], col[5:1]};
				cdata_wr <= max;

				if(col == 62)begin
					row <= row + 2;
					col <= 0;
				end
				else 
					col <= col + 2;

				if(row == 62 && col == 62)
					flag2 <= 1;
			end
		end
	end
	

	

	always @(posedge clk) begin
		case (cnt)
			0: conv_sum <= 0;
			1: if(col !=0 && row !=0)conv_sum <= mul_tmp;
			2: if(row !=0)conv_sum <= mul_tmp + conv_sum;
			3: if(col != 63 && row !=0)conv_sum <= mul_tmp + conv_sum;
			4: if(col !=0)conv_sum <= mul_tmp + conv_sum;
			5: conv_sum <= mul_tmp + conv_sum;
			6: if(col !=63)conv_sum <= mul_tmp + conv_sum;
			7: if(col != 0 && row !=63)conv_sum <= mul_tmp + conv_sum;
			8: if(row != 63)conv_sum <= mul_tmp + conv_sum;
			9: if(col != 63 && row != 63)conv_sum <= mul_tmp + conv_sum;
			10: conv_sum <= conv_sum + $signed(40'h013100000);
		endcase
	end

	always @(*) begin
		case (cnt)
			1: kernel = 20'h0A89E; 
			2: kernel = 20'h092D5; 
			3: kernel = 20'h06D43; 
			4: kernel = 20'h01004; 
			5: kernel = 20'hF8F71; 
			6: kernel = 20'hF6E54; 
			7: kernel = 20'hFA6D7; 
			8: kernel = 20'hFC834; 
			9: kernel = 20'hFAC19; 
			default: kernel = 0;
		endcase
	end
endmodule




