module TPA(clk, reset_n, 
	   SCL, SDA, 
	   cfg_req, cfg_rdy, cfg_cmd, cfg_addr, cfg_wdata, cfg_rdata);
input 		clk; 
input 		reset_n;
// Two-Wire Protocol slave interface 
input 		SCL;  
inout		SDA;

// Register Protocal Master interface 
input		cfg_req;
output	reg	cfg_rdy;
input		cfg_cmd;
input	[7:0]	cfg_addr;
input	[15:0]	cfg_wdata;
output	reg [15:0]  cfg_rdata;

reg	[15:0] Register_Spaces	[0:255];

// ===== Coding your RTL below here ================================= 

reg [2:0]state, next_state; //rim

parameter IDLE = 3'd0,
	  WRITE_DATA = 3'd1,
	  READ_DATA = 3'd2;

reg [2:0]cnt;
reg [3:0]ptr;

reg [2:0]state_, next_state_; //twp

parameter IDLE_ = 3'd0,
	  CHOOSE_ = 3'd1,
	  WRITE_DATA_ = 3'd2,
	  READ_DATA_ = 3'd3;

reg [4:0]TWP_cnt;
reg [7:0]TWP_addr;
reg [15:0]TWP_data;

wire addr_same;
reg enable;
reg rdata;
assign SDA = (enable) ? rdata:1'bz ;
assign addr_same = (TWP_addr == cfg_addr);


always@(posedge clk or posedge reset_n)begin
    if(!reset_n)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(!reset_n)
        next_state = IDLE;
    else begin
        case(state)
            IDLE:begin
            	if(cfg_req == 1 && cfg_cmd == 1) next_state = WRITE_DATA;
				else if(cfg_req == 1 && cfg_cmd == 0) next_state = READ_DATA;
				else next_state = IDLE;
			end
			WRITE_DATA:begin
				if(cfg_rdy == 0) next_state = IDLE;
				else next_state = WRITE_DATA;
			end
			READ_DATA:begin
				if(cfg_rdy == 0) next_state = IDLE;
				else next_state = READ_DATA;
			end
            default:    next_state = IDLE;
        endcase
    end 
end


//RIM
always@(posedge clk or posedge reset_n)begin
    if(!reset_n)begin
		cfg_rdy <= 0;
		cnt <= 0;
    end
    else begin
		if(next_state == IDLE) begin
			cnt <= 0;
		end
		else if(next_state == WRITE_DATA)begin
			case(cnt)
				0:	cfg_rdy <= 1;
				1:begin
					Register_Spaces[cfg_addr] <= cfg_wdata;
					// cfg_rdy <= 0;
				end
				2:begin
					cfg_rdy <= 0;
				end
			endcase

			if(cnt < 2)
				cnt <= cnt + 1;
			else	
				cnt <= 0;	
		end
		else if(next_state == READ_DATA)begin
			case(cnt)
				0:	cfg_rdy <= 1;
				1:begin
					cfg_rdata <= Register_Spaces[cfg_addr];
					
				end
				2:begin
					cfg_rdy <= 0;
				end
			endcase	

			if(cnt < 2)
				cnt <= cnt + 1;
			else	
				cnt <= 0;
		end
    end
end





//TWP
always@(posedge SCL or posedge reset_n)begin
    if(!reset_n)
        state_ <= IDLE_;
    else 
        state_ <= next_state_;
end

always@(*)begin
    if(!reset_n)
        next_state_ = IDLE_;
    else begin
        case(state_)
            IDLE_:begin
            	if(SDA == 0) next_state_ = CHOOSE_;
				else next_state_ = IDLE;
			end
			CHOOSE_:begin
				if(SDA == 1) next_state_ = WRITE_DATA_;
				else next_state_ = READ_DATA_;
			end
			WRITE_DATA_:begin
				if(SDA == 1 && TWP_cnt == 26) next_state_ = IDLE_;
				else next_state_ = WRITE_DATA_;
			end
			READ_DATA_:begin
				if( TWP_cnt == 28) next_state_ = IDLE_;
				else next_state_ = READ_DATA_;
			end
            default:    next_state_ = IDLE_;
        endcase
    end 
end


always@(posedge SCL or posedge reset_n)begin
	if(!reset_n)begin
		TWP_cnt <= 0;
		ptr <= 0;
    end
    else begin
		if(next_state_ == IDLE_)begin
			TWP_cnt <= 0;
			enable <= 0;
		end
		else if(next_state_ == WRITE_DATA_)begin
			if(TWP_cnt > 0 && TWP_cnt <= 8)begin
				TWP_addr[TWP_cnt-1] <= SDA;
				TWP_cnt <= TWP_cnt + 1;
			end
			else if(TWP_cnt >= 9 && TWP_cnt <= 24)begin
				TWP_data[TWP_cnt-9] <= SDA;
				TWP_cnt <= TWP_cnt + 1;
			end
			else if(TWP_cnt == 25)begin
				if(addr_same == 0)begin
					Register_Spaces[TWP_addr] <= TWP_data;
				end
				TWP_cnt <= TWP_cnt + 1;
			end
			else begin
				TWP_cnt <= TWP_cnt + 1;
			end
		end
		else if(next_state_ == READ_DATA_)begin
			if(TWP_cnt > 0 && TWP_cnt <= 8)begin
				TWP_addr[TWP_cnt-1] <= SDA;
				TWP_cnt <= TWP_cnt + 1;
			end
			else if(TWP_cnt == 9)begin
				enable <= 1;
				TWP_cnt <= TWP_cnt + 1;

			end
			else if(TWP_cnt == 10)begin
				TWP_cnt <= TWP_cnt + 1;
				rdata <= 1;
				ptr<=0;
			end
			else if(TWP_cnt == 11)begin
				TWP_cnt <= TWP_cnt + 1;
				rdata <= 0;
			end	
			else if(TWP_cnt >= 12 && TWP_cnt < 28)begin
				TWP_cnt <= TWP_cnt + 1;
				rdata <= Register_Spaces[TWP_addr][ptr];
				ptr <= ptr + 1;
			end
			else if(TWP_cnt == 28)
			begin
				enable <= 0;
			end
			else begin
				TWP_cnt <= TWP_cnt + 1;
			end
		end
    end
end


endmodule
