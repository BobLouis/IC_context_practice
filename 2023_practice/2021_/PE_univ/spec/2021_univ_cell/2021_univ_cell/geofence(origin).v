module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output is_inside;
//reg is_inside;

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
      SORTING = 3'd2,
	  CAL = 3'd3,
	  OUT = 3'd4,
      BUFFF = 3'd5;

reg [2:0] sort_cnt;
reg [2:0] cnt;
reg [9:0] tmp_x[0:5];
reg [9:0] tmp_y[0:5];
reg [9:0] target_x;
reg [9:0] target_y;
reg [2:0] sort_idx;

reg signed [10:0] buf1;
reg signed [10:0] buf2;
reg signed [21:0] tmp;

reg [2:0] cnt_dot;

reg done;

wire signed [21:0]mul;

assign mul = buf1 * buf2;

reg signed [19:0]mul1;
reg signed [19:0]mul2;
reg [5:0] result;

wire out_;
assign out_ = (mul1 > mul2);
assign is_inside = &result | &(~result);

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
                if(sort_idx == 0) next_state = CAL;
                else next_state = SORTING;
            end
            CAL:begin
                if(cnt_dot == 6) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                next_state = BUFFF;
            BUFFF:
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
        sort_cnt <= 1;
        sort_idx <= 4;
        cnt_dot <= 0;
        valid <= 0;
    end
    else begin
        if(next_state == READ) begin
            valid <= 0;
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
            done <= 0;
            case(cnt)
                0:begin
                    buf1 <= tmp_x[sort_cnt] - tmp_x[0];       
                    buf2 <= tmp_y[sort_cnt+1] - tmp_y[0];    
                    cnt <= cnt + 1;
                end
                1:begin
                    tmp <= mul;
                    buf2 <= tmp_y[sort_cnt] - tmp_y[0];    
                    buf1 <= tmp_x[sort_cnt+1] - tmp_x[0]; 
                    cnt <= cnt + 1;
                end
                2:begin
                    if(tmp > mul)begin
                        cnt <= 3;
                    end
                    else begin
                        if(sort_cnt == sort_idx) begin
                            sort_idx <= sort_idx - 1;
                            sort_cnt <= 1;
                        end
                        else 
                            sort_cnt <= sort_cnt + 1;
                        cnt <= 0;
                    end
                end
                3:begin
                    tmp_x[sort_cnt] <= tmp_x[sort_cnt+1];
                    tmp_x[sort_cnt+1] <= tmp_x[sort_cnt];
                    tmp_y[sort_cnt] <= tmp_y[sort_cnt+1];
                    tmp_y[sort_cnt+1] <= tmp_y[sort_cnt];
                    if(sort_cnt == sort_idx) begin
                            sort_idx <= sort_idx - 1;
                            sort_cnt <= 1;
                    end
                    else 
                        sort_cnt <= sort_cnt + 1;
                    cnt <= 0;
                end
            endcase
        end
        else if(next_state == CAL)
        begin

            if(cnt == 0)
            begin
                buf1 <= tmp_x[cnt_dot] - target_x;
                if(cnt_dot == 5)
                    buf2 <= tmp_y[0] - target_y;
                else
                    buf2 <= tmp_y[cnt_dot+1] - target_y;
            end
            else if(cnt == 1)
            begin
                tmp <= mul;
                if(cnt_dot == 5)
                    buf1 <= tmp_x[0] - target_x;
                else
                    buf1 <= tmp_x[cnt_dot+1] - target_x;
                buf2 <= tmp_y[cnt_dot] - target_y;
            end
            else if(cnt == 2)
            begin
                result[cnt_dot] <= (tmp > mul);
                cnt_dot <= cnt_dot + 1;
            end



            if(cnt < 2)
            begin
                cnt <= cnt + 1;
            end
            else 
                cnt <= 0;
        end
        else if(next_state == OUT)
        begin
            sort_idx <= 4;
            sort_cnt <= 1;
            cnt_dot <= 0;
            cnt <= 0;
            valid <= 1;
        end
    end
end

endmodule

