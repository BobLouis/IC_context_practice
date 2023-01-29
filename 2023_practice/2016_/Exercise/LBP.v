`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
output  reg[13:0] 	gray_addr;
output  reg       	gray_req;
input   	gray_ready;
input   [7:0] 	gray_data;
output  reg [13:0] 	lbp_addr;
output 	reg lbp_valid;
output  reg[7:0] 	lbp_data;
output  	finish;


//====================================================================
reg [1:0] state, next_state;
parameter IDLE =   2'd0; 
parameter READ =   2'd1; 
parameter WRITE =  2'd2; 
parameter FINISH = 2'd3; 

reg [6:0] col;
reg [6:0] row;

reg [3:0]cnt_read;
reg [7:0] mid;
reg [7:0] buff[0:8];

// assign lbp_addr = {row,col};
assign finish = (state == FINISH)?1:0;

always @(posedge clk or posedge reset) begin
    state <= next_state;
end

always @(*) begin
    if(reset)
        next_state = IDLE;
    else begin
        case(state)
            IDLE: begin
                if(gray_ready) next_state = READ;
                else next_state = IDLE;
            end
            READ: begin
                if(cnt_read == 11) next_state = WRITE;
                else next_state = READ;
            end
            WRITE: begin
                if(lbp_addr == 16254) next_state = FINISH; //u &row && &col
                else next_state = READ;
            end
            default: next_state = IDLE;
        endcase
    end
end

//row col
always @(posedge clk or posedge reset) begin
    if(reset) {row,col} <= 129;
    else begin
        if(next_state == WRITE) begin
            if(col == 126)
            begin
            row <= row + 1;
            col <= 1;
            end
            else col <= col + 1;
        end
    end
end

always @(posedge clk) begin
    if(next_state == WRITE) begin
        lbp_addr <= {row,col};
    end
end

always @(posedge clk or posedge reset) begin
    if(reset)begin
        gray_addr <= 0;
        cnt_read <= 0;
        gray_req <= 0;
    end
    else if(next_state == READ) 
    begin
        gray_req <= 1;
        case (cnt_read)
            0 : gray_addr <= {row,col}; //w watch the wave if cnt_read can start from 0
            1 : gray_addr <= {row-7'd1,col-7'd1};
            2 : gray_addr <= {row-7'd1,col};
            3 : gray_addr <= {row-7'd1,col+7'd1};
            4 : gray_addr <= {row,col-7'd1};
            5 : gray_addr <= {row,col+7'd1};
            6 : gray_addr <= {row+7'd1,col-7'd1};
            7 : gray_addr <= {row+7'd1,col};
            8 : gray_addr <= {row+7'd1,col+7'd1};
        endcase

        if(cnt_read < 11)
            cnt_read <= cnt_read + 1;
        else
            cnt_read <= 0;
    end
    else
    begin
        gray_req <= 0;
    end
end

//pix buf

always @(posedge clk or posedge reset) begin
    if(reset)
    begin
        buff[0] <= 0;
        buff[1] <= 0;
        buff[2] <= 0;
        buff[3] <= 0;
        buff[4] <= 0;
        buff[5] <= 0;
        buff[6] <= 0;
        buff[7] <= 0;
        buff[8] <= 0;
    end
    else if(next_state == READ)
    begin
        if(cnt_read == 1)
            mid <= gray_data; 


        case (cnt_read)
            2:  buff[0][0]  <= (gray_data >= mid)?1:0;   
            3:  buff[1][1]  <= (gray_data >= mid)?1:0;   
            4:  buff[2][2]  <= (gray_data >= mid)?1:0;   
            5:  buff[3][3]  <= (gray_data >= mid)?1:0;   
            6:  buff[5][4]  <= (gray_data >= mid)?1:0;   
            7:  buff[6][5]  <= (gray_data >= mid)?1:0;   
            8:  buff[7][6]  <= (gray_data >= mid)?1:0;   
            9:  buff[8][7]  <= (gray_data >= mid)?1:0;   
        endcase
    end
    else if(next_state == WRITE)
    begin
        buff[0] <= 0;
        buff[1] <= 0;
        buff[2] <= 0;
        buff[3] <= 0;
        buff[4] <= 0;
        buff[5] <= 0;
        buff[6] <= 0;
        buff[7] <= 0;
        buff[8] <= 0;
    end
end

wire unsigned [7:0] result;
reg unsigned [7:0] add1, add2;
assign result = add1 + add2;
//cal
always @(posedge clk) begin
    if(state == READ)
    begin
        if(cnt_read == 3)
        begin
            add1 <= 0;
            add2 <= buff[0];
        end
        else
        begin
            
            add1 <= result;
            case (cnt_read)
                4 : add2 <= buff[1];
                5 : add2 <= buff[2];
                6 : add2 <= buff[3];
                7 : add2 <= buff[5];
                8 : add2 <= buff[6];
                9 : add2 <= buff[7];
                10 : add2 <= buff[8];
            endcase
        end
    end
end

//data out

always @(posedge clk) begin
    if(next_state == WRITE)
    begin
        lbp_data <= result;
        lbp_valid <= 1;
    end
    else
        lbp_valid <= 0;
end
//====================================================================
endmodule