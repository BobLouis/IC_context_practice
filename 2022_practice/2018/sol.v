module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

    input clk;
    input reset;
    input gray_valid;
    input [7:0] gray_data;
    output reg CNT_valid;
    output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
    output reg code_valid;
    output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
    output reg [7:0] M1, M2, M3, M4, M5, M6;

    

    reg [2:0] state; //0=>idle 1 =>output CNT 
    reg [7:0] tmp_arr;
    reg [2:0] tmp_rnk;
    reg [7:0] arr [1:6];
    reg [2:0] rnk[1:6];
    reg [5:0] rnk_flag;
    reg [7:0] pc;
    reg [4:0] code[1:6];
    reg [6:0] stk;
    integer i, j, k;

    always @(posedge clk) begin
        if(reset)
        begin
            CNT_valid <= 0;
            code_valid <= 0;
            state <=0;
            CNT1 <= 0;
            CNT2 <= 0;
            CNT3 <= 0;
            CNT4 <= 0;
            CNT5 <= 0;
            CNT6 <= 0;
            HC1  <= 0;
            HC2  <= 0;
            HC3  <= 0;
            HC4  <= 0;
            HC5  <= 0;
            HC6  <= 0;
            rnk_flag <= 0;
            stk <= 7'd100;
            for(k = 1;k < 7;k = k + 1)
            begin
                code[k] <= 0;
            end
        end
        else
        begin
            if(!state)
            begin
                CNT_valid <= 0;
                code_valid <= 0;
                if(gray_valid)
                begin
                    case (gray_data)
                        8'd1:CNT1 <= CNT1 + 1;
                        8'd2:CNT2 <= CNT2 + 1;
                        8'd3:CNT3 <= CNT3 + 1;
                        8'd4:CNT4 <= CNT4 + 1;
                        8'd5:CNT5 <= CNT5 + 1;
                        8'd6:CNT6 <= CNT6 + 1;
                        default: CNT6 <= CNT6;
                    endcase
                end
                if((CNT1 + CNT2 + CNT3 + CNT4 + CNT5 +CNT6) == 100)
                begin
                    state <= 3'd1;
                end
            end
            else if(state == 3'd1)//output cnt
            begin
                CNT_valid <= 1'b1;
                state <= 3'd2;
                pc <= 1;
            end
            else if(state == 3'd2)//calcualte rnk
            begin
                CNT_valid <= 0;
                if(arr[pc] == CNT1 && !rnk_flag[0])
                begin
                    rnk[pc] <= 1;
                    rnk_flag[0] <= 1;
                end
                else if(arr[pc] == CNT2 && !rnk_flag[1])
                begin
                    rnk[pc] <= 2;
                    rnk_flag[1] <= 1;
                end
                else if(arr[pc] == CNT3 && !rnk_flag[2])
                begin
                    rnk[pc] <= 3;
                    rnk_flag[2] <= 1;
                end
                else if(arr[pc] == CNT4 && !rnk_flag[3])
                begin
                    rnk[pc] <= 4;
                    rnk_flag[3] <= 1;
                end
                else if(arr[pc] == CNT5 && !rnk_flag[4])
                begin
                    rnk[pc] <= 5;
                    rnk_flag[4] <= 1;
                end
                else if(arr[pc] == CNT6 && !rnk_flag[5])
                begin
                    rnk[pc] <= 6;
                    rnk_flag[5] <= 1;
                end
                pc <= pc + 1;
                if(pc == 7)
                begin
                    state <= state + 1;
                    pc <= 1;
                end
            end
            else if(state == 3'd3) //decoding tree
            begin
                if(pc == 1)
                begin
                    case (rnk[pc])
                        1:M1 <= 8'b00000001;
                        2:M2 <= 8'b00000001;
                        3:M3 <= 8'b00000001;
                        4:M4 <= 8'b00000001;
                        5:M5 <= 8'b00000001;
                        6:M6 <= 8'b00000001;
                    endcase
                    if(arr[pc] < stk - arr[pc])
                    begin
                        code[rnk[pc]] <= 1;
                    end
                    else
                    begin
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= 1;
                        end
                    end
                    stk <= stk - arr[pc];
                end
                else if(pc == 2)
                begin
                    case (rnk[pc])
                        1:M1 <= 8'b00000011;
                        2:M2 <= 8'b00000011;
                        3:M3 <= 8'b00000011;
                        4:M4 <= 8'b00000011;
                        5:M5 <= 8'b00000011;
                        6:M6 <= 8'b00000011;
                    endcase
                    if(arr[pc] < stk - arr[pc])
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1 | 1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1;
                        end
                    end
                    else
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1 | 1;
                        end
                    end
                    stk <= stk - arr[pc];
                end
                else if(pc == 3)
                begin
                    case (rnk[pc])
                        1:M1 <= 8'b00000111;
                        2:M2 <= 8'b00000111;
                        3:M3 <= 8'b00000111;
                        4:M4 <= 8'b00000111;
                        5:M5 <= 8'b00000111;
                        6:M6 <= 8'b00000111;
                    endcase
                    if(arr[pc] < stk - arr[pc])
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1 | 1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1;
                        end
                    end
                    else
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1 | 1;
                        end
                    end
                    stk <= stk - arr[pc];
                end
                else if(pc == 4)
                begin
                    case (rnk[pc])
                        1:M1 <= 8'b00001111;
                        2:M2 <= 8'b00001111;
                        3:M3 <= 8'b00001111;
                        4:M4 <= 8'b00001111;
                        5:M5 <= 8'b00001111;
                        6:M6 <= 8'b00001111;
                    endcase
                    if(arr[pc] < stk - arr[pc])
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1 | 1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1;
                        end
                    end
                    else
                    begin
                        code[rnk[pc]] <= code[rnk[pc]]<<1;
                        for(k = pc + 1;k < 7;k = k + 1)
                        begin
                            code[rnk[k]] <= code[rnk[k]]<<1 | 1;
                        end
                    end
                    stk <= stk - arr[pc];
                end
                else if(pc == 5)
                begin
                    case (rnk[pc])
                        1:M1 <= 8'b00011111;
                        2:M2 <= 8'b00011111;
                        3:M3 <= 8'b00011111;
                        4:M4 <= 8'b00011111;
                        5:M5 <= 8'b00011111;
                        6:M6 <= 8'b00011111;
                    endcase
                    case (rnk[pc+1])
                        1:M1 <= 8'b00011111;
                        2:M2 <= 8'b00011111;
                        3:M3 <= 8'b00011111;
                        4:M4 <= 8'b00011111;
                        5:M5 <= 8'b00011111;
                        6:M6 <= 8'b00011111;
                    endcase
                    
                    code[rnk[pc]] <= code[rnk[pc]]<<1;
                    code[rnk[pc+1]] <= code[rnk[pc+1]]<<1 | 1;
                    state <= state + 1;
                end
                pc <= pc + 1;
            end
            else if(state == 3'd4)//output code
            begin
                HC1 <= code[1];
                HC2 <= code[2];
                HC3 <= code[3];
                HC4 <= code[4];
                HC5 <= code[5];
                HC6 <= code[6];
                code_valid <= 1;
                state <= state + 1;
            end
            else if(state == 3'd5)
            begin
                code_valid <= 0;
            end
        end
    end


    
    always @* begin

        arr[1] = CNT1;
        arr[2] = CNT2;
        arr[3] = CNT3;
        arr[4] = CNT4;
        arr[5] = CNT5;
        arr[6] = CNT6;

        for (i = 6; i > 0; i = i - 1) begin
            for (j = 1 ; j < i; j = j + 1) begin
                if (arr[j] < arr[j + 1]) begin
                    tmp_arr       = arr[j];
                    arr[j]     = arr[j + 1];
                    arr[j + 1] = tmp_arr;
                end 
            end
        end
    end

    
endmodule



