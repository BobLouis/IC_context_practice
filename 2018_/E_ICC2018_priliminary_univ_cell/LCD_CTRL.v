module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output IROM_rd;
output [5:0] IROM_A;
output IRAM_valid;
output [7:0] IRAM_D;
output [5:0] IRAM_A;
output busy;
output done;

reg [2:0]state;
reg [2:0]next_state;

reg [2:0] x;
reg [2:0] y;

reg [7:0] data [0:63];
reg [5:0] cnt;
parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter CMD  = 3'd2;
parameter WRITE = 3'd3;
parameter DONE = 3'd4;

always @(posedge clk or posedge reset) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE:
        begin
            next_state = READ;
        end
        READ:
        begin
            if(cnt == 6'd63) next_state = CMD;
            else next_state = READ;
        end
        CMD:
        begin
            if(cmd_valid && cmd == 0) next_state = WRITE;
            else next_state = CMD;
        end
        WRITE:
        begin
            if(cnt == 6'd63) next_state = DONE;
            else next_state = WRITE;
        end
        DONE:
        begin
            next_state = DONE;
        end
        default:    next_state = IDLE;
    endcase
end

//cnt
always @(posedge clk or posedge reset) begin
    if(reset) cnt <= 0;
    else if(state == READ) cnt <= cnt + 1;
    else if(state == CMD) cnt <= 0;
    else if(state == WRITE) cnt <= cnt + 1;
end



//min max 
wire [2:0] y_1 = y-1;
wire [2:0] x_1 = x-1;
wire [5:0]loc1 = {y_1, x_1};
wire [5:0]loc2 = {y_1,x};
wire [5:0]loc3 = {y,x_1};
wire [5:0]loc4 = {y,x};
wire [7:0]min1 = data[loc1];
wire [7:0]min2 = data[loc2];
wire [7:0]min3 = data[loc3];
wire [7:0]min4 = data[loc4];

wire [7:0]min5 = (min1<min2)?min1:min2;
wire [7:0]min6 = (min3<min4)?min3:min4;
wire [7:0]min  = (min5<min6)?min5:min6;

wire [7:0]max1 = data[loc1];
wire [7:0]max2 = data[loc2];
wire [7:0]max3 = data[loc3];
wire [7:0]max4 = data[loc4];

wire [7:0]max5 = (max1>max2)?max1:max2;
wire [7:0]max6 = (max3>max4)?max3:max4;
wire [7:0]max  = (max5>max6)?max5:max6;

wire [9:0]avg_sum = data[loc1]+data[loc2]+data[loc3]+data[loc4];
wire [7:0]avg = avg_sum[9:2];



//data x y
// 1 <= x <= 7
// 1 <= y <= 7

always @(posedge clk) begin
    if(reset)
    begin
        x <= 4;
        y <= 4;
    end

    if(state == READ)
    begin
        data[cnt] <= IROM_Q;
    end
    else if(state == CMD)
    begin
        case(cmd)
            4'd1: //shift up 
            begin
                if(y > 1) y <= y - 1;
            end
            4'd2: //shift down
            begin
                if(y < 7) y <= y + 1;
            end
            4'd3: //shift left
            begin
                if(x > 1) x <= x - 1;
            end
            4'd4: //shift right
            begin
                if(x < 7) x <= x + 1;
            end
            4'd5: //MAX
            begin
                data[loc1] <= max;
                data[loc2] <= max;
                data[loc3] <= max;
                data[loc4] <= max;
            end
            4'd6: //Min
            begin
                data[loc1] <= min;
                data[loc2] <= min;
                data[loc3] <= min;
                data[loc4] <= min;
            end
            4'd7: //average
            begin
                data[loc1] <= avg;
                data[loc2] <= avg;
                data[loc3] <= avg;
                data[loc4] <= avg;
            end
            4'd8: //counter clock wise
            begin
                data[loc1] <= data[loc2];
                data[loc2] <= data[loc4];
                data[loc3] <= data[loc1];
                data[loc4] <= data[loc3];
            end
            4'd9: //clockwise
            begin
                data[loc1] <= data[loc3];
                data[loc2] <= data[loc1];
                data[loc3] <= data[loc4];
                data[loc4] <= data[loc2];
            end
            4'd10: //Mirror X
            begin
                data[loc1] <= data[loc3];
                data[loc2] <= data[loc4];
                data[loc3] <= data[loc1];
                data[loc4] <= data[loc2];
            end
            4'd11: //shift down
            begin
                data[loc1] <= data[loc2];
                data[loc2] <= data[loc1];
                data[loc3] <= data[loc4];
                data[loc4] <= data[loc3];
            end
        endcase
    end
end

//read daata
// output reg IROM_rd;
assign IROM_A = cnt;
assign IROM_rd = (state == READ)?1:0;

assign IRAM_valid = (state == WRITE)?1:0;
assign IRAM_D = data[cnt];
assign IRAM_A = cnt;
assign done = (state == DONE)?1:0;


//busy
assign busy = (state == IDLE || state == READ || state == WRITE)?1:0;



endmodule