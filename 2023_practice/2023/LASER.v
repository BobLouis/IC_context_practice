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
reg [5:0] max_cnt2;
reg [5:0] dot_cnt;
reg [5:0] dot_cnt2;
reg [4:0] max_x1, max_y1, max_x2, max_y2;
reg CIR1_flag;

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
      TRANS_READ = 3'd6,
      CIR1 = 3'd2,
      TRANS = 3'd3,
      CIR2 = 3'd4,
	  OUT = 3'd5;
      

reg [3:0] x_loc, y_loc;
wire [7:0] loc = {y_loc, x_loc};


reg [3:0] mul1, mul2;
reg [3:0] mul3, mul4;
wire [8:0]mul = mul1 * mul1 + mul2 * mul2;
wire [8:0]mul_ = mul3 * mul3 + mul4 * mul4;

wire in_2cir = (mul <= 16) || (mul_ <= 16);

assign C1X = max_x1;
assign C1Y = max_y1;
assign C2X = max_x2;
assign C2Y = max_y2;

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
                if(x_loc == 0 && y_loc == 0 && CIR1_flag == 1)next_state= TRANS;
                else next_state = CIR1;
            end
            TRANS:  next_state = CIR2;
            CIR2:begin
                if(x_loc == 0 && y_loc == 0 && CIR1_flag == 1 )next_state= OUT;
                else next_state = CIR2;
            end
            OUT:
                next_state = READ; 
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
        max_cnt2 <= 0;
        dot_cnt <= 0;
        dot_cnt2 <= 0;
        CIR1_flag <= 0;
        max_x1 <= 0;
        max_y1 <= 0;
        max_x2 <= 0;
        max_y2 <= 0;
        mul1 <= 0;
        mul2 <= 0;
        mul3 <= 0;
        mul4 <= 0;
    end
    else begin
        if(next_state == READ)begin
            DONE <= 0;
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

            if(cnt == 41)begin
                cnt <= 0;
                if(dot_cnt > max_cnt)begin
                    max_cnt <= dot_cnt;
                    max_x1 <= x_loc;
                    max_y1 <= y_loc;
                end

                x_loc <= x_loc + 1;
                if(x_loc == 15)begin
                    y_loc <= y_loc + 1;
                    CIR1_flag <= 1;
                end

                dot_cnt <= 0;
            end
            else if(cnt > 0)begin //1~40
                if(mul <= 16)begin
                    dot_cnt <= dot_cnt + 1;
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
        end
        else if(next_state == CIR2)begin
            mul1 <= `abs(X_data[cnt], max_x1);
            mul2 <= `abs(Y_data[cnt], max_y1);
            mul3 <= `abs(X_data[cnt], x_loc); //cir2
            mul4 <= `abs(Y_data[cnt], y_loc);

            if(cnt == 41)begin
                cnt <= 0;
                if(dot_cnt2 > max_cnt2)begin
                    max_cnt2 <= dot_cnt2;
                    max_x2 <= x_loc;
                    max_y2 <= y_loc;
                end

                x_loc <= x_loc + 1;
                if(x_loc == 15)begin
                    y_loc <= y_loc + 1;
                    CIR1_flag <= 1;
                end

                dot_cnt2 <= 0;
            end
            else if(cnt > 0)begin //1~40
                if(in_2cir)begin
                    dot_cnt2 <= dot_cnt2 + 1;
                end
                cnt <= cnt + 1;
            end
            else 
                cnt <= cnt + 1;
            
        end
        else if(next_state == OUT)begin
            DONE <= 1;
            cnt <= 63;
            
        end
    end
end

endmodule

