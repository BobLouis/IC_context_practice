module LCD_CTRL(clk,
                reset,
                datain,
                cmd,
                cmd_valid,
                dataout,
                output_valid,
                busy);
    input           clk;
    input           reset;
    input   [7:0]   datain;
    input   [3:0]   cmd;
    input           cmd_valid;
    output  reg[7:0]   dataout;
    output  reg     output_valid;
    output  reg     busy;
    
    reg [1:0]state;
    reg [7:0] img_buf[107:0];
    reg [7:0] out_buf[7:0];
    reg [3:0]w,l;
    reg [1:0]dir;
    localparam RST      = 1'b0;
    localparam CMD_MODE = 1'b1;
    localparam LOAD     = 4'd0;
    localparam Rotate_L = 4'd1;
    localparam Rotate_R = 4'd2;
    localparam ZOOM_IN  = 4'd3;
    localparam ZOOM_FIT = 4'd4;
    localparam SHIFT_R  = 4'd5;
    localparam SHIFT_L  = 4'd6;
    localparam SHIFT_U  = 4'd7;
    localparam SHIFT_D  = 4'd8;
    
    localparam INIT_ST = 2'd0;
    localparam FIT_ST  = 2'd1;
    localparam IN_ST   = 2'd2;
    
    localparam DIR_L = 2'd0,
    localparam DIR_U = 2'd1;
    localparam DIR_R = 2'd2;
    
    always @(posedge clk or posedge reset) begin
        if (reset)begin
            state <= RST;
        end
        else
        begin
            state <= CMD_MODE;
        end
    end

    always @(posedge clk) begin
        if(state == RST)begin
          
        end
    end
    
    
    
endmodule
