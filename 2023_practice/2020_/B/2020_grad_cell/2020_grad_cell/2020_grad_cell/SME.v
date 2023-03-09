module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output  valid;


reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	      READ_STRING = 3'd1,
          READ_PATTERN = 3'd2,
	      CAL = 3'd3,
          CAL_STAR = 3'd4,
	      OUT = 3'd5;

reg [7:0]str[0:33];
reg [7:0]pat[0:8];

reg [5:0]str_len;
reg [3:0]pat_len;

reg [5:0]str_ptr;
reg [3:0]pat_ptr;

reg [5:0]str_tmp;
reg [5:0]star_tmp;

reg [3:0]pat_ptr_star;
reg [20:0] counter;

reg mat;
reg flag;

reg str_flag;
reg star_flag;

assign valid = (state == OUT);

integer i;

always@(posedge clk or posedge reset)begin
    if(reset)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(reset)
        next_state = IDLE;
    else begin
        case(state)
            IDLE:begin
                if(isstring == 1) next_state = READ_STRING;
                else if(ispattern == 1) next_state = READ_PATTERN;
                else next_state = IDLE;
            end
            READ_STRING:begin
                if(ispattern == 1) next_state = READ_PATTERN;
                else next_state = READ_STRING;  
            end
            READ_PATTERN:begin
                if(ispattern == 0) next_state = CAL;
                else next_state = READ_PATTERN;
            end
            CAL:begin
                if(star_flag == 1) next_state = CAL_STAR;
                else if(match == 1) next_state = OUT;
                else if((str_tmp + pat_ptr) == str_len +1) next_state = OUT;
                else next_state = CAL;
            end 
            CAL_STAR:begin
                if(match == 1) next_state = OUT;
                else if((star_tmp + pat_ptr) == str_len +4) next_state = OUT;
                else if (str_ptr > str_len+2) next_state = OUT;
                else next_state = CAL_STAR;
            end
            OUT:
                if(isstring == 1) next_state = READ_STRING;
                else if(ispattern == 1) next_state = READ_PATTERN;
                else next_state = OUT;
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
        str_len <= 1;
        pat_len <= 0;
        for(i=0;i<34;i=i+1)
            str[i] <= 8'h20;
        str_ptr <= 0;
        str_tmp <= 0;
        pat_ptr <= 0; 
        flag <= 1;
        str_flag <= 1;
        star_flag <= 0;
    end
    else begin
        if(next_state == READ_STRING)begin
            if(flag == 1)begin
                str_len <= 2;
                str[1] <= chardata;
                flag <= 0;
                for(i=2;i<34;i=i+1)
                    str[i] <= 8'h20;
            end
            else begin
                str_len <= str_len + 1;
                str[str_len] <= chardata;
            end            
            match <= 0;
        end 
        else if(next_state == READ_PATTERN)begin
            pat[pat_len] <= chardata;
            pat_len <= pat_len + 1;
            match <= 0;
        end
        else if(next_state == CAL)begin 
            if(pat[pat_ptr] == 8'h2a)begin
                star_tmp <= str_ptr;
                star_flag <= 1;
                pat_ptr <= pat_ptr + 1;
                str_flag <= 1;
                pat_ptr_star <= pat_ptr + 1;
                // pat_len <= pat_len - pat_ptr;
            end
            else if(mat == 1)begin
                if(str_flag == 1)
                    str_tmp <= str_ptr;
                
                if(pat_len == pat_ptr + 1)
                    match <= 1;
                pat_ptr <= pat_ptr + 1;
                str_ptr = str_ptr + 1;
                str_flag <= 0;
            end    
            else begin
                str_flag <= 1;
                str_ptr <= str_tmp + 1;
                str_tmp <= str_tmp + 1;
                pat_ptr <= 0;
            end        
        end
        else if(next_state == CAL_STAR)begin
            if(mat == 1)begin
                if(str_flag == 1)
                    star_tmp <= str_ptr;
                
                if(pat_len == pat_ptr + 1)
                    match <= 1;
                pat_ptr <= pat_ptr + 1;
                str_ptr = str_ptr + 1;
                str_flag <= 0;
            end    
            else begin
                str_flag <= 1;
                str_ptr <= star_tmp + 1;
                star_tmp <= star_tmp + 1;
                pat_ptr <= pat_ptr_star;
            end    
        end
        else if(next_state == OUT)begin
            if(pat[0] == 8'h5e || (pat[0] == 8'h2e && pat_len == 1))
                match_index <= str_tmp;
            else 
                match_index <= str_tmp - 1;
            str_ptr <= 0;
            pat_ptr <= 0; 
            pat_len <= 0;
            str_tmp <= 0;
            flag <= 1;
            star_flag <= 0;
        end
    end
end


always @(*) begin
    if(pat[pat_ptr] == 8'h2e)begin
        mat = 1;
    end
    else if(str[str_ptr] == pat[pat_ptr])
        mat = 1;
    else if(str[str_ptr] == 8'h20 )begin
        if(pat[pat_ptr] == 8'h24 || pat[pat_ptr] == 8'h5e)
            mat = 1;
        else
            mat = 0;
    end 
    else
        mat = 0;

end

always@(posedge clk or posedge reset)begin
    if(reset)
        counter <= 0;
    else 
        counter <= counter + 1;

end

endmodule
