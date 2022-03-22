
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
output  reg[13:0] 	gray_addr;
output  reg      	gray_req;
input   	gray_ready;
input   [7:0] 	gray_data;
output  [13:0] 	lbp_addr;
output  reg	lbp_valid;
output  reg[7:0] 	lbp_data;
output  reg	finish;


//====================================================================

    reg [2:0]state, next_state;
    reg [13:0] pc;
    reg [3:0] counterRead;
    reg [6:0]col,row;
    reg buff[0:7];
    reg [7:0]mid;

    parameter IDLE = 4'd0;
	parameter READ = 4'd1;
	parameter WRITE = 4'd2;
	parameter FINISH = 4'd5;


    always @(posedge clk or posedge reset) begin
		if(reset) state <= IDLE;
		else state <= next_state;
	end

    always @(*) begin
        if(reset) next_state = IDLE;
        else begin
            case(state)
                IDLE:
                    begin
                        if(gray_ready == 1) next_state = READ;
                        else next_state = IDLE;
                    end
                READ:
                    begin
                        if(counterRead == 9) next_state = WRITE;
                        else next_state = READ;
                    end
                WRITE:
                    begin
                        if(col == 126 && row == 126) next_state = FINISH;
                        else next_state = READ;
                    end
                FINISH:
                    begin
                        next_state = FINISH;
                    end
                default: 
                    begin
                        next_state = IDLE;
                    end
            endcase
        end
	end

    //row col
    always @(posedge clk or posedge reset) begin
        if(reset) {row, col} = 129;
        else if(state == WRITE)begin
            //go up one
            if(col == 126)begin
                col <= 127;
                row <= row + 1;
            end
            else col <= col + 1;
        end
    end

    //gray_addr


    always@(posedge clk or posedge reset)begin
        if(reset)begin
            gray_addr <= 0;
            counterRead <= 0;
        end
        else if(state == READ)begin
            case(counterRead)
                4'd1: gray_addr <= {row,col}; 
				4'd2: gray_addr <= {row-7'd1,col-7'd1}; 
				4'd3: gray_addr <= {row-7'd1,col}; 
				4'd4: gray_addr <= {row-7'd1,col+7'd1}; 
				4'd5: gray_addr <= {row,col-7'd1}; 
				4'd6: gray_addr <= {row,col+7'd1}; 
				4'd7: gray_addr <= {row+7'd1,col-7'd1}; 
				4'd8: gray_addr <= {row+7'd1,col}; 
				4'd9: gray_addr <= {row+7'd1,col+7'd1}; 
                default: gray_addr <= 0;
            endcase
            counterRead <= counterRead + 4'd1;
            if(counterRead == 4'd9)
                counterRead <= 0;
        end
    end
    always@(posedge clk)begin
        if(counterRead == 1)begin
            mid <= gray_data;
        end 
        else if(counterRead > 1 && counterRead < 10)begin
            buff[counterRead-2] = (gray_data < mid) ? 0 : 1;
        end
    end
    //gray_req
    always @(posedge clk or posedge reset) begin
        if(reset) gray_req <=0;
        else begin
            if(state == READ)begin
                gray_req <= 1;
            end
            else begin
                gray_req <= 0;
            end
        end
    end
    //lbp_addr;
    assign lbp_addr = {row,col};
    //lbp_valid;
    always @(*) begin
        if(state == WRITE)begin
            lbp_valid = 1'b1;
        end
        else begin
            lbp_valid = 1'b0;
        end
    end

    //lbp_data;
    always @(*) begin
        if(state == WRITE)
        begin
            lbp_data = ((buff[0] + (buff[1] << 1)) + ((buff[2] << 2) + (buff[3] << 3))) + (((buff[4] << 4) + (buff[5] <<5)) + ((buff[6] << 6) + (buff[7] << 7)));
        end
        else lbp_data = 0;
    end

    //finish
    always @(*) begin
        if(state == FINISH)begin
            finish = 1'b1;
        end
        else begin
            finish = 1'b0;
        end
    end

//====================================================================
endmodule
