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

       wire [15:0]pe_1_0_a;
       wire [15:0]pe_1_0_b;
       wire [15:0]pe_1_1_a;
       wire [15:0]pe_1_1_b;
       wire [15:0]pe_1_2_a;
       wire [15:0]pe_1_2_b;
       wire [15:0]pe_1_3_a;
       wire [15:0]pe_1_3_b;
       wire [15:0]pe_1_4_a;
       wire [15:0]pe_1_4_b;
       wire [15:0]pe_1_5_a;
       wire [15:0]pe_1_5_b;
       wire [15:0]pe_1_6_a;
       wire [15:0]pe_1_6_b;
       wire [15:0]pe_1_7_a;
       wire [15:0]pe_1_7_b;

       wire [15:0]pe_2_0_a;
       wire [15:0]pe_2_0_b;
       wire [15:0]pe_2_1_a;
       wire [15:0]pe_2_1_b;
       wire [15:0]pe_2_2_a;
       wire [15:0]pe_2_2_b;
       wire [15:0]pe_2_3_a;
       wire [15:0]pe_2_3_b;
       wire [15:0]pe_2_4_a;
       wire [15:0]pe_2_4_b;
       wire [15:0]pe_2_5_a;
       wire [15:0]pe_2_5_b;
       wire [15:0]pe_2_6_a;
       wire [15:0]pe_2_6_b;
       wire [15:0]pe_2_7_a;
       wire [15:0]pe_2_7_b;

       wire [15:0]pe_3_0_a;
       wire [15:0]pe_3_0_b;
       wire [15:0]pe_3_1_a;
       wire [15:0]pe_3_1_b;
       wire [15:0]pe_3_2_a;
       wire [15:0]pe_3_2_b;
       wire [15:0]pe_3_3_a;
       wire [15:0]pe_3_3_b;
       wire [15:0]pe_3_4_a;
       wire [15:0]pe_3_4_b;
       wire [15:0]pe_3_5_a;
       wire [15:0]pe_3_5_b;
       wire [15:0]pe_3_6_a;
       wire [15:0]pe_3_6_b;
       wire [15:0]pe_3_7_a;
       wire [15:0]pe_3_7_b;

       wire [15:0]pe_4_0_a;
       wire [15:0]pe_4_0_b;
       wire [15:0]pe_4_1_a;
       wire [15:0]pe_4_1_b;
       wire [15:0]pe_4_2_a;
       wire [15:0]pe_4_2_b;
       wire [15:0]pe_4_3_a;
       wire [15:0]pe_4_3_b;
       wire [15:0]pe_4_4_a;
       wire [15:0]pe_4_4_b;
       wire [15:0]pe_4_5_a;
       wire [15:0]pe_4_5_b;
       wire [15:0]pe_4_6_a;
       wire [15:0]pe_4_6_b;
       wire [15:0]pe_4_7_a;
       wire [15:0]pe_4_7_b;


       assign fft_d0 = {}


       FFT_PE pe_1_1(.clk(clk), .rst(rst), .a(buff_0), .b(buff_8), .power(0), .ab_valid(1)
                     , .fft_a(pe_1_0_a), .fft_b(pe_1_0_b), .fft_pe_valid());

       FFT_PE pe_1_2(.clk(clk), .rst(rst), .a(buff_1), .b(buff_9), .power(1), .ab_valid(1)
                     , .fft_a(pe_1_1_a), .fft_b(pe_1_1_b), .fft_pe_valid());

       FFT_PE pe_1_3(.clk(clk), .rst(rst), .a(buff_2), .b(buff_10), .power(2), .ab_valid(1)
                     , .fft_a(pe_1_2_a), .fft_b(pe_1_2_b), .fft_pe_valid());

       FFT_PE pe_1_4(.clk(clk), .rst(rst), .a(buff_3), .b(buff_11), .power(3), .ab_valid(1)
                     , .fft_a(pe_1_3_a), .fft_b(pe_1_3_b), .fft_pe_valid());

       FFT_PE pe_1_5(.clk(clk), .rst(rst), .a(buff_4), .b(buff_12), .power(4), .ab_valid(1)
                     , .fft_a(pe_1_4_a), .fft_b(pe_1_4_b), .fft_pe_valid());

       FFT_PE pe_1_6(.clk(clk), .rst(rst), .a(buff_5), .b(buff_13), .power(5), .ab_valid(1)
                     , .fft_a(pe_1_5_a), .fft_b(pe_1_5_b), .fft_pe_valid());

       FFT_PE pe_1_7(.clk(clk), .rst(rst), .a(buff_6), .b(buff_14), .power(6), .ab_valid(1)
                     , .fft_a(pe_1_6_a), .fft_b(pe_1_6_b), .fft_pe_valid());

       FFT_PE pe_1_8(.clk(clk), .rst(rst), .a(buff_7), .b(buff_15), .power(7), .ab_valid(1)
                     , .fft_a(pe_1_7_a), .fft_b(pe_1_7_b), .fft_pe_valid());


       FFT_PE pe_2_1(.clk(clk), .rst(rst), .a(pe_1_0_a), .b(pe_1_4_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_2_0_a), .fft_b(pe_2_0_b), .fft_pe_valid());

       FFT_PE pe_2_2(.clk(clk), .rst(rst), .a(pe_1_1_a), .b(pe_1_5_a), .power(2), .ab_valid(1)
                     , .fft_a(pe_2_1_a), .fft_b(pe_2_1_b), .fft_pe_valid());

       FFT_PE pe_2_3(.clk(clk), .rst(rst), .a(pe_1_2_a), .b(pe_1_6_a), .power(4), .ab_valid(1)
                     , .fft_a(pe_2_2_a), .fft_b(pe_2_2_b), .fft_pe_valid());

       FFT_PE pe_2_4(.clk(clk), .rst(rst), .a(pe_1_3_a), .b(pe_1_7_a), .power(6), .ab_valid(1)
                     , .fft_a(pe_2_3_a), .fft_b(pe_2_3_b), .fft_pe_valid());

       FFT_PE pe_2_5(.clk(clk), .rst(rst), .a(pe_1_0_b), .b(pe_1_4_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_2_4_a), .fft_b(pe_2_4_b), .fft_pe_valid());

       FFT_PE pe_2_6(.clk(clk), .rst(rst), .a(pe_1_1_b), .b(pe_1_5_b), .power(2), .ab_valid(1)
                     , .fft_a(pe_2_5_a), .fft_b(pe_2_5_b), .fft_pe_valid());

       FFT_PE pe_2_7(.clk(clk), .rst(rst), .a(pe_1_2_b), .b(pe_1_6_b), .power(4), .ab_valid(1)
                     , .fft_a(pe_2_6_a), .fft_b(pe_2_6_b), .fft_pe_valid());

       FFT_PE pe_2_8(.clk(clk), .rst(rst), .a(pe_1_3_b), .b(pe_1_7_b), .power(6), .ab_valid(1)
                     , .fft_a(pe_2_7_a), .fft_b(pe_2_7_b), .fft_pe_valid());


       FFT_PE pe_3_1(.clk(clk), .rst(rst), .a(pe_2_0_a), .b(pe_2_2_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_3_0_a), .fft_b(pe_3_0_b), .fft_pe_valid());

       FFT_PE pe_3_2(.clk(clk), .rst(rst), .a(pe_2_1_a), .b(pe_2_3_a), .power(4), .ab_valid(1)
                     , .fft_a(pe_3_1_a), .fft_b(pe_3_1_b), .fft_pe_valid());

       FFT_PE pe_3_3(.clk(clk), .rst(rst), .a(pe_2_0_b), .b(pe_2_2_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_3_2_a), .fft_b(pe_3_2_b), .fft_pe_valid());

       FFT_PE pe_3_4(.clk(clk), .rst(rst), .a(pe_2_1_b), .b(pe_2_3_b), .power(4), .ab_valid(1)
                     , .fft_a(pe_3_3_a), .fft_b(pe_3_3_b), .fft_pe_valid());
                     
       FFT_PE pe_3_5(.clk(clk), .rst(rst), .a(pe_2_4_a), .b(pe_2_6_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_3_4_a), .fft_b(pe_3_4_b), .fft_pe_valid());

       FFT_PE pe_3_6(.clk(clk), .rst(rst), .a(pe_2_5_a), .b(pe_2_7_a), .power(4), .ab_valid(1)
                     , .fft_a(pe_3_5_a), .fft_b(pe_3_5_b), .fft_pe_valid());

       FFT_PE pe_3_7(.clk(clk), .rst(rst), .a(pe_2_4_b), .b(pe_2_6_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_3_6_a), .fft_b(pe_3_6_b), .fft_pe_valid());

       FFT_PE pe_3_8(.clk(clk), .rst(rst), .a(pe_2_5_b), .b(pe_2_7_b), .power(4), .ab_valid(1)
                     , .fft_a(pe_3_7_a), .fft_b(pe_3_7_b), .fft_pe_valid());


       FFT_PE pe_4_1(.clk(clk), .rst(rst), .a(pe_3_0_a), .b(pe_3_1_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_0_a), .fft_b(pe_4_0_b), .fft_pe_valid());

       FFT_PE pe_4_2(.clk(clk), .rst(rst), .a(pe_3_0_b), .b(pe_3_1_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_1_a), .fft_b(pe_4_1_b), .fft_pe_valid());

       FFT_PE pe_4_3(.clk(clk), .rst(rst), .a(pe_3_2_a), .b(pe_3_3_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_2_a), .fft_b(pe_4_2_b), .fft_pe_valid());

       FFT_PE pe_4_4(.clk(clk), .rst(rst), .a(pe_3_2_b), .b(pe_3_3_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_3_a), .fft_b(pe_4_3_b), .fft_pe_valid());
                     
       FFT_PE pe_4_5(.clk(clk), .rst(rst), .a(pe_3_4_a), .b(pe_3_5_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_4_a), .fft_b(pe_4_4_b), .fft_pe_valid());

       FFT_PE pe_4_6(.clk(clk), .rst(rst), .a(pe_3_4_b), .b(pe_3_5_b), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_5_a), .fft_b(pe_4_5_b), .fft_pe_valid());

       FFT_PE pe_4_7(.clk(clk), .rst(rst), .a(pe_3_6_a), .b(pe_3_7_a), .power(0), .ab_valid(1)
                     , .fft_a(pe_4_6_a), .fft_b(pe_4_6_b), .fft_pe_valid());

       FFT_PE pe_4_8(.clk(clk), .rst(rst), .a(pe_3_6_b), .b(pe_3_7_b), .power(0), .ab_valid(1)
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
       wire  [32:0]abs[0] =  fft_0[31:16]  * fft_0[31:16]  + fft_d0[15:0]  * fft_d0[15:0]  ;
       wire  [32:0]abs[1] =  fft_1[31:16]  * fft_1[31:16]  + fft_d1[15:0]  * fft_d1[15:0]  ;
       wire  [32:0]abs[2] =  fft_2[31:16]  * fft_2[31:16]  + fft_d2[15:0]  * fft_d2[15:0]  ;
       wire  [32:0]abs[3] =  fft_3[31:16]  * fft_3[31:16]  + fft_d3[15:0]  * fft_d3[15:0]  ;
       wire  [32:0]abs[4] =  fft_4[31:16]  * fft_4[31:16]  + fft_d4[15:0]  * fft_d4[15:0]  ;
       wire  [32:0]abs[5] =  fft_5[31:16]  * fft_5[31:16]  + fft_d5[15:0]  * fft_d5[15:0]  ;
       wire  [32:0]abs[6] =  fft_6[31:16]  * fft_6[31:16]  + fft_d6[15:0]  * fft_d6[15:0]  ;
       wire  [32:0]abs[7] =  fft_7[31:16]  * fft_7[31:16]  + fft_d7[15:0]  * fft_d7[15:0]  ;
       wire  [32:0]abs[8] =  fft_8[31:16]  * fft_8[31:16]  + fft_d8[15:0]  * fft_d8[15:0]  ;
       wire  [32:0]abs[9] =  fft_9[31:16]  * fft_9[31:16]  + fft_d9[15:0]  * fft_d9[15:0]  ;
       wire  [32:0]abs[10] = fft_10[31:16] * fft_10[31:16] + fft_d10[15:0] * fft_d10[15:0] ;
       wire  [32:0]abs[11] = fft_11[31:16] * fft_11[31:16] + fft_d11[15:0] * fft_d11[15:0] ;
       wire  [32:0]abs[12] = fft_12[31:16] * fft_12[31:16] + fft_d12[15:0] * fft_d12[15:0] ;
       wire  [32:0]abs[13] = fft_13[31:16] * fft_13[31:16] + fft_d13[15:0] * fft_d13[15:0] ;
       wire  [32:0]abs[14] = fft_14[31:16] * fft_14[31:16] + fft_d14[15:0] * fft_d14[15:0] ;
       wire  [32:0]abs[15] = fft_15[31:16] * fft_15[31:16] + fft_d15[15:0] * fft_d15[15:0] ;
       
       wire [3:0]ana_1_1 = (abs_0 > abs_1) ? 0 : 1;
       wire [3:0]ana_1_2 = (abs_2 > abs_3) ? 2 : 3;
       wire [3:0]ana_1_3 = (abs_4 > abs_5) ? 4 : 5;
       wire [3:0]ana_1_4 = (abs_6 > abs_7) ? 6 : 7;
       wire [3:0]ana_1_5 = (abs_8 > abs_9) ? 8 : 9;
       wire [3:0]ana_1_6 = (abs_10 > abs_11) ? 10 : 11;
       wire [3:0]ana_1_7 = (abs_12 > abs_13) ? 12 : 13;
       wire [3:0]ana_1_8 = (abs_14 > abs_15) ? 14 : 15;

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
                                   buf_0 <= buff[0];
                                   buf_1 <= buff[1];
                                   buf_2 <= buff[2];
                                   buf_3 <= buff[3];
                                   buf_4 <= buff[4];
                                   buf_5 <= buff[5];
                                   buf_6 <= buff[6];
                                   buf_7 <= buff[7];
                                   buf_8 <= buff[8];
                                   buf_9 <= buff[9];
                                   buf_10 <= buff[10];
                                   buf_11 <= buff[11];
                                   buf_12 <= buff[12];
                                   buf_13 <= buff[13];
                                   buf_14 <= buff[14];
                                   buf_15 <= buff[15];
                            end

                            1:
                            begin
                                   buf_0 <= buff[16];
                                   buf_1 <= buff[17];
                                   buf_2 <= buff[18];
                                   buf_3 <= buff[19];
                                   buf_4 <= buff[20];
                                   buf_5 <= buff[21];
                                   buf_6 <= buff[22];
                                   buf_7 <= buff[23];
                                   buf_8 <= buff[24];
                                   buf_9 <= buff[25];
                                   buf_10 <= buff[26];
                                   buf_11 <= buff[27];
                                   buf_12 <= buff[28];
                                   buf_13 <= buff[29];
                                   buf_14 <= buff[30];
                                   buf_15 <= buff[31];
                            end

                            2:
                            begin
                                   buf_0  <= buff[32];
                                   buf_1  <= buff[33];
                                   buf_2  <= buff[34];
                                   buf_3  <= buff[35];
                                   buf_4  <= buff[36];
                                   buf_5  <= buff[37];
                                   buf_6  <= buff[38];
                                   buf_7  <= buff[39];
                                   buf_8  <= buff[40];
                                   buf_9  <= buff[41];
                                   buf_10 <= buff[42];
                                   buf_11 <= buff[43];
                                   buf_12 <= buff[44];
                                   buf_13 <= buff[45];
                                   buf_14 <= buff[46];
                                   buf_15 <= buff[47];
                            end

                            3:
                            begin
                                   buf_0  <= buff[48];
                                   buf_1  <= buff[49];
                                   buf_2  <= buff[50];
                                   buf_3  <= buff[51];
                                   buf_4  <= buff[52];
                                   buf_5  <= buff[53];
                                   buf_6  <= buff[54];
                                   buf_7  <= buff[55];
                                   buf_8  <= buff[56];
                                   buf_9  <= buff[57];
                                   buf_10 <= buff[58];
                                   buf_11 <= buff[59];
                                   buf_12 <= buff[60];
                                   buf_13 <= buff[61];
                                   buf_14 <= buff[62];
                                   buf_15 <= buff[63];
                            end

                            4:
                            begin
                                   buf_0  <= buff[64];
                                   buf_1  <= buff[65];
                                   buf_2  <= buff[66];
                                   buf_3  <= buff[67];
                                   buf_4  <= buff[68];
                                   buf_5  <= buff[69];
                                   buf_6  <= buff[70];
                                   buf_7  <= buff[71];
                                   buf_8  <= buff[72];
                                   buf_9  <= buff[73];
                                   buf_10 <= buff[74];
                                   buf_11 <= buff[75];
                                   buf_12 <= buff[76];
                                   buf_13 <= buff[77];
                                   buf_14 <= buff[78];
                                   buf_15 <= buff[79];
                            end

                            5:
                            begin
                                   buf_0  <= buff[80];
                                   buf_1  <= buff[81];
                                   buf_2  <= buff[82];
                                   buf_3  <= buff[83];
                                   buf_4  <= buff[84];
                                   buf_5  <= buff[85];
                                   buf_6  <= buff[86];
                                   buf_7  <= buff[87];
                                   buf_8  <= buff[88];
                                   buf_9  <= buff[89];
                                   buf_10 <= buff[90];
                                   buf_11 <= buff[91];
                                   buf_12 <= buff[92];
                                   buf_13 <= buff[93];
                                   buf_14 <= buff[94];
                                   buf_15 <= buff[95];
                            end

                            6:
                            begin
                                   buf_0  <= buff[96];
                                   buf_1  <= buff[97];
                                   buf_2  <= buff[98];
                                   buf_3  <= buff[99];
                                   buf_4  <= buff[100];
                                   buf_5  <= buff[101];
                                   buf_6  <= buff[102];
                                   buf_7  <= buff[103];
                                   buf_8  <= buff[104];
                                   buf_9  <= buff[105];
                                   buf_10 <= buff[106];
                                   buf_11 <= buff[107];
                                   buf_12 <= buff[108];
                                   buf_13 <= buff[109];
                                   buf_14 <= buff[110];
                                   buf_15 <= buff[111];
                            end

                            7:
                            begin
                                   buf_0  <= buff[112];
                                   buf_1  <= buff[113];
                                   buf_2  <= buff[114];
                                   buf_3  <= buff[115];
                                   buf_4  <= buff[116];
                                   buf_5  <= buff[117];
                                   buf_6  <= buff[118];
                                   buf_7  <= buff[119];
                                   buf_8  <= buff[120];
                                   buf_9  <= buff[121];
                                   buf_10 <= buff[122];
                                   buf_11 <= buff[123];
                                   buf_12 <= buff[124];
                                   buf_13 <= buff[125];
                                   buf_14 <= buff[126];
                                   buf_15 <= buff[127];
                            end

                            8:
                            begin
                                   buf_0  <= buff[128];
                                   buf_1  <= buff[129];
                                   buf_2  <= buff[130];
                                   buf_3  <= buff[131];
                                   buf_4  <= buff[132];
                                   buf_5  <= buff[133];
                                   buf_6  <= buff[134];
                                   buf_7  <= buff[135];
                                   buf_8  <= buff[136];
                                   buf_9  <= buff[137];
                                   buf_10 <= buff[138];
                                   buf_11 <= buff[139];
                                   buf_12 <= buff[140];
                                   buf_13 <= buff[141];
                                   buf_14 <= buff[142];
                                   buf_15 <= buff[143];
                            end

                            9:
                            begin
                                   buf_0  <= buff[144];
                                   buf_1  <= buff[145];
                                   buf_2  <= buff[146];
                                   buf_3  <= buff[147];
                                   buf_4  <= buff[148];
                                   buf_5  <= buff[149];
                                   buf_6  <= buff[150];
                                   buf_7  <= buff[151];
                                   buf_8  <= buff[152];
                                   buf_9  <= buff[153];
                                   buf_10 <= buff[154];
                                   buf_11 <= buff[155];
                                   buf_12 <= buff[156];
                                   buf_13 <= buff[157];
                                   buf_14 <= buff[158];
                                   buf_15 <= buff[159];
                            end                            
                     endcase

              end
       end




endmodule
