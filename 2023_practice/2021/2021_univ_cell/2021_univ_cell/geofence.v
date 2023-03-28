module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output is_inside;

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
      TRANS_1 = 3'd6,
      SORTING = 3'd2,
      TRANS = 3'd5,
	  CAL = 3'd3,
	  OUT = 3'd4;

reg [2:0]cnt;
reg [2:0]idx;
reg [2:0]sort_idx;
reg [2:0]cal_cnt;
reg [9:0]X_data[0:5];
reg [9:0]Y_data[0:5];

reg [9:0]target_x, target_y;

wire [9:0]X_ = (next_state == SORTING)? X_data[0]:target_x;
wire [9:0]Y_ = (next_state == SORTING)? Y_data[0]:target_y;

wire signed[10:0] ax = X_data[idx] - X_;
wire signed[10:0] ay = Y_data[idx] - Y_;
wire signed[10:0] bx = X_data[idx+1] - X_;
wire signed[10:0] by = Y_data[idx+1] - Y_;

reg signed [21:0] mul1, mul2;
reg signed [21:0] buf1, buf2;
wire signed [21:0] mul = mul1 * mul2;


reg [5:0]judge;

assign is_inside = &judge | &(~judge);

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
                if(cnt == 7) next_state = TRANS_1;
                else next_state = READ;  
            end
            TRANS_1: next_state = SORTING;
            SORTING:begin
                if(sort_idx == 0) next_state = TRANS;
                else next_state = SORTING;
            end
            TRANS:
                next_state = CAL;
            CAL:begin
                if(idx == 6) next_state = OUT;
                else next_state = CAL;
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
        cnt <= 0;
        valid <= 0;
        idx <= 1;
        sort_idx <= 4;
        judge <= 0;
        cal_cnt <= 0;
        buf1 <= 0;
        buf2 <= 0;
    end
    else begin
        if(next_state == READ)begin
            valid <= 0;
            judge <= 0;
            if(cnt == 0)begin
                target_x <= X;
                target_y <= Y;
            end
            else begin
                X_data[cnt-1] <= X;
                Y_data[cnt-1] <= Y;
            end
            cnt <= cnt + 1;
        end
        else if(next_state == TRANS_1)
            cnt <= 0;
        else if(next_state == SORTING)begin
            case(cnt)
                0:begin
                    mul1 <= ax;
                    mul2 <= by;
                    cnt <= 1;
                end
                1:begin
                    mul1 <= bx;
                    mul2 <= ay;
                    buf1 <= mul;
                    cnt <= 2;
                end
                2:begin
                    if(buf1 > mul)begin
                        X_data[idx] <= X_data[idx+1];
                        X_data[idx+1] <= X_data[idx];
                        Y_data[idx] <= Y_data[idx+1];
                        Y_data[idx+1] <= Y_data[idx];
                    end

                    if(idx == sort_idx)begin
                        sort_idx <= sort_idx - 1;
                        idx <= 1;
                    end
                    else begin
                        idx <= idx + 1;
                    end

                    cnt <= 0;
                end
            endcase
        end
        else if(next_state == TRANS)begin
            idx <= 0;
        end
        else if(next_state == CAL)begin
            case(cnt) 
                0:begin
                    mul1 <= ax;
                    mul2 <= by;
                    cnt <= 1;
                end
                1:begin
                    mul1 <= bx;
                    mul2 <= ay;
                    buf1 <= mul;
                    cnt <= 2;
                end
                2:begin
                    if(buf1 > mul)begin
                       judge[idx] <= 1;
                    end
                    
                    idx <= idx + 1;
                    cnt <= 0;
                end
            endcase
        end
        else if(next_state == OUT)begin
            valid <= 1;
            cnt <= 0;
            idx <= 1;
            sort_idx <= 4;
        end
    end
end


endmodule

