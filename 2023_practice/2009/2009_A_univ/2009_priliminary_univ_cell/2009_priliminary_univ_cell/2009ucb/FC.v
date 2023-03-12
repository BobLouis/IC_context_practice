`timescale 1ns/100ps
module FC(clk, rst, cmd, done, M_RW, M_A, M_D, F_IO, F_CLE, F_ALE, F_REN, F_WEN, F_RB);

  input clk;
  input rst;
  input [32:0] cmd;
  output reg done;
  output reg M_RW;
  output reg [6:0] M_A;
  inout  [7:0] M_D;
  inout  [7:0] F_IO;
  output reg F_CLE;
  output reg F_ALE;
  output reg F_REN;
  output reg F_WEN;
  input  F_RB;


reg [2:0]state, next_state;
parameter IDLE = 3'd0,
      READ_CMD = 3'd1,
	  READ_F = 3'd2,
	  READ_M = 3'd3;



reg [6:0]cnt;
reg [3:0]write_cnt;
reg [7:0]F_IO_REG;
reg [7:0]M_D_REG;

assign F_IO = (F_WEN == 1) ? F_IO_REG : 8'bz;
assign M_D  = (M_RW == 1) ? 8'bz : F_IO;
wire rw;
wire [17:0]flash_addr;
wire [6:0] memory_addr;
wire [6:0] rw_len;

assign {rw,flash_addr,memory_addr,rw_len} = cmd;

always@(posedge clk or posedge rst)begin
    if(rst)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(rst)
        next_state = IDLE;
    else begin
        case(state)
            IDLE:
                if(done)next_state = READ_CMD;
                else next_state = IDLE;
            READ_CMD:begin
                if(cmd[32] == 0) next_state = READ_M;
                else next_state = READ_F;  
            end
            READ_F:begin
                if(write_cnt == 10) next_state = IDLE;
                else next_state = READ_F;  
            end 
            READ_M:begin
                if(write_cnt == 14) next_state = IDLE;
                else next_state = READ_M;
            end
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge rst)begin
    if(rst)begin
        done <= 0;
        F_IO_REG <= 8'hff;
        write_cnt <= 0;
    end
    else begin
        if(next_state == IDLE)begin
            done <= 1;  
            cnt <= 0;
            write_cnt <= 0;
            F_WEN <= 0;
        end
        else if(next_state == READ_CMD)begin
            done <= 0;
        end
        else if(next_state == READ_F)begin
            case (write_cnt)
                0:begin
                    F_CLE <= 1;
                    F_ALE <= 0;
                    F_IO_REG <= cmd[22];
                    write_cnt <= write_cnt + 1;
                end 
                1:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                2:begin
                    F_CLE <= 0;
                    F_ALE <= 1;
                    F_WEN <= 0;
                    F_IO_REG <= cmd[21:14];
                    write_cnt <= write_cnt + 1;
                end
                3:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                4:begin
                    F_WEN <= 0;
                    F_IO_REG <= cmd[30:23];
                    write_cnt <= write_cnt + 1;
                end
                5:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                6:begin
                    F_WEN <= 0;
                    F_IO_REG <= {7'd0, cmd[31]};
                    write_cnt <= write_cnt + 1;
                end
                7:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                8:begin
                    F_ALE <= 0;
                    if(F_RB == 1)begin
                        write_cnt <= write_cnt + 1;
                    end
                end
                9:begin
                    M_RW <= 0;
                    M_A <= cmd[13:7] + cnt;
                    cnt <= cnt + 1;
                    M_D_REG <= F_IO;
                    if(cnt == cmd[6:0])
                        write_cnt <= write_cnt + 1;
                end
            endcase
        end
        else if(next_state == READ_M)begin
            case(write_cnt)
                0:begin
                    if(cmd[22] == 1)begin//a8
                        F_IO_REG <= 8'h01;
                        write_cnt <=  1;
                    end
                    else begin 
                        F_IO_REG <= 8'h80;
                        write_cnt <= 3;
                    end
                    F_CLE <= 1;
                    F_ALE <= 0;
                end
                1:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                2:begin
                    F_WEN <= 0;
                    F_IO_REG <= 8'h80; 
                    write_cnt <= write_cnt + 1;
                end
                3:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;   
                end
                4:begin
                    F_WEN <= 0;
                    F_CLE <= 0;
                    F_ALE <= 1;
                    F_IO_REG <= cmd[21:14];
                    write_cnt <= write_cnt + 1; 
                end
                5:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1; 
                end
                6:begin
                    F_WEN <= 0;
                    F_IO_REG <= cmd[30:23];
                    write_cnt <= write_cnt + 1;
                end
                7:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                8:begin
                    F_WEN <= 0;
                    F_IO_REG <= {7'd0, cmd[31]};
                    write_cnt <= write_cnt + 1;
                end
                9:begin
                    F_WEN <= 1;
                    M_RW <= 1;
                    M_A <= cmd[13:7] + cnt;
                    cnt <= cnt + 1;
                    write_cnt <= write_cnt + 1;
                end
                10:begin
                    F_WEN <= 0;
                    F_IO_REG <= M_D;
                    if(cnt == cmd[6:0])
                        write_cnt = write_cnt + 1;
                    else
                        write_cnt <= 9;
                end
                11:begin
                    F_WEN <= 0;
                    F_ALE <= 0;
                    F_CLE <= 1;
                    F_IO_REG <= 8'h10;
                    write_cnt <= write_cnt + 1;
                end
                12:begin
                    F_WEN <= 1;
                    write_cnt <= write_cnt + 1;
                end
                13:begin
                    if(F_RB == 1)
                        write_cnt <= write_cnt + 1;
                end
            endcase
        end
    end
end

always@(negedge clk)begin
    if(state == READ_F && write_cnt == 8)
        F_REN <= 1;
    else 
        F_REN <= 0;
end


endmodule
