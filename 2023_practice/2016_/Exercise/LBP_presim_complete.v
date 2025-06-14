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
reg [2:0] state, next_state;
parameter IDLE = 3'd0; 
parameter READ = 3'd1; 
parameter CAL = 3'd2; 
parameter WRITE = 3'd3; 
parameter FINISH = 3'd4; 

reg [6:0] col;
reg [6:0] row;
reg read_done;
reg is_edge;
reg [3:0]cnt_read;
reg [3:0]cnt_cal;
reg [7:0] pix [0:8];
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
                if(read_done) next_state = CAL;
                else next_state = READ;
            end
            CAL: begin
                if(cnt_cal == 8) next_state = WRITE;
                else next_state = CAL;
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
        read_done <= 0;
        is_edge <= 0;
        gray_req <= 0;
    end
    else if(next_state == READ) begin
        if(col == 0 || col == 127 || row == 0 || row == 127) //u |row &row
        begin
            read_done <= 1;
            is_edge <= 1;
        end
        else if (col == 1)
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
                //default: gray_addr <= 0
            endcase

            if(cnt_read < 10)
                cnt_read <= cnt_read + 1;
            else
                cnt_read <= 0;

            if(cnt_read == 10)
                read_done <= 1;
        end
        else
        begin
            gray_req <= 1;
            case (cnt_read)
                1: gray_addr <= {row-7'd1,col+7'd1};
                2: gray_addr <= {row,col+7'd1}; 
                3: gray_addr <= {row+7'd1,col+7'd1}; 
                //default: gray_addr <= 0;
            endcase

            if(cnt_read < 4)
                cnt_read <= cnt_read + 1;
            else
                cnt_read <= 0;

            if(cnt_read == 4)
                read_done <= 1;
        end
    end
    else
    begin
        gray_req <= 0;
        read_done <= 0;
        is_edge <= 0;
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
        if(col == 1)
        begin
            case (cnt_read)
                1:  pix[4] <= gray_data; 
                2:  pix[0] <= gray_data; 
                3:  pix[1] <= gray_data; 
                4:  pix[2] <= gray_data; 
                5:  pix[3] <= gray_data; 
                6:  pix[5] <= gray_data; 
                7:  pix[6] <= gray_data; 
                8:  pix[7] <= gray_data; 
                9:  pix[8] <= gray_data; 
            endcase

            case (cnt_read)
                2:  buff[0][0]  <= (gray_data >= pix[4])?1:0;   
                3:  buff[1][1]  <= (gray_data >= pix[4])?1:0;   
                4:  buff[2][2]  <= (gray_data >= pix[4])?1:0;   
                5:  buff[3][3]  <= (gray_data >= pix[4])?1:0;   
                6:  buff[5][4]  <= (gray_data >= pix[4])?1:0;   
                7:  buff[6][5]  <= (gray_data >= pix[4])?1:0;   
                8:  buff[7][6]  <= (gray_data >= pix[4])?1:0;   
                9:  buff[8][7]  <= (gray_data >= pix[4])?1:0;   
            endcase
        end
        else //read three
        begin
            if(cnt_read == 1)
            begin
                pix[0] <= pix[1];
                pix[1] <= pix[2];
                pix[3] <= pix[4];
                pix[4] <= pix[5];
                pix[6] <= pix[7];
                pix[7] <= pix[8];

                buff[0][0] <= (pix[1] >= pix[5]) ? 1:0;
                buff[1][1] <= (pix[2] >= pix[5]) ? 1:0;
                buff[3][3] <= (pix[4] >= pix[5]) ? 1:0;
                buff[6][5] <= (pix[7] >= pix[5]) ? 1:0;
                buff[7][6] <= (pix[8] >= pix[5]) ? 1:0;
            end
            else
            begin
                case (cnt_read)
                    2 :
                    begin
                        pix[2] <= gray_data;
                        buff[2][2] <= (gray_data >= pix[4]) ? 1:0;
                    end
                    3 :
                    begin
                        pix[5] <= gray_data;
                        buff[5][4] <=  (gray_data >= pix[4]) ? 1:0;
                    end
                    4 :
                    begin
                        pix[8] <= gray_data; 
                        buff[8][7] <= (gray_data >= pix[4]) ? 1:0;
                    end
                endcase
            end
        end
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
    if(state == CAL)
    begin
        if(cnt_cal == 0)
        begin
            // buff[4] <= 0;
            add1 <= 0;
            add2 <= buff[0];
        end
        else
        begin
            
            add1 <= result;
            case (cnt_cal)
                1 : add2 <= buff[1];
                2 : add2 <= buff[2];
                3 : add2 <= buff[3];
                4 : add2 <= buff[5];
                5 : add2 <= buff[6];
                6 : add2 <= buff[7];
                7 : add2 <= buff[8];
            endcase
        end

        if(cnt_cal < 8)
            cnt_cal <= cnt_cal + 1;
        else
        begin
            cnt_cal <= 0;
            lbp_data <= result;
        end
    end
end

//data out

always @(posedge clk) begin
    if(next_state == WRITE)
    begin
        lbp_valid <= 1;
    end
    else
        lbp_valid <= 0;
end











//====================================================================
endmodule