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
    reg [3:0] cmd_use;
    reg mode;
    reg [1:0] state;
    reg [7:0] img_buf[107:0];
    reg [7:0] out_buf[15:0];
    reg [3:0] w,l;
    reg [1:0] dir;
    reg [6:0] in_pc,out_pc;
    reg out_flag,out_cpt;
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
    
    localparam DIR_L = 2'd0;
    localparam DIR_U = 2'd1;
    localparam DIR_R = 2'd2;
    
    always @(posedge clk or posedge reset) begin
        if (reset)begin
            mode <= RST;
        end
        else begin
            mode <= CMD_MODE;
        end
    end
    
    always @(posedge clk) begin
        if (mode == RST)begin
            state <= INIT_ST;
            l     <= 4'd6;
            w     <= 4'd5;
            dir   <= 2'd1;
            in_pc <= 0;
        end
        else begin
            if (cmd_valid) begin
                cmd_use <= cmd;
                case (cmd)
                    LOAD: begin
                        l     <= 4'd6;
                        w     <= 4'd5;
                        in_pc <= 0;
                        state <= FIT_ST;
                    end
                    Rotate_L: begin
                        if (state == FIT_ST) begin
                            dir <= dir -2'd1;
                        end
                    end
                    Rotate_R: begin
                        if (state == FIT_ST) begin
                            dir <= dir +2'd1;
                        end
                    end
                    ZOOM_IN: begin
                        state <= IN_ST;
                    end
                    ZOOM_FIT: begin
                        state <= FIT_ST;
                    end
                    SHIFT_R: begin
                        if (state == IN_ST) begin
                            case (dir)
                                DIR_U: begin
                                    if (l<4'd10) begin
                                        l <= l + 4'b1;
                                    end
                                end
                                DIR_L: begin
                                    if (w<4'd7) begin
                                        w <= w + 4'b1;
                                    end
                                end
                                DIR_R: begin
                                    if (w>4'd2) begin
                                        w <= w - 4'b1;
                                    end
                                end
                                default: w <= w;
                            endcase
                        end
                    end
                    SHIFT_L: begin
                        if (state == IN_ST) begin
                            case (dir)
                                DIR_U: begin
                                    if (l > 4'd2) begin
                                        l <= l - 4'b1;
                                    end
                                end
                                DIR_L: begin
                                    if (w > 4'd2) begin
                                        w <= w - 4'b1;
                                    end
                                end
                                DIR_R: begin
                                    if (w < 4'd7) begin
                                        w <= w + 4'b1;
                                    end
                                end
                                default: w <= w;
                            endcase
                        end
                    end
                    SHIFT_U: begin
                        if (state == IN_ST) begin
                            case (dir)
                                DIR_U: begin
                                    if (w > 4'd2) begin
                                        w <= w - 4'b1;
                                    end
                                end
                                DIR_L: begin
                                    if (l < 4'd10) begin
                                        l <= l + 4'b1;
                                    end
                                end
                                DIR_R: begin
                                    if (l>4'd2) begin
                                        l <= l - 4'b1;
                                    end
                                end
                                default: w <= w;
                            endcase
                        end
                    end
                    SHIFT_D: begin
                        if (state == IN_ST) begin
                            case (dir)
                                DIR_U: begin
                                    if (w<4'd7) begin
                                        w <= w + 4'b1;
                                    end
                                end
                                DIR_L: begin
                                    if (l>4'd2) begin
                                        l <= l - 4'b1;
                                    end
                                end
                                DIR_R: begin
                                    if (l<4'd10) begin
                                        l <= l + 4'b1;
                                    end
                                end
                                default: w <= w;
                            endcase
                        end
                    end
                    default: w <= w;
                endcase
                
                if (cmd > 0)begin
                    out_flag <= 1;
                end
            end //if cmd valid
            
            case (cmd_use)
                LOAD:begin
                    if (in_pc < 7'd108) begin
                        img_buf[in_pc] <= datain;
                        in_pc          <= in_pc + 1;
                    end
                    else if (in_pc == 7'd108)begin
                        out_flag <= 1'b1;
                        in_pc    <= in_pc + 1;
                    end
                    else begin
                        if (out_flag && out_pc == 7'd17)begin
                            out_flag <= 0;
                        end
                    end
                end
                Rotate_L: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                Rotate_R: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                ZOOM_IN: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                ZOOM_FIT: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                SHIFT_R: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                SHIFT_L: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                SHIFT_U: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                SHIFT_D: begin
                    if (out_pc == 7'd17)
                    begin
                        out_flag <= 0;
                    end
                end
                default: w <= w;
            endcase
            
        end
    end
    
    //dataout output_valid
    always @(negedge clk) begin
        case (mode)
            RST:
            begin
                out_cpt <= 0;
                out_pc  <= 1;
            end
            default:
            begin
                if (out_flag == 1'b1 && out_pc < 7'd17)begin
                    case (out_pc)
                        7'd1: dataout    <= out_buf[0];
                        7'd2: dataout    <= out_buf[1];
                        7'd3: dataout    <= out_buf[2];
                        7'd4: dataout    <= out_buf[3];
                        7'd5: dataout    <= out_buf[4];
                        7'd6: dataout    <= out_buf[5];
                        7'd7: dataout    <= out_buf[6];
                        7'd8: dataout    <= out_buf[7];
                        7'd9: dataout    <= out_buf[8];
                        7'd10: dataout   <= out_buf[9];
                        7'd11: dataout   <= out_buf[10];
                        7'd12: dataout   <= out_buf[11];
                        7'd13: dataout   <= out_buf[12];
                        7'd14: dataout   <= out_buf[13];
                        7'd15: dataout   <= out_buf[14];
                        7'd16: dataout   <= out_buf[15];
                        default: dataout <= dataout;
                    endcase
                    out_pc       <= out_pc+1'b1;
                    output_valid <= 1'b1;
                    out_cpt      <= 0;
                end
                else
                begin
                    output_valid <= 0;
                    out_pc       <= 1;
                end
            end
        endcase
    end
    
    //outbuf handler
    always @(*) begin
        if (mode == RST)
        begin
            outbuf[0] <= outbuf[0];
        end
        else
        begin
            if (state == FIT_ST)begin
                case (dir)
                    DIR_L: begin
                        
                    end
                    DIR_U: begin
                        
                    end
                    DIR_R: begin
                        
                    end
                    default:
                endcase
            end
            else if (state == IN_ST)
            begin
                case (dir)
                    DIR_L: begin
                        
                    end
                    DIR_U: begin
                        
                    end
                    DIR_R: begin
                        
                    end
                    default:
                endcase
            end
                end
                
                end
                
                //busy
                always @(negedge out_flag or posedge reset or posedge cmd_valid) begin
                    if (reset)begin
                        busy <= 0;
                    end
                    else begin
                        if (cmd_valid)
                        begin
                            busy <= 1;
                        end
                        else if (!out_flag && out_pc == 7'd17)//output complete
                        begin
                            busy <= 0;
                        end
                        else
                        begin
                            busy <= busy;
                        end
                    end
                end
                
                endmodule
