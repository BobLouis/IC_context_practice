// `define OUTER(Ax,Ay,Bx,By) (((Ax*By) - (Ay*Bx)) >0 ? 1:0)
// `define OUTER(Ax,Ay,Bx,By) (((Ax*By) - (Ay*Bx)) >0 )

// `define OUTER(Ax,Ay,Bx,By) (($signed({11'd0,Ax})*$signed({11'd0,By})) > ($signed({11'd0,Ay})*$signed({11'd0,Bx})) ? 1:0)
// `define OUTER(Ax,Ay,Bx,By) (({10'd0,Ax*By) - (Ay*Bx))
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

reg [1:0]cnt_div;
reg [2:0]cnt;
reg [9:0]target_x;
reg [9:0]target_y;
reg [9:0]loc_x[0:5]; 
reg [9:0]loc_y[0:5];
reg [5:0]judge;
reg signed[10:0] buf1, buf2;
wire outer_;
reg signed[20:0]mul1,mul2;


// wire signed[19:0]mul1,mul2;
wire [2:0]cal_cnt;
reg signed[10:0] out1, out2, out3, out4;


//set
reg [2:0]cmp1,cmp2;
wire signed [10:0] v1_x,v1_y,v2_x,v2_y;


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
                if(cnt == 3'd7) next_state = SET;
                else next_state = READ;  
            end
            SET:begin
                if(cmp1 == 3'd4 && cmp2 == 3'd5 && cnt_div == 2) next_state = CAL;
                else next_state = SET;  
            end
            CAL:begin
                if(cnt == 3'd6) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:begin
                next_state = READ; 
            end
            default:    next_state = IDLE;
        endcase
    end 
end

//cnt
always@(posedge clk or posedge reset)begin
    if(reset)
        cnt <= 0;
    else if(next_state == READ)
        cnt <= cnt + 3'd1;
    else if(state == CAL && cnt < 3'd6)begin
        if(cnt_div == 2)
            cnt <= cnt + 3'd1;
    end
    else
        cnt <= 0;
end
//cnt_div
always @(posedge clk or posedge reset) begin
    if(reset)begin
        cnt_div <= 0;
    end
    else if(next_state == SET)begin
        if(cnt_div == 2'd2) cnt_div <= 0;
        else cnt_div <= cnt_div + 1;
    end
    else if(next_state == CAL)begin
        if(cnt_div == 2'd2) cnt_div <= 0;
        else cnt_div <= cnt_div + 1;
    end
end

//set cnt
always @(posedge clk or posedge reset) begin
    if(reset)begin
        cmp1 <= 3'd1;
        cmp2 <= 3'd2;
    end
    else if(next_state == SET && cnt_div == 2)begin
        if(cmp2 == 3'd5)begin
            cmp1 <= cmp1 + 3'd1;
            cmp2 <= cmp1 + 3'd2;
        end
        else begin
            cmp2 <= cmp2 + 3'd1;
        end
    end
    else if(cmp1 == 3'd4 && cmp2 == 3'd5 && cnt_div == 2)begin
        cmp1 <= 3'd1;
        cmp2 <= 3'd2;
    end
end

always @(*) begin
    if(next_state == SET || state == SET)begin
        out1 = loc_x[cmp1] - loc_x[0];
        out2 = loc_y[cmp1] - loc_y[0];
        out3 = loc_x[cmp2] - loc_x[0];
        out4 = loc_y[cmp2] - loc_y[0];
    end
    else begin
        out1 = loc_x[cnt] - target_x;
        out2 = loc_y[cnt] - target_y;
        out3 = loc_x[cal_cnt] - loc_x[cnt];
        out4 = loc_y[cal_cnt] - loc_y[cnt];
    end
end

always @(*) begin
    //set
    if(next_state == SET || state == SET)begin
        if(cnt_div == 0)begin
            buf1 = out1;
            buf2 = out4;
        end
        else begin
            buf1 = out2;
            buf2 = out3;
        end
    end
    else begin
        //cal
        if(cnt_div == 0)begin
            buf1 = out1;
            buf2 = out4;
        end
        else begin
            buf1 = out2;
            buf2 = out3;
        end
    end
end


// always @(posedge clk) begin
//     if(next_state == SET || state == SET)begin
//         out1 = loc_x[cmp1] - loc_x[0];
//         out2 = loc_y[cmp1] - loc_y[0];
//         out3 = loc_x[cmp2] - loc_x[0];
//         out4 = loc_y[cmp2] - loc_y[0];
//     end
//     else begin
//         out1 = loc_x[cnt] - target_x;
//         out2 = loc_y[cnt] - target_y;
//         out3 = loc_x[cal_cnt] - loc_x[cnt];
//         out4 = loc_y[cal_cnt] - loc_y[cnt];
//     end
// end

//DATA INPUT AND SET
always@(posedge clk)begin
    if(next_state == READ)begin
        if(cnt == 0)begin
            target_x <= X;
            target_y <= Y;
        end
        else begin
            loc_x[cnt - 3'd1] <= X;        
            loc_y[cnt - 3'd1] <= Y;
        end
    end
    else if((next_state == SET || state == SET) && cnt_div == 2) begin
        if( outer_== 0) begin
            //swap
            loc_x[cmp1] <= loc_x[cmp2];
            loc_x[cmp2] <= loc_x[cmp1];
            loc_y[cmp1] <= loc_y[cmp2];
            loc_y[cmp2] <= loc_y[cmp1];
        end
    end 
end

//CAL_RESULT OUT
assign cal_cnt = (cnt < 3'd5) ? cnt + 3'd1 : 0;
// assign  outer_ = `OUTER(out1  , out2  , out3, out4);
// assign outer_ = (((out1*out4) - (out2*out3)) >0 );//ALL PASS

wire signed[20:0] mul;
assign mul = buf1 * buf2;

always @(posedge clk) begin
    if(cnt_div==0)
        mul1 <= mul;
    else 
        mul2 <= mul;
end
// assign mul1 = (out1*out4);
// assign mul2 = (out2*out3);
assign outer_ = (mul1 > mul2);
// assign outer_ = ((out1*out4) - (out2*out3));


//CAL
always@(posedge clk or posedge reset)begin
    if(reset)
        judge <= 0;
    else if(state == CAL)
        judge[cnt] <= outer_;
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