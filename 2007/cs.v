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
    input   [2:0]   cmd;
    input           cmd_valid;
    output  reg [7:0]   dataout;
    output   reg    output_valid;
    output   reg    busy;
    
    
    parameter [0:0]
    RST = 1'b0,
    CMD_MODE = 1'b1;
    
    
    reg mag,state;
    reg out_flag,out_cpt;
    reg[2:0] x_addr,y_addr,cmd_use;
    reg [6:0]in_pc, out_pc;
    reg [7:0]img_buf[0:63];
    reg [7:0]out_buf[0:15];
    integer i;
    
    always @(posedge clk or posedge reset or posedge cmd_valid) begin
        if (reset)begin
            state <= RST;
        end
        else
        begin
            state <= CMD_MODE;
        end
    end
    
    //cmd
    always @(posedge clk) begin
        case (state)
            RST:
            begin
                x_addr   <= 0;
                y_addr   <= 0;
                in_pc    <= 7'd1;
                cmd_use  <= cmd;
                mag      <= 0;
                out_flag <= 0;
                busy     <= 0;
                for(i = 0;i<64;i = i+1)
                begin
                    img_buf[i] <= 0;
                end
            end
            default:
            begin
                if (cmd_valid)begin
                    cmd_use <= cmd;
                    case (cmd)
                        3'd0://refresh output
                        begin
                            out_flag <= 1'b1;
                        end
                        3'd1:
                        begin//load data = > 1~64
                            in_pc <= 7'd1;
                            mag   <= 0;
                        end
                        3'd2:
                        begin
                            out_flag <= 1'b1;
                            mag    <= 1'b1;
                            x_addr <= 3'd2;
                            y_addr <= 3'd2;
                        end
                        
                        3'd3:
                        begin
                            out_flag <= 1'b1;
                            mag    <= 1'b0;
                            x_addr <= 3'd0;
                            y_addr <= 3'd0;
                        end
                        3'd4://right shift
                        begin
                            out_flag <= 1'b1;
                            if (mag == 1'b1 && x_addr <4)
                            begin
                                x_addr <= x_addr + 1'd1;
                            end
                        end
                        
                        3'd5://left shift
                        begin
                            out_flag <= 1'b1;
                            if (mag == 1'b1 && x_addr >0)
                            begin
                                x_addr <= x_addr - 1'd1;
                            end
                        end
                        3'd6://up shift
                        begin
                            out_flag <= 1'b1;
                            if (mag == 1'b1 && y_addr >0)
                            begin
                                y_addr <= y_addr - 1'd1;
                            end
                        end
                        3'd7://down shift
                        begin
                            out_flag <= 1'b1;
                            if (mag == 1'b1 && y_addr <4)
                            begin
                                y_addr <= y_addr + 1'd1;
                            end
                        end
                    endcase
                end
                else begin
                    cmd_use <= cmd_use;
                end
                
                case (cmd_use)
                    3'd0:begin //refresh
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd1://load data
                    begin
                        if (in_pc < 7'd65)begin
                            img_buf[63] <= datain;
                            for (i = 0;i<63 ;i = i+1) begin
                                img_buf[i] <= img_buf[i+1];
                            end
                            in_pc <= in_pc+7'd1;
                        end
                        
                        
                        if (in_pc == 7'd64)
                        begin
                            out_flag <= 1'b1;
                        end
                        if (out_flag && out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd2://zoom in
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd3://zoom out
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd4://right shift
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd5://left shift
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd6://up shift
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    3'd7://down shift
                    begin
                        if (out_pc == 7'd17)
                        begin
                            out_flag <= 0;
                        end
                    end
                    default:x_addr <= x_addr;
                endcase
            end
        endcase
    end
    
    //dataout output_valid
    always @(negedge clk) begin
        case (state)
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
                    out_pc <= 1;
                end
            end
        endcase
    end
    
    //outbuf handler
    always @(*) begin
        if (state == RST)
        begin
            for(i = 0;i<16;i = i+1)
            begin
                out_buf[i] <= 0;
            end
        end
        else
        begin
            if (mag)begin
                out_buf[0]  <= img_buf[8*y_addr+x_addr];
                out_buf[1]  <= img_buf[8*y_addr+x_addr+1];
                out_buf[2]  <= img_buf[8*y_addr+x_addr+2];
                out_buf[3]  <= img_buf[8*y_addr+x_addr+3];
                out_buf[4]  <= img_buf[8*(y_addr+1)+x_addr];
                out_buf[5]  <= img_buf[8*(y_addr+1)+x_addr+1];
                out_buf[6]  <= img_buf[8*(y_addr+1)+x_addr+2];
                out_buf[7]  <= img_buf[8*(y_addr+1)+x_addr+3];
                out_buf[8]  <= img_buf[8*(y_addr+2)+x_addr];
                out_buf[9]  <= img_buf[8*(y_addr+2)+x_addr+1];
                out_buf[10] <= img_buf[8*(y_addr+2)+x_addr+2];
                out_buf[11] <= img_buf[8*(y_addr+2)+x_addr+3];
                out_buf[12] <= img_buf[8*(y_addr+3)+x_addr];
                out_buf[13] <= img_buf[8*(y_addr+3)+x_addr+1];
                out_buf[14] <= img_buf[8*(y_addr+3)+x_addr+2];
                out_buf[15] <= img_buf[8*(y_addr+3)+x_addr+3];
            end
            else
            begin
                out_buf[0]  <= img_buf[0];
                out_buf[1]  <= img_buf[2];
                out_buf[2]  <= img_buf[4];
                out_buf[3]  <= img_buf[6];
                out_buf[4]  <= img_buf[16];
                out_buf[5]  <= img_buf[18];
                out_buf[6]  <= img_buf[20];
                out_buf[7]  <= img_buf[22];
                out_buf[8]  <= img_buf[32];
                out_buf[9]  <= img_buf[34];
                out_buf[10] <= img_buf[36];
                out_buf[11] <= img_buf[38];
                out_buf[12] <= img_buf[48];
                out_buf[13] <= img_buf[50];
                out_buf[14] <= img_buf[52];
                out_buf[15] <= img_buf[54];
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    






