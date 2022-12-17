
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
always @(posedge clk or posedge reset) begin
    if(reset)
    begin
        read_cnt <= 0; 
    end
    else if(state == READ)
    begin
        
        if(col == 1)
        begin
            cnt_read <= cnt_read+1;
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(state == READ)
    begin
        if(col == 1)
        begin
            
        end
    end

end


assign lbp_valid (state == WRITE)?1:0;


    
//====================================================================
endmodule
