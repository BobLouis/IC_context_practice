`define OUTER(Ax,Ay,Bx,By) (((Ax*By) > (Ay*Bx)) ? 1:0)

module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output is_inside;

reg [2:0]state, next_state;
parameter IDLE = 3'b000;
parameter READ = 3'b001;
parameter SET = 3'b010;
parameter CAL = 3'b011;
parameter OUT = 3'b100;

reg [2:0]counter;
reg [2:0]cal_cnt;
reg [9:0]target_x;
reg [9:0]target_y;
reg [9:0]loc_x[0:5]; 
reg [9:0]loc_y[0:5];
reg [5:0]judge;
wire outer_tmp;

//set
reg [2:0]cmp1,cmp2;
wire signed [9:0] v1_x,v1_y,v2_x,v2_y;


always@(posedge clk or posedge reset)begin
    if(reset)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(reset)
        next_state <= IDLE;
    else begin
        case(state)
            IDLE:
                next_state = READ;
            READ:begin
                if(counter == 7) next_state = SET;
                else next_state = READ;  
            end
            SET:begin
                if(cmp1 == 3'd4 && cmp2 == 3'd5) next_state = CAL;
                else next_state = SET;  
            end
            CAL:begin
                if(cal_cnt == 6) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:begin
                next_state = READ; 
            end
            default:    next_state = IDLE;
        endcase
    end 
end

//COUNTER
always@(posedge clk or posedge reset)begin
    if(reset)
        counter <= 0;
    else begin
        if(next_state == SET)
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

//set counter
always @(posedge clk or posedge reset) begin
    if(reset)begin
        cmp1 <= 3'd1;
        cmp2 <= 3'd2;
    end
    else if(next_state == SET)begin
        if(cmp2 == 3'd5)begin
            cmp1 <= cmp1 + 3'd1;
            cmp2 <= cmp1 + 3'd2;
        end
        else begin
            cmp2 <= cmp2 + 3'd1;
        end
    end
end



assign v1_x = loc_x[0] - loc_x[cmp1];
assign v1_y = loc_y[0] - loc_y[cmp1];
assign v2_x = loc_x[0] - loc_x[cmp2];
assign v2_y = loc_y[0] - loc_y[cmp2];



//DATA INPUT AND SET
always@(posedge clk)begin
    if(next_state == READ)begin
        if(counter == 0)begin
            target_x <= X;
            target_y <= Y;
        end
        else begin
            loc_x[counter-1] <= X;        
            loc_y[counter-1] <= Y;
        end
    end
    else if(state == SET) begin
        if( (`OUTER(v1_x,v1_y,v2_x,v2_y)) == 0) begin
            //swap
            loc_x[cmp1] <= loc_x[cmp2];
            loc_x[cmp2] <= loc_x[cmp1];
            loc_y[cmp1] <= loc_y[cmp2];
            loc_y[cmp2] <= loc_y[cmp1];
        end
    end 
end

//CAL_CNT
always @(posedge clk or posedge reset) begin
    if(reset)
        cal_cnt <= 0;
    else begin
        if(next_state == OUT)
            cal_cnt <= 0;
        else
            cal_cnt <= cal_cnt + 1;
    end
end

assign  outer_tmp = `OUTER(target_x, target_y, loc_x[cal_cnt], loc_y[cal_cnt]);


always@(posedge clk or posedge reset)begin
    if(reset)
        judge <= 0;
    else if(next_state == CAL)
        judge[cal_cnt] <= outer_tmp;
end

//RESULT
assign  is_inside = &judge || &(~judge);


//OUTPUT
always @(*) begin
    if(next_state == OUT)
        valid = 1'b1;
    else 
        valid = 0;
end

endmodule