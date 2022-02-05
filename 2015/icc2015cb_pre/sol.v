`define abs(a,b) ((a>b) ? (a-b) : (b-a))
`define in_circle(k) (`abs(x,cx[k])*`abs(x,cx[k]) + `abs(y,cy[k])*`abs(y,cy[k]) <= cr[k]*cr[k])
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
reg [2:0] state;
reg [2:0] x;
reg [2:0] y;
reg [63:0] ans;
reg [1:0] cmd;
reg [1:0] tmp;

integer i;
always @(posedge clk) begin
    if(rst)
    begin
        busy <= 0;
        valid <= 0;
        candidate <= 0;
        state <= 0;
    end
    else
    begin
        if(en)
        begin
            for(i = 0; i < 3;i = i+1)
            begin
                cx[i] <= central[23-8*i -: 4];
                cy[i] <= central[19-8*i -: 4];
                cr[i] <= radius[11-4*i -: 4];
            end
            cmd <= mode;
            state <= 1;
            busy <= 1;
            candidate <= 0;
            x <= 1;
            y <= 1;
        end
        else
        begin
            if(state == 1)//cal candidate
            begin
                case (cmd)
                    0:
                    begin
                        if(`in_circle(0)) candidate <= candidate + 1;
                    end 
                    
                    1: 
                    begin
                        if(`in_circle(0) & `in_circle(1)) candidate <= candidate + 1;
                    end
                    
                    2: 
                    begin
                        if(`in_circle(0) ^ `in_circle(1)) candidate <= candidate + 1;
                    end
                    
                    3: 
                    begin
                        for(i = 0 ;i < 3;i = i + 1)
                        begin
                            if(`in_circle(i)) tmp = tmp + 1;
                        end
                        if(tmp == 2) candidate <= candidate + 1;
                    end
                    
                endcase
                if (x == 8) begin
                    if(y == 8) begin
                        valid <= 1;
                        state <= 2;
                    end
                    y <= y + 1;
                end
                x <= x + 1;
            end
            else if(state == 2) //end state
            begin
                valid <= 0;
                state <= 0;
                busy <=0;
            end
        end
    end
end

endmodule
