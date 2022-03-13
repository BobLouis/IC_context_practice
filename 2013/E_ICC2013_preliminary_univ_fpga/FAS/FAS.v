`include "../FFT_PE/FFT_PE.v"
module FAS(
       clk, 
       rst, 
       data_valid, 
       data, 
       fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7,
       fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15,
       fft_valid,
       done,
       freq
       );
       
       input	clk;
       input	rst;
       input	data_valid;
       input signed [15:0] data;
       output reg[31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
                     fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
       output reg fft_valid;
       output reg done;                      
       output reg [3:0] freq;

       parameter IDLE = 3'd0;
       parameter READ = 3'd1;
       parameter WRITE = 3'd2;
       parameter CAL = 3'd3;
       parameter FINISH= 3'd4;
       reg [2:0] state, next_state;
       reg [7:0] pc;
       reg [3:0] counterRead;

       reg [15:0] buf[0:159];


       reg [15:0]buf_0;
       reg [15:0]buf_1;
       reg [15:0]buf_2;
       reg [15:0]buf_3;
       reg [15:0]buf_4;
       reg [15:0]buf_5;
       reg [15:0]buf_6;
       reg [15:0]buf_7;
       reg [15:0]buf_8;
       reg [15:0]buf_9;
       reg [15:0]buf_10;
       reg [15:0]buf_11;
       reg [15:0]buf_12;
       reg [15:0]buf_13;
       reg [15:0]buf_14;
       reg [15:0]buf_15;

       always @(posedge clk or posedge rst) begin
              if(rst == 1) state <= IDLE;
              else state <= next_state;
       end
       //state
       always @(*) begin
              if(rst) next_state = IDLE;
              else begin
                    case (state)
                            IDLE:
                            begin
                                   if(data_valid) next_state = READ;
                                   else next_state = IDLE;
                            end
                            READ:
                            begin
                                   if(pc == 160) next_state = CAL;
                                   else next_state = READ;
                            end
                            CAL:
                            begin
                                   if(pc == 14) next_state = FINISH;
                                   else next_state = CAL;
                            end
                            default:  next_state = IDLE;
                     endcase 
              end
       end

       //pc
       always @(posedge clk or posedge rst) begin
              if(reset) pc <= 0;
              else if(pc == 160) pc <= 0;
              else if(pc == 14 && state == CAL) pc <= 0;
              else pc <= pc + 1;
       end



       


endmodule
