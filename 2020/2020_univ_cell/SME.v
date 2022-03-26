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

//counter
always@(posedge clk or posedge reset)begin
    if(reset)begin 
        cnt <= 0; 
        pat_cnt <= 0;  
    end
    else if(state == CAL && cnt == 33) begin 
        cnt <= 0;
        pat_cnt <= 0;
    end
    else if(next_state == CAL || next_state == READSTR ) cnt <= cnt + 1; //string -> pattern cnt==0??
    else if(next_state == READPAT ) begin
        cnt <= 0;
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
    else if(next_state == READPAT)begin
        pattern[pat_cnt] <= chardata;
        if(pat_cnt == 0)begin
            for(j=1;j<8;j=j+1)
                pattern[j] <= 8'h2E;
        end
    end
end


//match_tmp
always @(posedge clk or posedge reset) begin
    //cnt 0 ~ 26
    if(next_state == CAL && cnt <27)begin
        match_tmp[0] <= ((pattern[cnt] == 8'h2E) || (pattern[cnt] == 8'h5E && string[cnt] == 8'd20) || (pattern[cnt] == string[cnt])) ? 1 : 0;
        match_tmp[1] <= ((pattern[cnt+4'd1] == 8'h2E) || (pattern[cnt+4'd1] == string[cnt+4'd1])) ? 1 : 0;
        match_tmp[2] <= ((pattern[cnt+4'd2] == 8'h2E) || (pattern[cnt+4'd2] == string[cnt+4'd2])) ? 1 : 0;
        match_tmp[3] <= ((pattern[cnt+4'd3] == 8'h2E) || (pattern[cnt+4'd3] == string[cnt+4'd3])) ? 1 : 0;
        match_tmp[4] <= ((pattern[cnt+4'd4] == 8'h2E) || (pattern[cnt+4'd4] == string[cnt+4'd4])) ? 1 : 0;
        match_tmp[5] <= ((pattern[cnt+4'd5] == 8'h2E) || (pattern[cnt+4'd5] == string[cnt+4'd5])) ? 1 : 0;
        match_tmp[6] <= ((pattern[cnt+4'd6] == 8'h2E) || (pattern[cnt+4'd6] == string[cnt+4'd6])) ? 1 : 0;
        match_tmp[7] <= ((pattern[cnt+4'd7] == 8'h2E) || (pattern[cnt+4'd7] == string[cnt+4'd7]) || (pattern[cnt+4'd7] == 8'h24 && string[cnt+4'd7] == 8'd20)) ? 1 : 0;
    end
end

assign match = &match_tmp;


//output
always @(*) begin
    if(next_state == OUT)begin
        valid = 1'b1;
        match_index = cnt[4:0];
    end
    else begin
        valid = 0;
        match_index = 0;
    end
end

endmodule