
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output reg busy,	
	input		ready,	
			
	output  reg [11:0]	iaddr,
	input 	[19:0]	idata,	
	
	output reg cwr,
	output reg [11:0]caddr_wr,
	output reg [19:0]cdata_wr,
	
	output reg  crd,
	output reg [11:0]caddr_rd,
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
	  TRANS = 4'd9,
	  FINISH = 4'd10;
	  

reg ker_sel;
reg signed [19:0]ker;
reg [5:0]row, col;
reg [4:0]cnt;
reg read_done;
reg csel_sel_flag;
reg L0_done, L1_done;

wire signed[39:0] mul;
reg  signed[43:0]ans;
assign mul = $signed(idata_reg) * ker;
reg signed[19:0]max;
wire signed[20:0] ans_out = ans[35:15] + ans[15];  
reg [19:0] idata_reg;
// assign busy = !(state == FINISH || state == IDLE);



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
            IDLE:begin
				if(busy == 1) next_state = READ_DATA;
                else next_state = IDLE;
			end
			READ_DATA:begin
				if (L0_done) next_state = TRANS;
                else if(read_done && ker_sel == 0) next_state = WRITE_L0_0;
				else if(read_done && ker_sel == 1) next_state = WRITE_L0_1;
                else next_state = READ_DATA;  
            end
            WRITE_L0_0:begin
				next_state = READ_DATA;
            end 
			WRITE_L0_1:begin
                next_state = READ_DATA;
            end 
			TRANS:begin
				next_state = READ_L0;
			end
			READ_L0:begin
				if(L1_done) next_state = FINISH;
                else if(read_done && csel_sel_flag == 0) next_state = WRITE_L1_0;
				else if(read_done && csel_sel_flag == 1) next_state = WRITE_L1_1;
				else next_state = READ_L0;
            end 
			WRITE_L1_0:begin
				next_state = FLAT;
            end 
			WRITE_L1_1:begin
                next_state = FLAT;
            end 
			FLAT:begin
				next_state = READ_L0;
            end 
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
		ker_sel <= 0;
		csel_sel_flag <= 0;
		crd <= 0;
		cwr <= 0;
		L0_done <= 0;
		L1_done <= 0;
		busy <= 0;
    end
    else begin
		if(next_state == IDLE)begin
			if(ready == 1)
				busy <= 1;
		end
		if(next_state == READ_DATA)begin
			cwr  <= 0;
			case(cnt)
				0:	iaddr <= {row-6'd1, col-6'd1};
				2:	iaddr <= {row-6'd1, col};
				4:	iaddr <= {row-6'd1, col+6'd1};
				6:	iaddr <= {row, col-6'd1};
				8:	iaddr <= {row, col};
				10:	iaddr <= {row, col+6'd1};
				12:	iaddr <= {row+6'd1, col-6'd1};
				14:	iaddr <= {row+6'd1, col};
				16:  iaddr <= {row+6'd1, col+6'd1};
			endcase
			idata_reg <= idata;
			if(cnt < 20)
				cnt <= cnt + 1;
			else begin
				read_done <= 1;
				cnt <= 0;
			end
		end
		else if(next_state == WRITE_L0_0)begin
			read_done <= 0;
			csel <= 3'b001;
			cwr  <= 1;
			cdata_wr <= (ans_out[20]) ? 0 : ans_out[20:1];
			caddr_wr <= {row,col};
			ker_sel <= 1;
		end
		else if(next_state == WRITE_L0_1)begin
			read_done <= 0;
			csel <= 3'b010;
			cwr  <= 1;
			cdata_wr <= (ans_out[20]) ? 0 : ans_out[20:1];
			caddr_wr <= {row,col};
			
			
			if(col < 63)
				col <= col + 1;
			else begin
				col <= 0;
				row <= row + 1;
				cnt <= 0;
			end
			ker_sel <= 0;

			if(col == 63 && row == 63)begin
				L0_done <= 1;
			end
		end
		else if(next_state == TRANS)begin
			cnt <= 0;
		end
		else if(next_state == READ_L0)begin	//MAX_POOLING
			csel <= (csel_sel_flag) ? 3'b010 : 3'b001;
			crd <= 1;
			cwr <= 0;
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
			end
			else begin
				read_done <= 1;
				
			end
		end
		else if(next_state == WRITE_L1_0)begin
			csel <= 3'b011;
			cwr <= 1;
			caddr_wr <= {row[5:1], col[5:1]};
			cdata_wr <= max;
			read_done <= 0;
		end
		else if(next_state == WRITE_L1_1)begin
			csel <= 3'b100;
			cwr <= 1;
			caddr_wr <= {row[5:1], col[5:1]};
			cdata_wr <= max;
			read_done <= 0;
		end
		else if(next_state == FLAT)begin
			cwr <= 1;
			if(csel_sel_flag == 0)begin
				caddr_wr <= {row[5:1], col[5:1],1'b0};
				csel_sel_flag <= 1;
			end
			else begin
				caddr_wr <= {row[5:1], col[5:1],1'b1};
				csel_sel_flag <= 0;
			end
			csel <= 3'b101;

			if(csel == 3'b100)begin
				if(col < 62)
					col <= col + 2;
				else begin
					col <= 0;
					row <= row + 2;
				end
				if(col == 62 && row == 62)
					L1_done <= 1;
			end
			
			cnt <= 0;
		end
		else if(next_state == FINISH)
			busy <= 0;
    end
end


always@(*)begin
	if(ker_sel == 0)begin
		case(cnt)
			0:	ker = 20'h0A89E;
			1:	ker = 20'h0A89E;
			2:	ker = 20'h0A89E;
			3:	ker = 20'h0A89E;
			4:	ker = 20'h092D5;
			5:	ker = 20'h092D5;
			6:	ker = 20'h06D43;
			7:  ker = 20'h06D43;
			8:	ker = 20'h01004;
			9:	ker = 20'h01004;
			10:	ker = 20'hF8F71;
			11:	ker = 20'hF8F71;
			12:	ker = 20'hF6E54;
			13:	ker = 20'hF6E54;
			14:	ker = 20'hFA6D7;
			15:	ker = 20'hFA6D7;
			16:	ker = 20'hFC834;
			17:	ker = 20'hFC834;
			18:	ker = 20'hFAC19;
			19:	ker = 20'hFAC19;
			default:ker = 0;
		endcase
	end
	else begin
		case(cnt)
			0:	ker = 20'hFDB55;
			1:	ker = 20'hFDB55;
			2:	ker = 20'hFDB55;
			3:	ker = 20'hFDB55;
			4:	ker = 20'h02992;
			5:	ker = 20'h02992;
			6:	ker = 20'hFC994;
			7:	ker = 20'hFC994;
			8:	ker = 20'h050FD;
			9:	ker = 20'h050FD;
			10:	ker = 20'h02F20;
			11:	ker = 20'h02F20;
			12:	ker = 20'h0202D;
			13:	ker = 20'h0202D;
			14:	ker = 20'h03BD7;
			15:	ker = 20'h03BD7;
			16:	ker = 20'hFD369;
			17:	ker = 20'hFD369;
			18:	ker = 20'h05E68;
			19:	ker = 20'h05E68;
			default:ker = 0;
		endcase
	end
end

always @(posedge clk or posedge reset) begin
	if(reset)	ans <= 0;
	else begin
		case (cnt)
			0 :begin ans <= 0; end
			2 :begin if(row != 0 && col != 0)  ans <= mul;       end
			4 :begin if(row != 0 )             ans <= mul + ans; end
			6 :begin if(row != 0 && col != 63) ans <= mul + ans; end
			8 :begin if(col != 0) ans <= mul + ans;              end       
			10 :begin ans <= mul + ans;                           end             
			12 :begin if(col != 63 ) ans <= mul + ans;            end
			14 :begin if(col != 0 && row != 63) ans <= mul + ans; end
			16 :begin if(row != 63 ) ans <= mul + ans;             end
			18 :begin if(col != 63 && row != 63) ans <= mul + ans; end
			20:begin ans <= (ker_sel == 0) ? (ans + {$signed(20'h01310),16'd0}) : (ans + {$signed(20'hF7295),16'd0});  end
		endcase   
	end 
end

endmodule




