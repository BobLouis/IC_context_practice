module DT(
	input 			clk, 
	input			reset,
	output			done ,
	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input		[15:0]	sti_di,
	output	reg		res_wr ,
	output	reg		res_rd ,
	output	 	[13:0]	res_addr ,
	output	reg 	[7:0]	res_do,
	input		[7:0]	res_di
	);

reg [2:0]state, next_state;
parameter IDLE  = 3'd0,
	  READ_ROM  = 3'd1,
	  READ_RAM  = 3'd2,
	  WRITE_RAM = 3'd3,
	  CHANGE_DIR = 3'd4,
	  FINISH = 3'd5;
reg [2:0]cnt;
reg [7:0] min;

//louis
reg [7:0] row, col;
reg cur_pix;
reg dir; //0 forward 1 backward

assign res_addr = {row, col};
assign done = (state == FINISH);
always@(posedge clk)begin
    state <= next_state;
end

always@(*)begin
    if(reset)
        next_state = READ_ROM;
    else begin
        case(state)
            IDLE:
                next_state = READ_ROM;
            READ_ROM:
			begin
                if(cur_pix == 1) next_state = READ_RAM;
                else next_state = READ_ROM;  
            end
            READ_RAM:
			begin
                if(cnt == 4) next_state = WRITE_RAM;
                else next_state = READ_RAM;
            end 
            WRITE_RAM:
			begin
				if(row == 126 && col == 126)
					next_state = CHANGE_DIR;
				else if (row == 1 && col == 1)
					next_state = FINISH;
				else
                	next_state = READ_ROM; 
			end
			CHANGE_DIR:
			begin
				next_state <= READ_ROM;
			end
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
		sti_addr <= 0;
		sti_rd <= 1;
		row <= 0;
		col <= 255;
		res_wr <= 0; 
		

		//louis
		dir <= 0;
		res_do <= 0;
    end
    else begin
		if(next_state == IDLE)begin
			sti_addr <= sti_addr + 1;

		end
		else if(next_state == READ_ROM)begin
			if(sti_di == 0)begin
				sti_addr <= sti_addr + 1;
				if(col == 127)begin
					row <= row + 1;
					col <= 0;
				end
				else
					col <= col + 16;
			end
			else begin
				if(sti_di[col] == 0)
					col <= col + 1;
				else begin
					cur_pix <= sti_di[col];
					col <= col - 129;
				end
			end
		end
		else if(next_state == READ_RAM)begin
			case(cnt)
				0:begin	
					min <= res_di;
					col <= col + 1;
				end
				1:begin
					if(min > res_di)
						min <= res_di;
					col <= col + 1;
					cnt <= cnt + 1;
				end
				2:begin
					if(min > res_di)
						min <= res_di;
					cnt <= cnt + 1;
					col <= col + 126;
				end
				3:begin
					if(min > res_di)
						min <= res_di;
					cnt <= cnt + 1;
				end
				
			endcase
		end
		else if(next_state == CHANGE_DIR)
		begin
			dir <= 1;
		end
    end
end

always @(negedge clk or posedge reset) begin
	if(reset)
	begin
		res_wr <= 0;
		res_do <= 0;
	end
	else if(next_state == WRITE_RAM)
	begin
		res_wr <= 1;
		if(dir == 0)
			res_do <= min + 1;
		else
			res_do <= min;
	end
end




endmodule