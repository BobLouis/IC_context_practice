module DT(
	input 			clk, 
	input			reset,
	output			done ,
	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input		[15:0]	sti_di,
	output	reg		res_wr ,
	output	reg		res_rd ,
	output	reg	[13:0]	res_addr ,
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
reg [6:0] row, col;
reg cur_pix;
reg dir; //0 forward 1 backward


assign done = (state == FINISH);
always@(posedge clk)begin
    state <= next_state;
end

always@(*)begin
    if(!reset)
        next_state = READ_ROM;
    else begin
        case(state)
            IDLE:
                next_state = READ_ROM;
            READ_ROM:
			begin
                if(sti_di[15-col[3:0]] == 1) next_state = READ_RAM;
				else if(row == 126 && col == 126) next_state = FINISH;
                else next_state = READ_ROM;  
            end
            READ_RAM:
			begin
                if(cnt == 5) next_state = WRITE_RAM;
                else next_state = READ_RAM;
            end 
            WRITE_RAM:
			begin
				if(row == 126 && col == 126)
					next_state = FINISH;
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
//sti_addr sti_rd
//sti_di
always@(posedge clk or negedge reset)begin
    if(!reset)begin
		sti_addr <= 8;
		sti_rd <= 0;

		res_rd <= 0;


		row <= 1;
		col <= 1;
		
		cnt <= 0;

		//louis
		dir <= 0;

    end
    else begin
		if(next_state == READ_ROM)begin
			// if(sti_di[col[3:0]] == 0) //go to next pix
			// begin
			sti_rd <= 1;
			
			if(col < 126)
				col <= col + 1;
			else
			begin
				col <= 1;
				row <= row + 1;	
				sti_addr <= sti_addr + 1;				
			end 

			if(col[3:0] == 15)
				sti_addr <= sti_addr + 1;

			// end
		end
		else if(next_state == READ_RAM)begin
			case(cnt)
				0:begin
					res_rd <= 1;
					res_addr <= {row-7'd1,col-7'd1};
				end
				1:begin	
					min <= res_di;
					res_addr <= {row-7'd1,col};
				end
				2:begin
					if(min > res_di)
						min <= res_di;
					res_addr <= {row-7'd1,col+7'd1};
				end
				3:begin
					if(min > res_di)
						min <= res_di;
					res_addr <= {row,col-7'd1};
					
				end
				4:begin
					if(min > res_di)
						min <= res_di;
					res_rd <= 0;
					res_addr <= {row,col};
				end
				
			endcase
			if(cnt < 5)
				cnt <= cnt + 1;
			else
				cnt <= 0;
		end
		else if(next_state == WRITE_RAM)
		begin
			// res_addr <= {row,col};
			
		end
		else if(next_state == CHANGE_DIR)
		begin
			dir <= 1;
		end
    end
end

always @(negedge clk or negedge reset) begin
	if(!reset)
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
	else 
	begin
		res_wr <= 0;
	end
end




endmodule