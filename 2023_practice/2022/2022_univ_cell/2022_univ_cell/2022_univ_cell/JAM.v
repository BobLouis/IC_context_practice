module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
	  CAL = 3'd2,
	  OUT = 3'd3;

reg [2:0]arr[0:7];
reg [3:0]cnt;
reg [9:0]min;
wire [6:0]cmp;
reg [2:0]i,sw,idx,idx_;
integer j;
always@(posedge CLK or posedge RST)begin
    if(RST)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(RST)
        next_state = IDLE;
    else begin
        case(state)
            IDLE:
                next_state = READ;
            READ:begin
                if(cnt == 8) next_state = CAL;
                else next_state = READ;  
            end
            CAL:begin
                if(arr[0] == 7 && arr[1] == 6 && arr[2] == 5 && arr[3] == 4 && arr[4] == 3 && arr[5] == 2 && arr[6] == 1 && arr[7] == 0) next_state = OUT;
                else next_state = READ;
            end 
            default:    next_state = IDLE;
        endcase
    end 
end
assign cmp[0] = (arr[0] < arr[1]);
assign cmp[1] = (arr[1] < arr[2]);
assign cmp[2] = (arr[2] < arr[3]);
assign cmp[3] = (arr[3] < arr[4]);
assign cmp[4] = (arr[4] < arr[5]);
assign cmp[5] = (arr[5] < arr[6]);
assign cmp[6] = (arr[6] < arr[7]);

always @(*) begin
    casex (cmp)
        7'b1xxxxxx: idx = 6; 
        7'b01xxxxx: idx = 5; 
        7'b001xxxx: idx = 4; 
        7'b0001xxx: idx = 3; 
        7'b00001xx: idx = 2; 
        7'b000001x: idx = 1; 
        7'b0000001: idx = 0; 
        default: idx = 0;
    endcase
end
//DATA INPUT
always@(posedge CLK or posedge RST)begin
    if(RST)begin
        MatchCount <= 0;
        MinCost <= 10'b1111111111;
        cnt <= 0;
        W <= 0;
        J <= 0;
        min <= 0;
        Valid <= 0;
        for(j=0;j<8;j=j+1)
            arr[j] <= j;

        sw <= 0;
        i  <= 0;
    end
    else begin
        if(next_state == READ)begin
            W <= cnt;
            J <= arr[cnt];
            cnt <= cnt + 1;
            
            if(cnt == 0)begin
                sw <= idx + 1 ;
                i <= idx + 2 ;
                idx_ <= idx;
            end
            else if(cnt > 0 && cnt < 7)begin //find sw
                if(i > idx_ && arr[i] > arr[idx_] && arr[i]<arr[sw])
                    sw <= i;
                i <= i + 1 ;
                min <= min + Cost;
            end
            else if(cnt == 7)begin //swap
                arr[sw] <= arr[idx_] ;
                arr[idx_]<= arr[sw]  ;
                min <= min + Cost;
            end
        end
        else if(next_state == CAL)begin
            case(idx_)
                0:begin
                    arr[1] <= arr[7];
                    arr[7] <= arr[1];
                    arr[2] <= arr[6];
                    arr[6] <= arr[2];
                    arr[3] <= arr[5];
                    arr[5] <= arr[3];
                end
                1:begin
                    arr[2] <= arr[7];
                    arr[7] <= arr[2];
                    arr[3] <= arr[6];
                    arr[6] <= arr[3];
                    arr[4] <= arr[5];
                    arr[5] <= arr[4];
                end
                2:begin
                    arr[3] <= arr[7];
                    arr[7] <= arr[3];
                    arr[4] <= arr[6];
                    arr[6] <= arr[4];
                end
                3:begin
                    arr[4] <= arr[7];
                    arr[7] <= arr[4];
                    arr[5] <= arr[6];
                    arr[6] <= arr[5];
                end
                4:begin
                    arr[5] <= arr[7];
                    arr[7] <= arr[5];
                end
                5:begin
                    arr[6] <= arr[7];
                    arr[7] <= arr[6];
                end
            endcase
            if(MinCost == min)
                MatchCount <= MatchCount + 1;
            else if(min < MinCost)begin
                MinCost <= min;
                MatchCount <= 1;
            end
            min <= 0;
            cnt <=0;
        end
        else if(next_state == OUT)begin
            Valid <= 1;
        end
    end
end


endmodule



