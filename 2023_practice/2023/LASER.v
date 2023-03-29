module LASER (
input CLK,
input RST,
input [3:0] X,
input [3:0] Y,
output reg [3:0] C1X,
output reg [3:0] C1Y,
output reg [3:0] C2X,
output reg [3:0] C2Y,
output reg DONE);

reg [3:0] X_data[0:39];
reg [3:0] Y_data[0:39];

reg [5:0] cnt;

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
      CIR1 = 3'd2,
      CIR2 = 3'd3,
	  CAL = 3'd4,
	  OUT = 3'd5;


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


//DATA INPUT
always@(posedge CLK or posedge RST)begin
    if(RST)begin
        DONE <= 0;
        cnt <= 0;
    end
    else begin
        if(next_state == READ)begin
            X_data[cnt] <= X;
            Y_data[cnt] <= Y;
            cnt <= cnt + 1;
            if(cnt == 39)
                DONE <= 1;
        end
        else 

    end
end

endmodule


