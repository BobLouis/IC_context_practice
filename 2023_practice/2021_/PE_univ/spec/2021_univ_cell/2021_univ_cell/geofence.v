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

reg [2:0] cnt;
reg [9:0] tmp_x[0:5];
reg [9:0] tmp_y[0:5];

reg [9:0] buf1;
reg [9:0] buf2;

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
                if(cnt == 7) next_state = SORTING;
                else next_state = READ;  
            end
            SORTING:begin


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
    end
    else begin
        if(next_state == READ) begin
            tmp_x[cnt] <= X;
            tmp_y[cnt] <= Y;
            cnt <= cnt + 1;
        end
    end
end


endmodule

