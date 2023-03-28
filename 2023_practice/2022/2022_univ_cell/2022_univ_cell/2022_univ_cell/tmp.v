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
reg 


reg [6:0]cmp;


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
            IDLE:
                next_state = READ;
            READ:begin
                if() next_state = CAL;
                else next_state = READ;  
            end
            CAL:begin
                if() next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                next_state = READ; 
            default:    next_state = IDLE;
        endcase
    end 
end


assign cmp[0] = arr[0] < arr[1];
assign cmp[1] = arr[1] < arr[2];
assign cmp[2] = arr[2] < arr[3];
assign cmp[3] = arr[3] < arr[4];
assign cmp[4] = arr[4] < arr[5];
assign cmp[5] = arr[5] < arr[6];
assign cmp[6] = arr[6] < arr[7];

always @(*) begin
    casex (cmp)
        7'bxxxxxx1: idx = 6; 
        7'bxxxxx10: idx = 5; 
        7'bxxxx100: idx = 4; 
        7'bxxx1000: idx = 3; 
        7'bxx10000: idx = 2; 
        7'bx100000: idx = 1; 
        7'b1000000: idx = 0; 
        default: idx = 0;
    endcase
end

//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
        //louis
            arr[0] <= 0;
            arr[1] <= 1;
            arr[2] <= 2;
            arr[3] <= 3;
            arr[4] <= 4;
            arr[5] <= 5;
            arr[6] <= 6;
            arr[7] <= 7;
        //


    end
    else begin
        if(next_state == READ)begin


            //Louis
            if(cnt == 0)begin
                sw <= idx +1 ;
                i <= idx +1 ;
            end
            else if(cnt > 0 && cnt < 8)begin //find sw
                if(i > idx && arr[i] > arr[idx] && arr[i]<arr[sw])
                    sw <= i;
                i <= i + 1 ;
            end
            else if(cnt == 8)begin //swap
                arr[sw] <= arr[idx] ;
                arr[idx]<= arr[sw]  ;
            end
            ////////////////////////////////
        end
        else if(next_state == CAL)begin

        end
        else if(next_state == OUT)begin

        end
    end
end





endmodule