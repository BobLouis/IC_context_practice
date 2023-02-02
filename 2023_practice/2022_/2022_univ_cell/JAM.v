module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output  Valid );

reg [1:0] state, next_state;

parameter IDLE = 2'd0;
parameter READ = 2'd1;
parameter CAL  = 2'd2;
parameter OUT  = 2'd3;
reg [9:0] min;
reg [2:0] arr[0:7];
reg [3:0] cnt;
reg [2:0] idx;
reg [2:0] i;
reg [2:0] sw;
reg [2:0] tmp;



always @(posedge CLK or posedge RST) begin
    state <= next_state;
end

always @(*) begin
    if(RST)
        next_state = IDLE;
    else 
    begin
        case (state)
            IDLE: 
                next_state = READ;
            READ:
            begin
                if(cnt == 10) next_state = CAL;
                else next_state = READ;
            end
            CAL: 
            begin
                if(arr[0]==0 && arr[1]==1 && arr[2]==2 && arr[3]==3 && arr[4]==4 && arr[5]==5 && arr[6]==6 && arr[7]==7) next_state = OUT;
                else next_state = READ;
            end
            OUT: next_state = READ;
            default : next_state = IDLE;
        endcase
    end
end


//cnt 
always @(posedge CLK or posedge RST) begin
    if(RST)
        cnt <= 0;
    else if(next_state == READ)
        cnt <= cnt + 1;
    else 
        cnt <= 0;
end

wire [6:0] cmp;

assign cmp[6] = (arr[7] < arr[6]) ? 1:0;
assign cmp[5] = (arr[6] < arr[5]) ? 1:0;
assign cmp[4] = (arr[5] < arr[4]) ? 1:0;
assign cmp[3] = (arr[4] < arr[3]) ? 1:0;
assign cmp[2] = (arr[3] < arr[2]) ? 1:0;
assign cmp[1] = (arr[2] < arr[1]) ? 1:0;
assign cmp[0] = (arr[1] < arr[0]) ? 1:0;

always @(*) begin
    casex (cmp)
        7'bxxxxxx1 : idx = 1;
        7'bxxxxx10 : idx = 2;
        7'bxxxx100 : idx = 3;
        7'bxxx1000 : idx = 4;
        7'bxx10000 : idx = 5;
        7'bx100000 : idx = 6;
        7'b1000000 : idx = 7;  
        default: idx = 0;
    endcase
end


always @(posedge CLK or posedge RST) begin
    if(RST)
    begin
        arr[0] <= 4'd7;
        arr[1] <= 4'd6;
        arr[2] <= 4'd5;
        arr[3] <= 4'd4;
        arr[4] <= 4'd3;
        arr[5] <= 4'd2;
        arr[6] <= 4'd1;
        arr[7] <= 4'd0;
    end
    else if(next_state == READ)
    begin
        if(cnt == 0)
        begin
            sw <= idx;
            tmp <= idx - 1;
            i <= idx - 1;
        end
        else if(cnt > 0 && cnt < 8)
        begin
            tmp <= (sw > i && arr[sw] < arr[i] && arr[i] < arr[tmp])? i:tmp;
            i <= i-1; 
        end
        else if(cnt == 8) //switch step 1
        begin
            arr[sw] <= arr[tmp];
            arr[tmp] <= arr[sw];
        end
        else if(cnt == 9)
        begin
            case (sw)
                7:
                begin
                    arr[6] <= arr[0];
                    arr[0] <= arr[6];

                    arr[5] <= arr[1];
                    arr[1] <= arr[5];

                    arr[4] <= arr[2];
                    arr[2] <= arr[4];
                end 

                6:
                begin
                    arr[5] <= arr[0];
                    arr[0] <= arr[5];

                    arr[4] <= arr[1];
                    arr[1] <= arr[4];

                    arr[3] <= arr[2];
                    arr[2] <= arr[3];
                end

                5:
                begin
                    arr[4] <= arr[0];
                    arr[0] <= arr[4];

                    arr[3] <= arr[1];
                    arr[1] <= arr[3];
                end

                4:
                begin
                    arr[3] <= arr[0];
                    arr[0] <= arr[3];

                    arr[2] <= arr[1];
                    arr[1] <= arr[2];
                end

                3: 
                begin
                    arr[2] <= arr[0];
                    arr[0] <= arr[2];
                end

                2:
                begin
                    arr[1] <= arr[0];
                    arr[0] <= arr[1];
                end
            endcase
        end
    end
end


always @(posedge CLK or posedge RST) begin
    if(next_state == READ)
    begin
        W <= cnt;
        J <= arr[cnt];
    end
end

//output
always @(posedge CLK or posedge RST) begin
    if(RST)
    begin
        MinCost <= 10'd1023;
        min <= 0;
        MatchCount <= 0;
    end
    else if(state == READ)
    begin
        if(cnt < 9)
            min <= min + Cost;
    end
    else if(state == CAL)
    begin
        min <= 0;
        if(min == MinCost)
        begin
            MatchCount <= MatchCount + 1;
        end
        else if(min < MinCost)
        begin
            MatchCount <= 1;
            MinCost <= min;
        end
    end
end

assign Valid = (state == OUT) ? 1:0;


endmodule


