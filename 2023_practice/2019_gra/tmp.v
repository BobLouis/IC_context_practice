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
	output reg	[11:0]caddr_rd,
	input	[19:0] 	cdata_rd,
	
	output	reg [2:0] 	csel
	);

reg [3:0]state, next_state;
parameter IDLE = 4'd0,
	  READ_DATA = 4'd1,
	  WRITE_L0_0 = 4'd2,
	  WRITE_L0_1 = 4'd3,
	  READ_L0_0 = 4'd4,
	  READ_L0_1 = 4'd5,
	  WRITE_L1_0 = 4'd6,
	  WRITE_L1_1 = 4'd7,
	  FLAT = 4'd8,
	  FINISH = 4'd9;
	  

reg ker_sel;
reg signed [19:0]ker;
reg [5:0]row, col;
reg [19:0]idata_reg;

wire signed[39:0] mul;
reg  signed[43:0]ans;
assign mul = idata_reg * ker;




//new
wire [20:0] ans_out = ans[35:15] + ans[15];                                                              
//new

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
                next_state = READ_L0_0;
            READ_L0_0:begin
                if() next_state = CAL;
                else next_state = READ_L0_0;  
            end
            CAL:begin
                if() next_state = OUT;
                else next_state = CAL;
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
		ker_sel <= 0;
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



			
		end
		else if(next_state == WRITE_L0_0)begin
			csel <= 1;
			cwr  <= 1;
			cdata_wr <= ans_out[20:1];
			caddr_wr <= {row,col};


		end
		else if(next_state == WRITE_L0_1)begin
			csel <= 1;
			cwr  <= 1;
			cdata_wr <= ans_out[20:1];
			caddr_wr <= {row,col};
		end
		else if(next_state == READ_L0_0)begin
			
		end
		else if(next_state == READ_L0_1)begin

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
			0 :begin ans <= 0; end
			1 :begin if(row != 0 && col != 0)  ans <= mul;       end
			2 :begin if(row != 0 )             ans <= mul + ans; end
			3 :begin if(row != 0 && col != 63) ans <= mul + ans; end
			4 :begin if(col != 0) ans <= mul + ans;              end       
			5 :begin ans <= mul + ans;                           end             
			6 :begin if(col != 63 ) ans <= mul + ans;            end
			7 :begin if(col != 0 && row != 63) ans <= mul + ans; end
			8 :begin if(col != 0 ) ans <= mul + ans;             end
			9 :begin if(col != 63 && row != 63) ans <= mul + ans;end
			10:begin ans <= (ker_sel == 0) ? ans + $signed{20'h01310} : ans + $signed{20'hF7295}  end
		endcase   
	end 
end

endmodule