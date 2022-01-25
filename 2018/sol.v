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
    integer i, j;

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
            end
            else if(state == 3'd2)//calcualte tree
            begin
                CNT_valid <= 0;
            end
        end
    end


    
    always @* begin

        if(reset)
        begin
            rnk[1] = 1;
            rnk[2] = 2;
            rnk[3] = 3;
            rnk[4] = 4;
            rnk[5] = 5;
            rnk[6] = 6;
        end
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

                    tmp_rnk = rnk[j];
                    rnk[j] = rnk[j+1];
                    rnk[j+1] = tmp_rnk;
                end 
            end
        end

    end
endmodule

