module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output valid;
output is_inside;
//reg valid;
//reg is_inside;

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
      SORTING = 3'd2,
	  CAL = 3'd3,
	  OUT = 3'd4;

reg [2:0] sort_cnt;
reg [2:0] cnt;
reg [9:0] tmp_x[0:5];
reg [9:0] tmp_y[0:5];
reg [9:0] target_x;
reg [9:0] target_y;

reg signed [9:0] A_x;
reg signed [9:0] A_y;
reg signed [9:0] B_x;
reg signed [9:0] B_y;

reg signed [9:0] buf1;
reg signed [9:0] buf2;
reg signed [19:0] tmp1;
reg signed [19:0] tmp2;

reg done;

wire signed [19:0]mul;

assign mul = buf1 * buf2;

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
                if(done == 1) next_state = SORTING;
                else next_state = READ;  
            end
            SORTING:begin
                if() next_state = CAL;
                else next_state = SORTING;
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


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
        cnt <= 0;
        done <= 0;
        sort_cnt <= 0;
    end
    else begin
        if(next_state == READ) begin
            if(cnt == 0)begin
                target_x <= X;
                target_y <= Y;
            end
            else begin
                tmp_x[cnt-1] <= X;
                tmp_y[cnt-1] <= Y;
            end
            if(cnt < 6)
                cnt <= cnt + 1;
            else begin
                cnt <= 0;
                done <= 1;
            end
        end
        else if(next_state == SORTING)begin
            case(cnt)
                0:begin
                    A_x <= tmp_x[sort_cnt+1] - tmp_x[sort_cnt];    //
                    A_y <= tmp_y[sort_cnt+1] - tmp_y[sort_cnt];    //
                    B_x <= tmp_x[sort_cnt+2] - tmp_x[sort_cnt];    //
                    B_y <= tmp_y[sort_cnt+2] - tmp_y[sort_cnt];    //
                    cnt <= cnt + 1;
                end
                1:begin
                    
                    cnt <= cnt + 1;
                end
                2:begin
                    buf1 <= ;
                    buf2 <= ;

                end
                3:begin
                    if(tmp > mul)begin
                        cnt <= 7;
                    end
                    else 
                        cnt <= 0;
                end
                4:begin
                    

                end
                4:begin


                end
                7:begin
                    tmp_x[sort_cnt] <= tmp_x[sort_cnt+1];
                    tmp_x[sort_cnt+1] <= tmp_x[sort_cnt];
                    tmp_y[sort_cnt] <= tmp_y[sort_cnt+1];
                    tmp_y[sort_cnt+1] <= tmp_y[sort_cnt];
                    sort_cnt <= sort_cnt + 1;
                end
            endcase
        end
    end
end

endmodule

