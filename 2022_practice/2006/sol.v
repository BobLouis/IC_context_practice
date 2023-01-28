`define is_upper(x,y) ()

module triangle (clk,
                 reset,
                 nt,
                 xi,
                 yi,
                 busy,
                 po,
                 xo,
                 yo);
    input clk, reset, nt;
    input [2:0] xi, yi;
    output busy, po;
    output [2:0] xo, yo;
    
    reg [2:0] x0, x1, x2, y0, y1, y2;
    reg [2:0] state;
    wire right;
    
    assign right = (x2>x1)?1:0;
    
    
    always @(posedge clk) begin
        
    end
    
    
    
    
    
endmodule
