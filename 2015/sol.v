`define abs(a,b) ((a>b) ? (a-b) : (b-a))
`define is_in_circle(j) ((`abs(x,cx[j]) * `abs(x,cx[j]) + `abs(y,cy[j]) * `abs(y,cy[j])) <= cr[j] * cr[j])

module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [3:0] cx[0:2];
reg [3:0] cy[0:2];
reg [3:0] cr[0:2];
reg [3:0] x,y;
integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        busy <= 0;
        valid <= 0;
        candidate <= 0;
        x <= 0;
        y <= 0;
        for(i = 0; i <3; i = i + 1) begin
            cx[i] <= 0;
            cy[i] <= 0;
            cr[i] <= 0;
        end
    end
    else begin
        if(en) begin
            x         <= 1;
            y         <= 1;
            busy      <= 1;
            valid     <= 0;
            candidate <= 0;
            for(i = 0; i <3; i = i + 1)begin
                cx[i] <= central[23-i*8 -: 4];
                cy[i] <= central[19-i*8 -: 4];
                cr[i] <= radius[11-i*4 -: 4];
            end
        end
        else if (busy) begin
            if(valid) begin
                busy <= 0;
            end
            else begin
                case (mode)
                    0 :begin
                        if(`is_in_circle(0)) candidate <= candidate + 1;
                    end
                    1 :begin
                        if(`is_in_circle(1) && `is_in_circle(1)) candidate <= candidate + 1;
                    end
                    2 :begin
                        if(`is_in_circle(1) ^ `is_in_circle(1)) candidate <= candidate + 1;
                    end
                endcase
                if(y == 8)begin
                    y <= 1;
                    if(x == 8)begin
                        valid <= 1;
                        x <= 1;
                    end
                    else x <= x+1;
                end
                else y <= y + 1;
            end
        end
        else valid <= 0;
    end
end

endmodule
