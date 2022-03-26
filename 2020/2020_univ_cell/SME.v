module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output reg valid;

reg [7:0] string [0:33];//start with 20 end with 20
reg [7:0] pattern [0:7];
reg [7:0] cnt;
reg [7:0] match_tmp;
// rst
// for(i=0 ;i<34;i++){
//     string[i] <= 0
// }

//cnt
always @(posedge clk or posedge reset) begin
    if(reset) cnt <= 0;
    else if(state == CAL && cnt == 33) cnt <= 0;
    else if(state == CAL || state == READ) cnt <= cnt + 1;
end


//match_tmp
always @(posedge clk or posedge reset) begin
    //pc 0 ~ 26
    if(state == CAL && pc <27)begin
        match_tmp[0] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == 8'h5E && string[pc] == 8'd20) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[1] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[2] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[3] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[4] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[5] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[6] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc])) ? 1 : 0;
        match_tmp[7] <= ((pattern[pc] == 8'h2E) || (pattern[pc] == string[pc]) || (pattern[pc] == 8'h24 && string[pc] == 8'd20)) ? 1 : 0;
    end
end

assign match = &match_tmp;

always@(*)begin
    if(reset)   next_state=IDLE;
    else begin
        case(state)
            IDLE:begin
                if(isstring == 1)   next_state = READSTR;
                else if(ispattern == 1) next_state = READPAT;
                else next_state = IDLE;
            end
            READSTR:begin
                if()
            end
            READPAT:begin

            end
            CAL:begin
                if(match || pc == 8'd26)next_state = OUTPUT;
                else next_state = CAL;
            end
            OUT:begin
                next_state = READSTR;
            end
            default:    next_state = IDLE;
        endcase
    end
end

//output 
always @(*) begin
    if(next_state == OUT)begin
        valid = 1'b1;
        index = pc;
    end
    else begin
        valid = 0;
        index = 0;
    end
end











endmodule
