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
       output [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
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

       reg [15:0] buff[0:159];


       reg [31:0]buf_0;
       reg [31:0]buf_1;
       reg [31:0]buf_2;
       reg [31:0]buf_3;
       reg [31:0]buf_4;
       reg [31:0]buf_5;
       reg [31:0]buf_6;
       reg [31:0]buf_7;
       reg [31:0]buf_8;
       reg [31:0]buf_9;
       reg [31:0]buf_10;
       reg [31:0]buf_11;
       reg [31:0]buf_12;
       reg [31:0]buf_13;
       reg [31:0]buf_14;
       reg [31:0]buf_15;

       wire [31:0]pe_1_0_a;
       wire [31:0]pe_1_0_b;
       wire [31:0]pe_1_1_a;
       wire [31:0]pe_1_1_b;
       wire [31:0]pe_1_2_a;
       wire [31:0]pe_1_2_b;
       wire [31:0]pe_1_3_a;
       wire [31:0]pe_1_3_b;
       wire [31:0]pe_1_4_a;
       wire [31:0]pe_1_4_b;
       wire [31:0]pe_1_5_a;
       wire [31:0]pe_1_5_b;
       wire [31:0]pe_1_6_a;
       wire [31:0]pe_1_6_b;
       wire [31:0]pe_1_7_a;
       wire [31:0]pe_1_7_b;

       wire [31:0]pe_2_0_a;
       wire [31:0]pe_2_0_b;
       wire [31:0]pe_2_1_a;
       wire [31:0]pe_2_1_b;
       wire [31:0]pe_2_2_a;
       wire [31:0]pe_2_2_b;
       wire [31:0]pe_2_3_a;
       wire [31:0]pe_2_3_b;
       wire [31:0]pe_2_4_a;
       wire [31:0]pe_2_4_b;
       wire [31:0]pe_2_5_a;
       wire [31:0]pe_2_5_b;
       wire [31:0]pe_2_6_a;
       wire [31:0]pe_2_6_b;
       wire [31:0]pe_2_7_a;
       wire [31:0]pe_2_7_b;

       wire [31:0]pe_3_0_a;
       wire [31:0]pe_3_0_b;
       wire [31:0]pe_3_1_a;
       wire [31:0]pe_3_1_b;
       wire [31:0]pe_3_2_a;
       wire [31:0]pe_3_2_b;
       wire [31:0]pe_3_3_a;
       wire [31:0]pe_3_3_b;
       wire [31:0]pe_3_4_a;
       wire [31:0]pe_3_4_b;
       wire [31:0]pe_3_5_a;
       wire [31:0]pe_3_5_b;
       wire [31:0]pe_3_6_a;
       wire [31:0]pe_3_6_b;
       wire [31:0]pe_3_7_a;
       wire [31:0]pe_3_7_b;

       wire [31:0]pe_4_0_a;
       wire [31:0]pe_4_0_b;
       wire [31:0]pe_4_1_a;
       wire [31:0]pe_4_1_b;
       wire [31:0]pe_4_2_a;
       wire [31:0]pe_4_2_b;
       wire [31:0]pe_4_3_a;
       wire [31:0]pe_4_3_b;
       wire [31:0]pe_4_4_a;
       wire [31:0]pe_4_4_b;
       wire [31:0]pe_4_5_a;
       wire [31:0]pe_4_5_b;
       wire [31:0]pe_4_6_a;
       wire [31:0]pe_4_6_b;
       wire [31:0]pe_4_7_a;
       wire [31:0]pe_4_7_b;



       FFT_PE pe_1_1(.clk(clk), .rst(rst), .a(buf_0), .b(buf_8), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_1_0_a), .fft_b(pe_1_0_b), .fft_pe_valid());

       FFT_PE pe_1_2(.clk(clk), .rst(rst), .a(buf_1), .b(buf_9), .power(3'd1), .ab_valid(1'd1)
                     , .fft_a(pe_1_1_a), .fft_b(pe_1_1_b), .fft_pe_valid());

       FFT_PE pe_1_3(.clk(clk), .rst(rst), .a(buf_2), .b(buf_10), .power(3'd2), .ab_valid(1'd1)
                     , .fft_a(pe_1_2_a), .fft_b(pe_1_2_b), .fft_pe_valid());

       FFT_PE pe_1_4(.clk(clk), .rst(rst), .a(buf_3), .b(buf_11), .power(3'd3), .ab_valid(1'd1)
                     , .fft_a(pe_1_3_a), .fft_b(pe_1_3_b), .fft_pe_valid());

       FFT_PE pe_1_5(.clk(clk), .rst(rst), .a(buf_4), .b(buf_12), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_1_4_a), .fft_b(pe_1_4_b), .fft_pe_valid());

       FFT_PE pe_1_6(.clk(clk), .rst(rst), .a(buf_5), .b(buf_13), .power(3'd5), .ab_valid(1'd1)
                     , .fft_a(pe_1_5_a), .fft_b(pe_1_5_b), .fft_pe_valid());

       FFT_PE pe_1_7(.clk(clk), .rst(rst), .a(buf_6), .b(buf_14), .power(3'd6), .ab_valid(1'd1)
                     , .fft_a(pe_1_6_a), .fft_b(pe_1_6_b), .fft_pe_valid());

       FFT_PE pe_1_8(.clk(clk), .rst(rst), .a(buf_7), .b(buf_15), .power(3'd7), .ab_valid(1'd1)
                     , .fft_a(pe_1_7_a), .fft_b(pe_1_7_b), .fft_pe_valid());


       FFT_PE pe_2_1(.clk(clk), .rst(rst), .a(pe_1_0_a), .b(pe_1_4_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_2_0_a), .fft_b(pe_2_0_b), .fft_pe_valid());

       FFT_PE pe_2_2(.clk(clk), .rst(rst), .a(pe_1_1_a), .b(pe_1_5_a), .power(3'd2), .ab_valid(1'd1)
                     , .fft_a(pe_2_1_a), .fft_b(pe_2_1_b), .fft_pe_valid());

       FFT_PE pe_2_3(.clk(clk), .rst(rst), .a(pe_1_2_a), .b(pe_1_6_a), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_2_2_a), .fft_b(pe_2_2_b), .fft_pe_valid());

       FFT_PE pe_2_4(.clk(clk), .rst(rst), .a(pe_1_3_a), .b(pe_1_7_a), .power(3'd6), .ab_valid(1'd1)
                     , .fft_a(pe_2_3_a), .fft_b(pe_2_3_b), .fft_pe_valid());

       FFT_PE pe_2_5(.clk(clk), .rst(rst), .a(pe_1_0_b), .b(pe_1_4_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_2_4_a), .fft_b(pe_2_4_b), .fft_pe_valid());

       FFT_PE pe_2_6(.clk(clk), .rst(rst), .a(pe_1_1_b), .b(pe_1_5_b), .power(3'd2), .ab_valid(1'd1)
                     , .fft_a(pe_2_5_a), .fft_b(pe_2_5_b), .fft_pe_valid());

       FFT_PE pe_2_7(.clk(clk), .rst(rst), .a(pe_1_2_b), .b(pe_1_6_b), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_2_6_a), .fft_b(pe_2_6_b), .fft_pe_valid());

       FFT_PE pe_2_8(.clk(clk), .rst(rst), .a(pe_1_3_b), .b(pe_1_7_b), .power(3'd6), .ab_valid(1'd1)
                     , .fft_a(pe_2_7_a), .fft_b(pe_2_7_b), .fft_pe_valid());


       FFT_PE pe_3_1(.clk(clk), .rst(rst), .a(pe_2_0_a), .b(pe_2_2_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_3_0_a), .fft_b(pe_3_0_b), .fft_pe_valid());

       FFT_PE pe_3_2(.clk(clk), .rst(rst), .a(pe_2_1_a), .b(pe_2_3_a), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_3_1_a), .fft_b(pe_3_1_b), .fft_pe_valid());

       FFT_PE pe_3_3(.clk(clk), .rst(rst), .a(pe_2_0_b), .b(pe_2_2_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_3_2_a), .fft_b(pe_3_2_b), .fft_pe_valid());

       FFT_PE pe_3_4(.clk(clk), .rst(rst), .a(pe_2_1_b), .b(pe_2_3_b), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_3_3_a), .fft_b(pe_3_3_b), .fft_pe_valid());
                     
       FFT_PE pe_3_5(.clk(clk), .rst(rst), .a(pe_2_4_a), .b(pe_2_6_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_3_4_a), .fft_b(pe_3_4_b), .fft_pe_valid());

       FFT_PE pe_3_6(.clk(clk), .rst(rst), .a(pe_2_5_a), .b(pe_2_7_a), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_3_5_a), .fft_b(pe_3_5_b), .fft_pe_valid());

       FFT_PE pe_3_7(.clk(clk), .rst(rst), .a(pe_2_4_b), .b(pe_2_6_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_3_6_a), .fft_b(pe_3_6_b), .fft_pe_valid());

       FFT_PE pe_3_8(.clk(clk), .rst(rst), .a(pe_2_5_b), .b(pe_2_7_b), .power(3'd4), .ab_valid(1'd1)
                     , .fft_a(pe_3_7_a), .fft_b(pe_3_7_b), .fft_pe_valid());


       FFT_PE pe_4_1(.clk(clk), .rst(rst), .a(pe_3_0_a), .b(pe_3_1_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_0_a), .fft_b(pe_4_0_b), .fft_pe_valid());

       FFT_PE pe_4_2(.clk(clk), .rst(rst), .a(pe_3_0_b), .b(pe_3_1_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_1_a), .fft_b(pe_4_1_b), .fft_pe_valid());

       FFT_PE pe_4_3(.clk(clk), .rst(rst), .a(pe_3_2_a), .b(pe_3_3_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_2_a), .fft_b(pe_4_2_b), .fft_pe_valid());

       FFT_PE pe_4_4(.clk(clk), .rst(rst), .a(pe_3_2_b), .b(pe_3_3_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_3_a), .fft_b(pe_4_3_b), .fft_pe_valid());
                     
       FFT_PE pe_4_5(.clk(clk), .rst(rst), .a(pe_3_4_a), .b(pe_3_5_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_4_a), .fft_b(pe_4_4_b), .fft_pe_valid());

       FFT_PE pe_4_6(.clk(clk), .rst(rst), .a(pe_3_4_b), .b(pe_3_5_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_5_a), .fft_b(pe_4_5_b), .fft_pe_valid());

       FFT_PE pe_4_7(.clk(clk), .rst(rst), .a(pe_3_6_a), .b(pe_3_7_a), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_6_a), .fft_b(pe_4_6_b), .fft_pe_valid());

       FFT_PE pe_4_8(.clk(clk), .rst(rst), .a(pe_3_6_b), .b(pe_3_7_b), .power(3'd0), .ab_valid(1'd1)
                     , .fft_a(pe_4_7_a), .fft_b(pe_4_7_b), .fft_pe_valid());

       assign fft_d0 = pe_4_0_a;
       assign fft_d1 = pe_4_4_a;
       assign fft_d2 = pe_4_2_a;
       assign fft_d3 = pe_4_6_a;
       assign fft_d4 = pe_4_1_a;
       assign fft_d5 = pe_4_5_a;
       assign fft_d6 = pe_4_3_a;
       assign fft_d7 = pe_4_7_a;
       assign fft_d8 = pe_4_0_b;
       assign fft_d9 = pe_4_4_b;
       assign fft_d10 = pe_4_2_b;
       assign fft_d11 = pe_4_6_b;
       assign fft_d12 = pe_4_1_b;
       assign fft_d13 = pe_4_5_b;
       assign fft_d14 = pe_4_3_b;
       assign fft_d15 = pe_4_7_b;

       wire  [32:0]abs[0:15];  

       assign  abs[0] =  fft_d0[31:16]  * fft_d0[31:16]  + fft_d0[15:0]  * fft_d0[15:0]  ;
       assign  abs[1] =  fft_d1[31:16]  * fft_d1[31:16]  + fft_d1[15:0]  * fft_d1[15:0]  ;
       assign  abs[2] =  fft_d2[31:16]  * fft_d2[31:16]  + fft_d2[15:0]  * fft_d2[15:0]  ;
       assign  abs[3] =  fft_d3[31:16]  * fft_d3[31:16]  + fft_d3[15:0]  * fft_d3[15:0]  ;
       assign  abs[4] =  fft_d4[31:16]  * fft_d4[31:16]  + fft_d4[15:0]  * fft_d4[15:0]  ;
       assign  abs[5] =  fft_d5[31:16]  * fft_d5[31:16]  + fft_d5[15:0]  * fft_d5[15:0]  ;
       assign  abs[6] =  fft_d6[31:16]  * fft_d6[31:16]  + fft_d6[15:0]  * fft_d6[15:0]  ;
       assign  abs[7] =  fft_d7[31:16]  * fft_d7[31:16]  + fft_d7[15:0]  * fft_d7[15:0]  ;
       assign  abs[8] =  fft_d8[31:16]  * fft_d8[31:16]  + fft_d8[15:0]  * fft_d8[15:0]  ;
       assign  abs[9] =  fft_d9[31:16]  * fft_d9[31:16]  + fft_d9[15:0]  * fft_d9[15:0]  ;
       assign  abs[10] = fft_d10[31:16] * fft_d10[31:16] + fft_d10[15:0] * fft_d10[15:0] ;
       assign  abs[11] = fft_d11[31:16] * fft_d11[31:16] + fft_d11[15:0] * fft_d11[15:0] ;
       assign  abs[12] = fft_d12[31:16] * fft_d12[31:16] + fft_d12[15:0] * fft_d12[15:0] ;
       assign  abs[13] = fft_d13[31:16] * fft_d13[31:16] + fft_d13[15:0] * fft_d13[15:0] ;
       assign  abs[14] = fft_d14[31:16] * fft_d14[31:16] + fft_d14[15:0] * fft_d14[15:0] ;
       assign  abs[15] = fft_d15[31:16] * fft_d15[31:16] + fft_d15[15:0] * fft_d15[15:0] ;
       
       wire [3:0]ana_1_1 = (abs[0] > abs[1]) ? 0 : 1;
       wire [3:0]ana_1_2 = (abs[2] > abs[3]) ? 2 : 3;
       wire [3:0]ana_1_3 = (abs[4] > abs[5]) ? 4 : 5;
       wire [3:0]ana_1_4 = (abs[6] > abs[7]) ? 6 : 7;
       wire [3:0]ana_1_5 = (abs[8] > abs[9]) ? 8 : 9;
       wire [3:0]ana_1_6 = (abs[10] > abs[11]) ? 10 : 11;
       wire [3:0]ana_1_7 = (abs[12] > abs[13]) ? 12 : 13;
       wire [3:0]ana_1_8 = (abs[14] > abs[15]) ? 14 : 15;

       wire [3:0]ana_2_1 = (abs[ana_1_1] > abs[ana_1_2]) ? ana_1_1 : ana_1_2;
       wire [3:0]ana_2_2 = (abs[ana_1_3] > abs[ana_1_4]) ? ana_1_3 : ana_1_4;
       wire [3:0]ana_2_3 = (abs[ana_1_5] > abs[ana_1_6]) ? ana_1_5 : ana_1_6;
       wire [3:0]ana_2_4 = (abs[ana_1_7] > abs[ana_1_8]) ? ana_1_7 : ana_1_8;
       
       wire [3:0]ana_3_1 = (abs[ana_2_1] > abs[ana_2_2]) ? ana_2_1 : ana_2_2;
       wire [3:0]ana_3_2 = (abs[ana_2_3] > abs[ana_2_4]) ? ana_2_3 : ana_2_4;

       wire [3:0]ana_4 = (ana_3_1 > ana_3_2) ? ana_3_1 : ana_3_2;


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
                                   if(pc == 159) next_state = CAL;
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
              if(rst) pc <= 0;
              else if(pc == 159) pc <= 0;
              else if(pc == 10 && state == CAL) pc <= 0;
              else pc <= pc + 1;
       end
       //counterRead
       // always @(posedge clk or posedge rst) begin
       //        if(rst) counterRead <= 0;
       //        else if(counterRead == 10) counterRead <= 0; 
       // end

       //read data
       always @(posedge clk or posedge rst) begin
              if(next_state == READ)
              begin
                     case (pc)
                            0: buff[0] <= data;
                            1: buff[1] <= data;
                            2: buff[2] <= data;
                            3: buff[3] <= data;
                            4: buff[4] <= data;
                            5: buff[5] <= data;
                            6: buff[6] <= data;
                            7: buff[7] <= data;
                            8: buff[8] <= data;
                            9: buff[9] <= data;

                            10: buff[10] <= data;
                            11: buff[11] <= data;
                            12: buff[12] <= data;
                            13: buff[13] <= data;
                            14: buff[14] <= data;
                            15: buff[15] <= data;
                            16: buff[16] <= data;
                            17: buff[17] <= data;
                            18: buff[18] <= data;
                            19: buff[19] <= data;

                            20: buff[20] <= data;
                            21: buff[21] <= data;
                            22: buff[22] <= data;
                            23: buff[23] <= data;
                            24: buff[24] <= data;
                            25: buff[25] <= data;
                            26: buff[26] <= data;
                            27: buff[27] <= data;
                            28: buff[28] <= data;
                            29: buff[29] <= data;

                            30: buff[30] <= data;
                            31: buff[31] <= data;
                            32: buff[32] <= data;
                            33: buff[33] <= data;
                            34: buff[34] <= data;
                            35: buff[35] <= data;
                            36: buff[36] <= data;
                            37: buff[37] <= data;
                            38: buff[38] <= data;
                            39: buff[39] <= data;

                            40: buff[40] <= data;
                            41: buff[41] <= data;
                            42: buff[42] <= data;
                            43: buff[43] <= data;
                            44: buff[44] <= data;
                            45: buff[45] <= data;
                            46: buff[46] <= data;
                            47: buff[47] <= data;
                            48: buff[48] <= data;
                            49: buff[49] <= data;

                            50: buff[50] <= data;
                            51: buff[51] <= data;
                            52: buff[52] <= data;
                            53: buff[53] <= data;
                            54: buff[54] <= data;
                            55: buff[55] <= data;
                            56: buff[56] <= data;
                            57: buff[57] <= data;
                            58: buff[58] <= data;
                            59: buff[59] <= data;

                            60: buff[60] <= data;
                            61: buff[61] <= data;
                            62: buff[62] <= data;
                            63: buff[63] <= data;
                            64: buff[64] <= data;
                            65: buff[65] <= data;
                            66: buff[66] <= data;
                            67: buff[67] <= data;
                            68: buff[68] <= data;
                            69: buff[69] <= data;

                            70: buff[70] <= data;
                            71: buff[71] <= data;
                            72: buff[72] <= data;
                            73: buff[73] <= data;
                            74: buff[74] <= data;
                            75: buff[75] <= data;
                            76: buff[76] <= data;
                            77: buff[77] <= data;
                            78: buff[78] <= data;
                            79: buff[79] <= data;

                            80: buff[80] <= data;
                            81: buff[81] <= data;
                            82: buff[82] <= data;
                            83: buff[83] <= data;
                            84: buff[84] <= data;
                            85: buff[85] <= data;
                            86: buff[86] <= data;
                            87: buff[87] <= data;
                            88: buff[88] <= data;
                            89: buff[89] <= data;

                            90: buff[90] <= data;
                            91: buff[91] <= data;
                            92: buff[92] <= data;
                            93: buff[93] <= data;
                            94: buff[94] <= data;
                            95: buff[95] <= data;
                            96: buff[96] <= data;
                            97: buff[97] <= data;
                            98: buff[98] <= data;
                            99: buff[99] <= data;

                            100: buff[100] <= data;
                            101: buff[101] <= data;
                            102: buff[102] <= data;
                            103: buff[103] <= data;
                            104: buff[104] <= data;
                            105: buff[105] <= data;
                            106: buff[106] <= data;
                            107: buff[107] <= data;
                            108: buff[108] <= data;
                            109: buff[109] <= data;

                            110: buff[110] <= data;
                            111: buff[111] <= data;
                            112: buff[112] <= data;
                            113: buff[113] <= data;
                            114: buff[114] <= data;
                            115: buff[115] <= data;
                            116: buff[116] <= data;
                            117: buff[117] <= data;
                            118: buff[118] <= data;
                            119: buff[119] <= data;

                            120: buff[120] <= data;
                            121: buff[121] <= data;
                            122: buff[122] <= data;
                            123: buff[123] <= data;
                            124: buff[124] <= data;
                            125: buff[125] <= data;
                            126: buff[126] <= data;
                            127: buff[127] <= data;
                            128: buff[128] <= data;
                            129: buff[129] <= data;

                            130: buff[130] <= data;
                            131: buff[131] <= data;
                            132: buff[132] <= data;
                            133: buff[133] <= data;
                            134: buff[134] <= data;
                            135: buff[135] <= data;
                            136: buff[136] <= data;
                            137: buff[137] <= data;
                            138: buff[138] <= data;
                            139: buff[139] <= data;
                            
                            140: buff[140] <= data;
                            141: buff[141] <= data;
                            142: buff[142] <= data;
                            143: buff[143] <= data;
                            144: buff[144] <= data;
                            145: buff[145] <= data;
                            146: buff[146] <= data;
                            147: buff[147] <= data;
                            148: buff[148] <= data;
                            149: buff[149] <= data;

                            150: buff[150] <= data;
                            151: buff[151] <= data;
                            152: buff[152] <= data;
                            153: buff[153] <= data;
                            154: buff[154] <= data;
                            155: buff[155] <= data;
                            156: buff[156] <= data;
                            157: buff[157] <= data;
                            158: buff[158] <= data;
                            159: buff[159] <= data;
                     endcase
              end
       end

       //control data
       always @(posedge clk or posedge rst) begin
              if(next_state == CAL)
              begin
                     case(pc)
                            0:
                            begin
                                   buf_0 <=  {buff[0],16'd0};
                                   buf_1 <=  {buff[1] ,16'd0};
                                   buf_2 <=  {buff[2] ,16'd0};
                                   buf_3 <=  {buff[3] ,16'd0};
                                   buf_4 <=  {buff[4] ,16'd0};
                                   buf_5 <=  {buff[5] ,16'd0};
                                   buf_6 <=  {buff[6] ,16'd0};
                                   buf_7 <=  {buff[7] ,16'd0};
                                   buf_8 <=  {buff[8] ,16'd0};
                                   buf_9 <=  {buff[9] ,16'd0};
                                   buf_10 <= {buff[10],16'd0};
                                   buf_11 <= {buff[11],16'd0};
                                   buf_12 <= {buff[12],16'd0};
                                   buf_13 <= {buff[13],16'd0};
                                   buf_14 <= {buff[14],16'd0};
                                   buf_15 <= {buff[15],16'd0};
                            end

                            1:
                            begin
                                   buf_0 <=  {buff[16],16'd0};
                                   buf_1 <=  {buff[17],16'd0};
                                   buf_2 <=  {buff[18],16'd0};
                                   buf_3 <=  {buff[19],16'd0};
                                   buf_4 <=  {buff[20],16'd0};
                                   buf_5 <=  {buff[21],16'd0};
                                   buf_6 <=  {buff[22],16'd0};
                                   buf_7 <=  {buff[23],16'd0};
                                   buf_8 <=  {buff[24],16'd0};
                                   buf_9 <=  {buff[25],16'd0};
                                   buf_10 <= {buff[26],16'd0};
                                   buf_11 <= {buff[27],16'd0};
                                   buf_12 <= {buff[28],16'd0};
                                   buf_13 <= {buff[29],16'd0};
                                   buf_14 <= {buff[30],16'd0};
                                   buf_15 <= {buff[31],16'd0};
                            end

                            2:
                            begin
                                   buf_0  <= {buff[32],16'd0};
                                   buf_1  <= {buff[33],16'd0};
                                   buf_2  <= {buff[34],16'd0};
                                   buf_3  <= {buff[35],16'd0};
                                   buf_4  <= {buff[36],16'd0};
                                   buf_5  <= {buff[37],16'd0};
                                   buf_6  <= {buff[38],16'd0};
                                   buf_7  <= {buff[39],16'd0};
                                   buf_8  <= {buff[40],16'd0};
                                   buf_9  <= {buff[41],16'd0};
                                   buf_10 <= {buff[42],16'd0};
                                   buf_11 <= {buff[43],16'd0};
                                   buf_12 <= {buff[44],16'd0};
                                   buf_13 <= {buff[45],16'd0};
                                   buf_14 <= {buff[46],16'd0};
                                   buf_15 <= {buff[47],16'd0};
                            end

                            3:
                            begin
                                   buf_0  <= {buff[48],16'd0};
                                   buf_1  <= {buff[49],16'd0};
                                   buf_2  <= {buff[50],16'd0};
                                   buf_3  <= {buff[51],16'd0};
                                   buf_4  <= {buff[52],16'd0};
                                   buf_5  <= {buff[53],16'd0};
                                   buf_6  <= {buff[54],16'd0};
                                   buf_7  <= {buff[55],16'd0};
                                   buf_8  <= {buff[56],16'd0};
                                   buf_9  <= {buff[57],16'd0};
                                   buf_10 <= {buff[58],16'd0};
                                   buf_11 <= {buff[59],16'd0};
                                   buf_12 <= {buff[60],16'd0};
                                   buf_13 <= {buff[61],16'd0};
                                   buf_14 <= {buff[62],16'd0};
                                   buf_15 <= {buff[63],16'd0};
                            end

                            4:
                            begin
                                   buf_0  <= {buff[64],16'd0};
                                   buf_1  <= {buff[65],16'd0};
                                   buf_2  <= {buff[66],16'd0};
                                   buf_3  <= {buff[67],16'd0};
                                   buf_4  <= {buff[68],16'd0};
                                   buf_5  <= {buff[69],16'd0};
                                   buf_6  <= {buff[70],16'd0};
                                   buf_7  <= {buff[71],16'd0};
                                   buf_8  <= {buff[72],16'd0};
                                   buf_9  <= {buff[73],16'd0};
                                   buf_10 <= {buff[74],16'd0};
                                   buf_11 <= {buff[75],16'd0};
                                   buf_12 <= {buff[76],16'd0};
                                   buf_13 <= {buff[77],16'd0};
                                   buf_14 <= {buff[78],16'd0};
                                   buf_15 <= {buff[79],16'd0};
                            end

                            5:
                            begin
                                   buf_0  <= {buff[80],16'd0};
                                   buf_1  <= {buff[81],16'd0};
                                   buf_2  <= {buff[82],16'd0};
                                   buf_3  <= {buff[83],16'd0};
                                   buf_4  <= {buff[84],16'd0};
                                   buf_5  <= {buff[85],16'd0};
                                   buf_6  <= {buff[86],16'd0};
                                   buf_7  <= {buff[87],16'd0};
                                   buf_8  <= {buff[88],16'd0};
                                   buf_9  <= {buff[89],16'd0};
                                   buf_10 <= {buff[90],16'd0};
                                   buf_11 <= {buff[91],16'd0};
                                   buf_12 <= {buff[92],16'd0};
                                   buf_13 <= {buff[93],16'd0};
                                   buf_14 <= {buff[94],16'd0};
                                   buf_15 <= {buff[95],16'd0};
                            end

                            6:
                            begin
                                   buf_0  <= {buff[96] ,16'd0};
                                   buf_1  <= {buff[97] ,16'd0};
                                   buf_2  <= {buff[98] ,16'd0};
                                   buf_3  <= {buff[99] ,16'd0};
                                   buf_4  <= {buff[100],16'd0};
                                   buf_5  <= {buff[101],16'd0};
                                   buf_6  <= {buff[102],16'd0};
                                   buf_7  <= {buff[103],16'd0};
                                   buf_8  <= {buff[104],16'd0};
                                   buf_9  <= {buff[105],16'd0};
                                   buf_10 <= {buff[106],16'd0};
                                   buf_11 <= {buff[107],16'd0};
                                   buf_12 <= {buff[108],16'd0};
                                   buf_13 <= {buff[109],16'd0};
                                   buf_14 <= {buff[110],16'd0};
                                   buf_15 <= {buff[111],16'd0};
                            end

                            7:
                            begin
                                   buf_0  <= {buff[112],16'd0};
                                   buf_1  <= {buff[113],16'd0};
                                   buf_2  <= {buff[114],16'd0};
                                   buf_3  <= {buff[115],16'd0};
                                   buf_4  <= {buff[116],16'd0};
                                   buf_5  <= {buff[117],16'd0};
                                   buf_6  <= {buff[118],16'd0};
                                   buf_7  <= {buff[119],16'd0};
                                   buf_8  <= {buff[120],16'd0};
                                   buf_9  <= {buff[121],16'd0};
                                   buf_10 <= {buff[122],16'd0};
                                   buf_11 <= {buff[123],16'd0};
                                   buf_12 <= {buff[124],16'd0};
                                   buf_13 <= {buff[125],16'd0};
                                   buf_14 <= {buff[126],16'd0};
                                   buf_15 <= {buff[127],16'd0};
                            end

                            8:
                            begin
                                   buf_0  <= {buff[128],16'd0};
                                   buf_1  <= {buff[129],16'd0};
                                   buf_2  <= {buff[130],16'd0};
                                   buf_3  <= {buff[131],16'd0};
                                   buf_4  <= {buff[132],16'd0};
                                   buf_5  <= {buff[133],16'd0};
                                   buf_6  <= {buff[134],16'd0};
                                   buf_7  <= {buff[135],16'd0};
                                   buf_8  <= {buff[136],16'd0};
                                   buf_9  <= {buff[137],16'd0};
                                   buf_10 <= {buff[138],16'd0};
                                   buf_11 <= {buff[139],16'd0};
                                   buf_12 <= {buff[140],16'd0};
                                   buf_13 <= {buff[141],16'd0};
                                   buf_14 <= {buff[142],16'd0};
                                   buf_15 <= {buff[143],16'd0};
                            end

                            9:
                            begin
                                   buf_0  <= {buff[144],16'd0};
                                   buf_1  <= {buff[145],16'd0};
                                   buf_2  <= {buff[146],16'd0};
                                   buf_3  <= {buff[147],16'd0};
                                   buf_4  <= {buff[148],16'd0};
                                   buf_5  <= {buff[149],16'd0};
                                   buf_6  <= {buff[150],16'd0};
                                   buf_7  <= {buff[151],16'd0};
                                   buf_8  <= {buff[152],16'd0};
                                   buf_9  <= {buff[153],16'd0};
                                   buf_10 <= {buff[154],16'd0};
                                   buf_11 <= {buff[155],16'd0};
                                   buf_12 <= {buff[156],16'd0};
                                   buf_13 <= {buff[157],16'd0};
                                   buf_14 <= {buff[158],16'd0};
                                   buf_15 <= {buff[159],16'd0};
                            end                            
                     endcase

              end
       end




endmodule
