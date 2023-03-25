
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output   busy,	
	input		ready,	
			
	output  reg [11:0]	iaddr,
	input 	[19:0]	idata,	
	
	output reg cwr,
	output reg [11:0]caddr_wr,
	output reg [19:0]cdata_wr,
	
	output reg  crd,
	output 	[11:0]caddr_rd,
	input	[19:0] 	cdata_rd,
	
	output	reg [2:0] 	csel
	);

reg [3:0]state, next_state;
parameter IDLE = 4'd0,
	  READ_DATA = 4'd1,
	  WRITE_L0_0 = 4'd2,
	  WRITE_L0_1 = 4'd3,
	  READ_L0 = 4'd4,
	  WRITE_L1_0 = 4'd5,
	  WRITE_L1_1 = 4'd6,
	  FLAT = 4'd7,
	  FINISH = 4'd8;
	  

reg ker_sel;
reg signed [19:0]ker;
reg [5:0]row, col;
reg [19:0]idata_reg;
reg [3:0]cnt;
reg read_done;

wire signed[39:0] mul;
reg  signed[43:0]ans;
assign mul = idata_reg * ker;
assign caddr_rd = {row, col};
reg signed[19:0]max;

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
                next_state = READ_DATA;
            READ_DATA:begin
                if(read_done == 1) next_state = WRITE_L0_0;
                else next_state = READ_DATA;  
            end
            WRITE_L0_0:begin
                if() next_state = ;
				else next_state = READ_DATA;
            end 
            OUT:
                next_state = READ; 
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
		csel <= 0;
		row <= 0;
		col <= 0;
		cnt <= 0;
		read_done <= 0;
    end
    else begin
		if(next_state == READ_DATA)begin
			case(cnt)
				0:	iaddr <= {row-6'd1, col-6'd1};
				1:	iaddr <= {row-6'd1, col};
				2:	iaddr <= {row-6'd1, col+6'd1};
				3:	iaddr <= {row, col-6'd1};
				4:	iaddr <= {row, col};
				5:	iaddr <= {row, col+6'd1};
				6:	iaddr <= {row+6'd1, col-6'd1};
				7:	iaddr <= {row+6'd1, col}
				8:  iaddr <= {row+6'd1, col+6'd1};
			endcase

			idata_reg <= idata;
			if(cnt < 9)
				cnt <= cnt + 1;
			else begin
				read_done <= 1;
				cnt <= 0;
			end
		end
		else if(next_state == WRITE_L0_0)begin
			read_done <= 0;
			csel <= 3'b001;
		end
		else if(next_state == WRITE_L0_1)begin
			read_done <= 0;
			csel <= 3'b010;
			if(col < 63)
					col <= col + 1;
			else begin
				col <= 0;
				row <= row + 1;
			end
		end
		else if(next_state == READ_L0)begin	//MAX_POOLING
			csel <= 3'b001;
			case(cnt)
				0:	caddr_rd <= {row, col};
				1:begin
					caddr_rd <= {row, col+6'd1};
					max <= cdata_rd;
				end
				2:begin
					caddr_rd <= {row+6'd1, col};
					max <= (max > cdata_rd) ? max : cdata_rd;
				end
				3:begin
					caddr_rd <= {row+6'd1, col+6'd1};
					max <= (max > cdata_rd) ? max : cdata_rd;
				end
				4:	max <= (max > cdata_rd) ? max : cdata_rd;
			endcase

			if(cnt < 4)begin
				cnt <= cnt + 1;
			else begin
				cnt <= 0;
				
			end
		end
		else if(next_state == WRITE_L1_0)begin
			
		end
		else if(next_state == WRITE_L1_1)begin
			
		end
		else if(next_state == FLAT)begin

		end
    end
end


always@(*)begin
	if(ker_sel == 0)begin
		case(cnt)
			0:	ker = 20'h0A89E;
			1:	ker = 20'h092D5;
			2:	ker = 20'h06D43;
			3:	ker = 20'h01004;
			4:	ker = 20'hF8F71;
			5:	ker = 20'hF6E54;
			6:	ker = 20'hFA6D7;
			7:	ker = 20'hFC834;
			8:	ker = 20'hFAC19
		endcase
	end
	else begin
		case(cnt)
			0:	ker = 20'hFDB55;
			1:	ker = 20'h02992;
			2:	ker = 20'hFC994;
			3:	ker = 20'h050FD;
			4:	ker = 20'h02F20;
			5:	ker = 20'h0202D;
			6:	ker = 20'h03BD7;
			7:	ker = 20'hFD369;
			8:	ker = 20'h05E68;
		endcase
	end
end

always @(posedge clk or posedge reset) begin
	if(reset)	ans <= 0;
	else begin
		case (cnt)
			0:begin ans <= 0; end
			1:begin if(row != 0 && col != 0)  ans <= mul;       end
			2:begin if(row != 0 )             ans <= mul + ans; end
			3:begin if(row != 0 && col != 63) ans <= mul + ans; end
			4:begin if(col != 0) ans <= mul + ans;              end       
			5:begin ans <= mul + ans;                           end             
			6:begin if(col != 63 ) ans <= mul + ans;            end
			7:begin if(col != 0 && row != 63) ans <= mul + ans; end
			8:begin if(col != 0 ) ans <= mul + ans;             end
			9:begin if(col != 63 && row != 63) ans <= mul + ans; end
		endcase   
	end 
end

endmodule




