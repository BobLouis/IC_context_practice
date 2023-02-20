module huffman(clk, reset, gray_data, gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output [7:0] M1, M2, M3, M4, M5, M6;
  
reg [2:0]state, next_state;
parameter IDLE = 3'd0,
    READ = 3'd1,
    CNT_OUT = 3'd2,
    FIR = 3'd3,
    SEC = 3'd4,
    ENC = 3'd5,
    GRP = 3'd6,
    OUT = 3'd7;

reg [2:0]cnt_stage;
reg [6:0]arr_val[1:6];
reg [3:0]group  [1:6];
reg [7:0]code   [1:6];
reg [2:0]len    [1:6];
reg [7:0]M      [1:6];

reg [2:0]ptr;
reg [2:0]ptr_fir;
reg [2:0]ptr_sec;
reg [3:0]next_group;


assign HC1 = code[1];
assign HC2 = code[2];
assign HC3 = code[3];
assign HC4 = code[4];
assign HC5 = code[5];
assign HC6 = code[6];
//assign {HC1,HC2,}=code

assign M1 = M[1];
assign M2 = M[2];
assign M3 = M[3];
assign M4 = M[4];
assign M5 = M[5];
assign M6 = M[6];

integer  i;


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
                if(gray_valid == 1) next_state = READ;
                else next_state = IDLE;
            end
            READ:begin
                if(gray_valid == 0) next_state = CNT_OUT;
                else next_state = READ;  
            end
            CNT_OUT: next_state = FIR;
            FIR://3
            begin
                if(ptr == 7) next_state = SEC;
                else next_state = FIR;
            end
            SEC:
            begin
                if(ptr == 7) next_state = ENC;
                else next_state = SEC;
            end
            ENC:
            begin
                next_state = GRP;
            end
            GRP:
            begin
                if(cnt_stage == 5) next_state = OUT;
                else next_state = FIR;
            end
            OUT:
                next_state = IDLE; 
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
        CNT1 <= 0;
        CNT2 <= 0;
        CNT3 <= 0;
        CNT4 <= 0;
        CNT5 <= 0;
        CNT6 <= 0;
        CNT_valid <= 0;
    end
    else begin
        if(next_state == READ)begin
            case(gray_data)
                1: CNT1 <= CNT1 + 1;
                2: CNT2 <= CNT2 + 1;
                3: CNT3 <= CNT3 + 1;
                4: CNT4 <= CNT4 + 1;
                5: CNT5 <= CNT5 + 1;
                6: CNT6 <= CNT6 + 1;
            endcase
        end
        else if(next_state == CNT_OUT)
            CNT_valid <= 1;
        else begin 
            CNT_valid <= 0;                  
        end
    end
end


//combine
always@(posedge clk or posedge reset)begin
    if(reset)
    begin
        arr_val [1] <= 0;
        arr_val [2] <= 0;
        arr_val [3] <= 0;
        arr_val [4] <= 0;
        arr_val [5] <= 0;
        arr_val [6] <= 0;

        group[1] <= 0;
        group[2] <= 1;
        group[3] <= 2;
        group[4] <= 3;
        group[5] <= 4;
        group[6] <= 5;

        len[1] <= 0;
        len[2] <= 0;
        len[3] <= 0;
        len[4] <= 0;
        len[5] <= 0;
        len[6] <= 0;

        code[1] <= 0;
        code[2] <= 0;
        code[3] <= 0;
        code[4] <= 0;
        code[5] <= 0;
        code[6] <= 0;

        ptr <= 2;
        ptr_fir <= 1;
        ptr_sec <= 1;
        cnt_stage <= 0;
        next_group <= 6;
        code_valid <= 0;
    end
    if(next_state == CNT_OUT)
    begin
        arr_val [1] <= CNT1;
        arr_val [2] <= CNT2;
        arr_val [3] <= CNT3;
        arr_val [4] <= CNT4;
        arr_val [5] <= CNT5;
        arr_val [6] <= CNT6;
    end
    else if(next_state == FIR)
    begin
        if(arr_val[ptr] <= arr_val[ptr_fir])
        begin
            if(arr_val[ptr] == arr_val[ptr_fir])
            begin
                if(group[ptr] > group[ptr_fir])
                    ptr_fir <= ptr;
            end 
            else
            begin
                ptr_fir <= ptr;
            end           
        end



        if(ptr == 7)
            ptr <= 2;
        else
            ptr <= ptr + 1;

        
    end
    else if(next_state == SEC)
    begin

        if(arr_val[ptr] <= arr_val[ptr_sec] && group[ptr_fir] != group[ptr])
            ptr_sec <= ptr;
        else if(group[ptr_fir] == group[ptr_sec])
            ptr_sec <= ptr_sec +1;

        if(ptr == 7)
            ptr <= 2;
        else
            ptr <= ptr+1;

    end
    else if(next_state == ENC)
    begin
        for(i = 1; i<7; i = i + 1)
        begin
            if (group[i] == group[ptr_fir])
            begin
                code[i][len[i]] <= 1;
                len[i] <= len[i] + 1;
                arr_val[i] <= arr_val[ptr_fir]+ arr_val[ptr_sec];
            end

            if (group[i] == group[ptr_sec])
            begin
                len[i] <= len[i] + 1;
                arr_val[i] <= arr_val[ptr_fir]+ arr_val[ptr_sec];
            end
        end


    end
    else if(next_state == GRP)
    begin
        for(i=1; i<7; i=i+1)
        begin
            if(group[i] == group[ptr_fir] || group[i] == group[ptr_sec])
            begin
                group[i] <= next_group;
            end
            next_group <= next_group + 1;
        end

        cnt_stage <= cnt_stage + 1;
        ptr <= 2;
        ptr_fir <= 1;
        ptr_sec <= 1;
    end
    else if(next_state == OUT)
    begin
        code_valid <= 1;
    end
end

always @(*) begin
    for(i = 1; i < 7;i=i+1)
    begin
        case (len[i])
            1:M[i] = 8'b0000_0001;
            2:M[i] = 8'b0000_0011;
            3:M[i] = 8'b0000_0111;
            4:M[i] = 8'b0000_1111;
            5:M[i] = 8'b0001_1111;
            default: M[i] = 0;
        endcase
    end
end

endmodule