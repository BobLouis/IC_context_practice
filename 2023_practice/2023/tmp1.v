`define PATH 3
`define abs(a,b) ((a>b) ? (a-b) : (b-a))
module LASER (
input CLK,
input RST,
input [3:0] X,
input [3:0] Y,
output [3:0] C1X,
output [3:0] C1Y,
output [3:0] C2X,
output [3:0] C2Y,
output reg DONE);

reg [3:0] X_data[0:39];
reg [3:0] Y_data[0:39];

reg [5:0] cnt;
reg [5:0] max_cnt;
reg [5:0] dot_cnt;
reg [4:0] max_x1, max_y1, max_x2, max_y2;
reg CIR1_flag;



reg [3:0]state, next_state;
parameter IDLE = 4'd0,
	  READ = 4'd1,
      TRANS_READ = 4'd2,
      CIR1 = 4'd3,
      TRANS = 4'd4,
      CIR2 = 4'd5,
      TRANS2 = 4'd6,
      ITER = 4'd7,
	  OUT = 4'd8;
      

reg C1_done, C2_done;

reg [3:0] x_loc, y_loc;
reg [2:0]iter;

reg [3:0] mul1, mul2, mul3, mul4;
reg [3:0] mul1k, mul2k, mul3k, mul4k;
wire [8:0]mul = mul1 * mul1 + mul2 * mul2;
wire [8:0]mul_ = mul3 * mul3 + mul4 * mul4;

wire [8:0]mulk = mul1k * mul1k + mul2k * mul2k;
wire [8:0]mul_k = mul3k * mul3k + mul4k * mul4k;

wire in_cir1 = (mul <= 16);
wire in_cir2 = (mul_ <= 16);
wire in_2cir = in_cir1 | in_cir2;

wire in_cir1k = (mulk <= 16);
wire in_cir2k = (mul_k <= 16);
wire in_2cirk = in_cir1k | in_cir2k;

assign C1X = max_x1;
assign C1Y = max_y1;
assign C2X = max_x2;
assign C2Y = max_y2;

reg [3:0]x1_tmp, y1_tmp, x2_tmp, y2_tmp;

wire [3:0]x2_li = (x2_tmp  > 11) ? 15: (x2_tmp + `PATH);
wire [3:0]x1_li = (x1_tmp  > 11) ? 15: (x1_tmp + `PATH);
wire [3:0]y2_li = (y2_tmp  > 11) ? 15: (y2_tmp + `PATH);
wire [3:0]y1_li = (y1_tmp  > 11) ? 15: (y1_tmp + `PATH);

wire [3:0]x2_lilo = (x2_tmp < `PATH) ? 0 : x2_tmp - `PATH;
wire [3:0]x1_lilo = (x1_tmp < `PATH) ? 0 : x1_tmp - `PATH;

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
                if(cnt == 40) next_state = TRANS_READ;
                else next_state = READ;  
            end
            TRANS_READ: next_state = CIR1;
            CIR1:begin
                if(C1_done)next_state = TRANS;
                else if(x_loc == 0 && y_loc == 0 && CIR1_flag == 1)next_state= TRANS;
                else next_state = CIR1;
            end
            TRANS:  next_state = CIR2;
            CIR2:begin
                if(C2_done)next_state = TRANS2;
                else if(x_loc == 0 && y_loc == 0 && CIR1_flag == 1 )next_state= TRANS2;
                else next_state = CIR2;
            end
            TRANS2:begin
                if(iter == 3) next_state = OUT;
                else next_state = CIR1;
            end
            OUT:
                next_state = IDLE; 
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge CLK or posedge RST)begin
    if(RST)begin
        DONE <= 0;
        cnt <= 0;
        x_loc <= 0;
        y_loc <= 0;
        max_cnt <= 0;
        dot_cnt <= 0;
        CIR1_flag <= 0;
        max_x1 <= 0;
        max_y1 <= 0;
        max_x2 <= 0;
        max_y2 <= 0;
        mul1 <= 0;
        mul2 <= 0;
        mul3 <= 0;
        mul4 <= 0;
        iter <= 0;
        C1_done <= 0;
        C2_done <= 0;
        x1_tmp <= 0;
        y1_tmp <= 0;
        x2_tmp <= 0;
        y2_tmp <= 0;
    end
    else begin
        if(next_state == IDLE)begin
            DONE <=0;
            cnt <= 0;
            max_cnt <= 0;
            dot_cnt <= 0;
            CIR1_flag <= 0;
            iter <= 0;
            C1_done <= 0;
            C2_done <= 0;
        end
        else if(next_state == READ)begin
            X_data[cnt] <= X;
            Y_data[cnt] <= Y;
            cnt <= cnt + 1;
            x_loc <= 0;
            y_loc <= 0;
            max_cnt <= 0;
            CIR1_flag <= 0;
            
        end
        else if(next_state == TRANS_READ)begin
            cnt <= 0;   //0~39
        end
        else if(next_state == CIR1)begin

            mul1 <= `abs(X_data[cnt], x_loc);
            mul2 <= `abs(Y_data[cnt], y_loc);
            mul3 <= `abs(X_data[cnt], max_x2); //cir2
            mul4 <= `abs(Y_data[cnt], max_y2);


            if(cnt == 41)begin
                cnt <= 0;
                dot_cnt <= 0;
                if(dot_cnt  >= max_cnt )begin
                    max_cnt <= dot_cnt;
                    max_x1 <= x_loc;
                    max_y1 <= y_loc;
                end

                if(iter == 0)begin
                    x_loc <= x_loc + 1;
                    if(x_loc == 15)begin
                        y_loc <= y_loc + 1;
                        CIR1_flag <= 1;
                    end
                end
                else begin
                    if(y_loc == y1_li)begin
                        C1_done <= 1;
                    end
                    else if(x_loc == x1_li)begin
                        y_loc <= y_loc + 1;
                        x_loc <= x1_lilo;
                    end
                    else if(x_loc < x1_li)begin
                        x_loc <= x_loc + 1;
                    end
                end
            end
            else if(cnt > 0)begin //1~40
                if(iter == 0)begin
                    if(in_cir1)begin
                        dot_cnt <= dot_cnt + 1;
                    end
                end
                else begin
                    if(in_2cir)begin
                        dot_cnt <= dot_cnt + 1;
                    end
                end
                cnt <= cnt + 1;
            end
            else 
                cnt <= cnt + 1;

        end
        else if(next_state == TRANS)begin
            x_loc <= 0;
            y_loc <= 0;
            CIR1_flag <= 0;
            C1_done <= 0;
            if(iter != 0)
            begin
                if(max_x2 >= `PATH)
                    x_loc <= max_x2 -`PATH;
                if(max_y2 >= `PATH)
                    y_loc <= max_y2 -`PATH;
            end
        end
        else if(next_state == CIR2)begin
            mul1 <= `abs(X_data[cnt], max_x1);
            mul2 <= `abs(Y_data[cnt], max_y1);
            mul3 <= `abs(X_data[cnt], x_loc); //cir2
            mul4 <= `abs(Y_data[cnt], y_loc);

            if(cnt == 41)begin
                cnt <= 0;
                if(dot_cnt >= max_cnt)begin
                    max_cnt <= dot_cnt;
                    max_x2 <= x_loc;
                    max_y2 <= y_loc;
                end

                if(iter == 0)begin
                    x_loc <= x_loc + 1;
                    if(x_loc == 15)begin
                        y_loc <= y_loc + 1;
                        CIR1_flag <= 1;
                    end
                end
                else begin
                    if(y_loc== y2_li)begin
                        C2_done <= 1;
                    end
                    else if(x_loc == x2_li)begin
                        y_loc <= y_loc + 1;
                        x_loc <= x2_lilo;
                    end
                    else if(x_loc < x2_li)begin
                        x_loc <= x_loc + 1;
                    end
                end

                dot_cnt <= 0;
            end
            else if(cnt > 0)begin //1~40
                if(in_2cir)begin
                    dot_cnt <= dot_cnt + 1;
                end

                cnt <= cnt + 1;
            end
            else 
                cnt <= cnt + 1;
            
        end
        else if(next_state == TRANS2)begin
            cnt <= 0;
            x_loc <= 0;
            y_loc <= 0;
            CIR1_flag <= 0;
            iter <= iter + 1;
            C2_done <= 0;

            if(max_x1 >= `PATH)
                x_loc <= max_x1 -`PATH;
            if(max_y1 >= `PATH)
                y_loc <= max_y1 -`PATH;

            x1_tmp <= max_x1;
            y1_tmp <= max_y1;
            x2_tmp <= max_x2;
            y2_tmp <= max_y2;
            
        end
        else if(next_state == OUT)begin
            DONE <= 1;
            cnt <= 0;
            
        end
    end
end

endmodule


