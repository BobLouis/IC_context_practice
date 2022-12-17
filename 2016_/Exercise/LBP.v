
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
output  reg[13:0] 	gray_addr;
output  reg      	gray_req;
input   	gray_ready;
input   [7:0] 	gray_data;
output  [13:0] 	lbp_addr;
output 	lbp_valid;
output  reg[7:0] 	lbp_data;
output  reg	finish;


reg [3:0]cnt_read;
reg [7:0]pix [0:8];
reg [7:0]buffer [0:8];
reg read_done;

//====================================================================


//cnt_read



//gray_addr cnt_read
always @(posedge clk or posedge reset) begin
    if(reset)
    begin
        gray_addr <= 0;
        cnt_read <= 0;
    end
    else if(state == READ) //read full 
    begin
        if(col == 1)
        begin
            case (cnt_read)
                1: gray_addr <= {row,col}; 
                2: gray_addr <= {row-7'd1,col-7'd1}; 
                3: gray_addr <= {row-7'd1,col}; 
                4: gray_addr <= {row-7'd1,col+7'd1}; 
                5: gray_addr <= {row,col-7'd1}; 
                6: gray_addr <= {row,col+7'd1};
                7: gray_addr <= {row+7'd1,col-7'd1}; 
                8: gray_addr <= {row+7'd1,col}; 
                9: gray_addr <= {row+7'd1,col+7'd1}; 
                default: gray_addr <= 0;
            endcase
            if(cnt_read < 10)
                cnt_read <= cnt_read +1; 
            else
                cnt_read <= 0;
        end
        else
        begin
            case (cnt_read)
                1: gray_addr <= {row-7'd1,col+7'd1}; 
                2: gray_addr <= {row,col+7'd1}; 
                3: gray_addr <= {row+7'd1,col+7'd1}; 
                default: gray_addr <= 0;
            endcase
            if(cnt_read < 4)
                cnt_read <= cnt_read +1; 
            else
                cnt_read <= 0;
        end
    end
end

//pix buff

always @(posedge clk) begin
    if(state == READ)
    begin
        if(col == 1) //full read
        begin
            case (read_cnt)
                2 :pix[4] <= gray_data;  
                3 :pix[0] <= gray_data;  
                4 :pix[1] <= gray_data;  
                5 :pix[2] <= gray_data;  
                6 :pix[3] <= gray_data;  
                7 :pix[5] <= gray_data;  
                8 :pix[6] <= gray_data;  
                9 :pix[7] <= gray_data;  
                10:pix[8] <= gray_data;  
            endcase
        end
        else //read three
        begin
            if(read_cnt == 1)
            begin
                pix[0] <= pix[1];
                pix[1] <= pix[2];
                pix[3] <= pix[4];
                pix[5] <= pix[1];
                pix[0] <= pix[1];
                pix[0] <= pix[1];
                pix[0] <= pix[1];
            end
            case (read_cnt)
                2 :pix[4] <= gray_data;  
                3 :pix[0] <= gray_data;  
                4 :pix[1] <= gray_data;  
                5 :pix[2] <= gray_data;  
                6 :pix[3] <= gray_data;  
                7 :pix[5] <= gray_data;  
                8 :pix[6] <= gray_data;  
                9 :pix[7] <= gray_data;  
                10:pix[8] <= gray_data;  
            endcase
        end
    end
end


assign lbp_valid (state == WRITE)?1:0;


    
//====================================================================
endmodule
