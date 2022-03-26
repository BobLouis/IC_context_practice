module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output match;
output reg [4:0] match_index;
output reg valid;

reg [7:0] string [0:33];
reg [7:0] pattern [0:7];
reg [7:0] cnt, pat_cnt;
reg [7:0] match_tmp;
reg [15:0] k;


reg [2:0]state, next_state;
parameter IDLE = 3'b000;
parameter READSTR = 3'b001;
parameter READPAT = 3'b010;
parameter CAL = 3'b011;
parameter OUT = 3'b100;

integer i,j;

always@(posedge clk or posedge reset)begin
    if(reset)   state <= IDLE;
    else    state <= next_state;    
end

always@(*)begin
    if(reset)   next_state=IDLE;
    else begin
        case(state)
            IDLE:begin
                if(isstring == 1)   next_state = READSTR;
                else next_state = IDLE;
            end
            READSTR:begin
                if(ispattern == 1)  next_state = READPAT;
                else next_state = READSTR;
            end
            READPAT:begin
                if(ispattern == 0)  next_state = CAL;
                else next_state = READPAT;
            end
            CAL:begin
                if(match || cnt == 8'd26)next_state = OUT;
                else next_state = CAL;
            end
            OUT:begin
                if(isstring == 1) next_state = READSTR;
                else if(ispattern == 1) next_state = READPAT;
            end
            default:    next_state = IDLE;
        endcase
    end
end




//cnt
always@(posedge clk or posedge reset)begin
    if(reset)begin 
        cnt <= 0; 
    end
    else if((match == 1'b1 || cnt == 8'd27) && state == CAL) begin 
        cnt <= 0;
    end
    else if(next_state == CAL || next_state == READSTR ) 
    begin
        cnt <= cnt + 1; //string -> pattern cnt==0
    end
    else if(next_state == READPAT || next_state == OUT) begin
        cnt <= 0;
    end    
end

//pat_cnt
always@(posedge clk or posedge reset)begin
    if(reset)begin 
        pat_cnt <= 0;  
    end
    else if(next_state == CAL || next_state == READSTR ) 
    begin
        pat_cnt <= 0;
    end
    else if(next_state == READPAT || next_state == OUT) begin
        pat_cnt <= pat_cnt + 1;
    end    
end
    

//READ DATA STRING
always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(i=0;i<34;i=i+1)
            string[i] <= 8'h20;
    end
    else if(next_state == READSTR)begin
        string[cnt + 1] <= chardata;
        if(cnt == 0)begin
            for(i=2;i<34;i=i+1)
                string[i] <= 8'h20;
        end
    end
end

//READ DATA PATTERN
always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(j=0;j<8;j=j+1)
            pattern[j] <= 8'h2E;
    end
    else if(next_state == READPAT || next_state == OUT)begin
        if(ispattern)
            pattern[pat_cnt] <= chardata;
        if(pat_cnt == 0)begin
            for(j=1;j<8;j=j+1)
                pattern[j] <= 8'h2E;
        end
    end
end


//match_tmp
always @(posedge clk) begin
    //cnt 0 ~ 26
    if(next_state == CAL && cnt <27)begin
        match_tmp[0] <= ((pattern[0] == 8'h2E) || (pattern[0] == 8'h5E && string[cnt] == 8'h20) || (pattern[0] == string[cnt])) ? 1 : 0;
        match_tmp[1] <= ((pattern[1] == 8'h2E) || (pattern[1] == string[cnt+4'd1]) || (pattern[1] == 8'h24 && string[cnt+4'd1] == 8'h20)) ? 1 : 0;
        match_tmp[2] <= ((pattern[2] == 8'h2E) || (pattern[2] == string[cnt+4'd2]) || (pattern[2] == 8'h24 && string[cnt+4'd2] == 8'h20)) ? 1 : 0;
        match_tmp[3] <= ((pattern[3] == 8'h2E) || (pattern[3] == string[cnt+4'd3]) || (pattern[3] == 8'h24 && string[cnt+4'd3] == 8'h20)) ? 1 : 0;
        match_tmp[4] <= ((pattern[4] == 8'h2E) || (pattern[4] == string[cnt+4'd4]) || (pattern[4] == 8'h24 && string[cnt+4'd4] == 8'h20)) ? 1 : 0;
        match_tmp[5] <= ((pattern[5] == 8'h2E) || (pattern[5] == string[cnt+4'd5]) || (pattern[5] == 8'h24 && string[cnt+4'd5] == 8'h20)) ? 1 : 0;
        match_tmp[6] <= ((pattern[6] == 8'h2E) || (pattern[6] == string[cnt+4'd6]) || (pattern[6] == 8'h24 && string[cnt+4'd6] == 8'h20)) ? 1 : 0;
        match_tmp[7] <= ((pattern[7] == 8'h2E) || (pattern[7] == string[cnt+4'd7]) || (pattern[7] == 8'h24 && string[cnt+4'd7] == 8'h20)) ? 1 : 0;
    end
end

assign match = &match_tmp;


//output
always @(*) begin
    if(next_state == OUT)begin
        valid = 1'b1;
        match_index = (pattern[0] == 8'h5E) ? cnt[4:0] - 5'd1 : cnt[4:0] - 5'd2;
    end
    else begin
        valid = 0;
        match_index = 0;
    end
end

always@(match)begin
    if(match==1)
        cnt = 0;
    else 
        cnt = cnt;
end

always @(posedge clk or posedge reset) begin
    if(reset) k <= 0;
    else k <= k+1;
end

endmodule