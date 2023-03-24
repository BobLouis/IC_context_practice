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
output done;                      
output [3:0] freq;

reg [3:0]cnt;
reg [3:0]out_cnt;
reg [2:0]pos_cnt;
reg signed [15:0]arr[0:15];

reg signed[31:0]buff[0:15];

assign done = (out_cnt == 11);

wire signed[31:0]pe_1_0_a;
wire signed[31:0]pe_1_0_b;
wire signed[31:0]pe_1_1_a;
wire signed[31:0]pe_1_1_b;
wire signed[31:0]pe_1_2_a;
wire signed[31:0]pe_1_2_b;
wire signed[31:0]pe_1_3_a;
wire signed[31:0]pe_1_3_b;
wire signed[31:0]pe_1_4_a;
wire signed[31:0]pe_1_4_b;
wire signed[31:0]pe_1_5_a;
wire signed[31:0]pe_1_5_b;
wire signed[31:0]pe_1_6_a;
wire signed[31:0]pe_1_6_b;
wire signed[31:0]pe_1_7_a;
wire signed[31:0]pe_1_7_b;

wire signed[31:0]pe_2_0_a;
wire signed[31:0]pe_2_0_b;
wire signed[31:0]pe_2_1_a;
wire signed[31:0]pe_2_1_b;
wire signed[31:0]pe_2_2_a;
wire signed[31:0]pe_2_2_b;
wire signed[31:0]pe_2_3_a;
wire signed[31:0]pe_2_3_b;
wire signed[31:0]pe_2_4_a;
wire signed[31:0]pe_2_4_b;
wire signed[31:0]pe_2_5_a;
wire signed[31:0]pe_2_5_b;
wire signed[31:0]pe_2_6_a;
wire signed[31:0]pe_2_6_b;
wire signed[31:0]pe_2_7_a;
wire signed[31:0]pe_2_7_b;

wire signed[31:0]pe_3_0_a;
wire signed[31:0]pe_3_0_b;
wire signed[31:0]pe_3_1_a;
wire signed[31:0]pe_3_1_b;
wire signed[31:0]pe_3_2_a;
wire signed[31:0]pe_3_2_b;
wire signed[31:0]pe_3_3_a;
wire signed[31:0]pe_3_3_b;
wire signed[31:0]pe_3_4_a;
wire signed[31:0]pe_3_4_b;
wire signed[31:0]pe_3_5_a;
wire signed[31:0]pe_3_5_b;
wire signed[31:0]pe_3_6_a;
wire signed[31:0]pe_3_6_b;
wire signed[31:0]pe_3_7_a;
wire signed[31:0]pe_3_7_b;

wire signed[31:0]pe_4_0_a;
wire signed[31:0]pe_4_0_b;
wire signed[31:0]pe_4_1_a;
wire signed[31:0]pe_4_1_b;
wire signed[31:0]pe_4_2_a;
wire signed[31:0]pe_4_2_b;
wire signed[31:0]pe_4_3_a;
wire signed[31:0]pe_4_3_b;
wire signed[31:0]pe_4_4_a;
wire signed[31:0]pe_4_4_b;
wire signed[31:0]pe_4_5_a;
wire signed[31:0]pe_4_5_b;
wire signed[31:0]pe_4_6_a;
wire signed[31:0]pe_4_6_b;
wire signed[31:0]pe_4_7_a;
wire signed[31:0]pe_4_7_b;



FFT_PE pe_1_1(.clk(clk), .rst(rst), .a(buff[0]), .b(buff[8]), .power(3'd0), .ab_valid(1'd1)
                , .fft_a(pe_1_0_a), .fft_b(pe_1_0_b), .fft_pe_valid());

FFT_PE pe_1_2(.clk(clk), .rst(rst), .a(buff[1]), .b(buff[9]), .power(3'd1), .ab_valid(1'd1)
                , .fft_a(pe_1_1_a), .fft_b(pe_1_1_b), .fft_pe_valid());

FFT_PE pe_1_3(.clk(clk), .rst(rst), .a(buff[2]), .b(buff[10]), .power(3'd2), .ab_valid(1'd1)
                , .fft_a(pe_1_2_a), .fft_b(pe_1_2_b), .fft_pe_valid());

FFT_PE pe_1_4(.clk(clk), .rst(rst), .a(buff[3]), .b(buff[11]), .power(3'd3), .ab_valid(1'd1)
                , .fft_a(pe_1_3_a), .fft_b(pe_1_3_b), .fft_pe_valid());

FFT_PE pe_1_5(.clk(clk), .rst(rst), .a(buff[4]), .b(buff[12]), .power(3'd4), .ab_valid(1'd1)
                , .fft_a(pe_1_4_a), .fft_b(pe_1_4_b), .fft_pe_valid());

FFT_PE pe_1_6(.clk(clk), .rst(rst), .a(buff[5]), .b(buff[13]), .power(3'd5), .ab_valid(1'd1)
                , .fft_a(pe_1_5_a), .fft_b(pe_1_5_b), .fft_pe_valid());

FFT_PE pe_1_7(.clk(clk), .rst(rst), .a(buff[6]), .b(buff[14]), .power(3'd6), .ab_valid(1'd1)
                , .fft_a(pe_1_6_a), .fft_b(pe_1_6_b), .fft_pe_valid());

FFT_PE pe_1_8(.clk(clk), .rst(rst), .a(buff[7]), .b(buff[15]), .power(3'd7), .ab_valid(1'd1)
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


//output assign
assign fft_d0  = pe_4_0_a;
assign fft_d1  = pe_4_4_a;
assign fft_d2  = pe_4_2_a;
assign fft_d3  = pe_4_6_a;
assign fft_d4  = pe_4_1_a;
assign fft_d5  = pe_4_5_a;
assign fft_d6  = pe_4_3_a;
assign fft_d7  = pe_4_7_a;
assign fft_d8  = pe_4_0_b;
assign fft_d9  = pe_4_4_b;
assign fft_d10 = pe_4_2_b;
assign fft_d11 = pe_4_6_b;
assign fft_d12 = pe_4_1_b;
assign fft_d13 = pe_4_5_b;
assign fft_d14 = pe_4_3_b;
assign fft_d15 = pe_4_7_b;


wire  [32:0]abs[0:15];  

assign  abs[0] =  pe_4_0_a[31:16]  * pe_4_0_a[31:16]  + pe_4_0_a[15:0]  * pe_4_0_a[15:0]  ;
assign  abs[1] =  pe_4_4_a[31:16]  * pe_4_4_a[31:16]  + pe_4_4_a[15:0]  * pe_4_4_a[15:0]  ;
assign  abs[2] =  pe_4_2_a[31:16]  * pe_4_2_a[31:16]  + pe_4_2_a[15:0]  * pe_4_2_a[15:0]  ;
assign  abs[3] =  pe_4_6_a[31:16]  * pe_4_6_a[31:16]  + pe_4_6_a[15:0]  * pe_4_6_a[15:0]  ;
assign  abs[4] =  pe_4_1_a[31:16]  * pe_4_1_a[31:16]  + pe_4_1_a[15:0]  * pe_4_1_a[15:0]  ;
assign  abs[5] =  pe_4_5_a[31:16]  * pe_4_5_a[31:16]  + pe_4_5_a[15:0]  * pe_4_5_a[15:0]  ;
assign  abs[6] =  pe_4_3_a[31:16]  * pe_4_3_a[31:16]  + pe_4_3_a[15:0]  * pe_4_3_a[15:0]  ;
assign  abs[7] =  pe_4_7_a[31:16]  * pe_4_7_a[31:16]  + pe_4_7_a[15:0]  * pe_4_7_a[15:0]  ;
assign  abs[8] =  pe_4_0_b[31:16]  * pe_4_0_b[31:16]  + pe_4_0_b[15:0]  * pe_4_0_b[15:0]  ;
assign  abs[9] =  pe_4_4_b[31:16]  * pe_4_4_b[31:16]  + pe_4_4_b[15:0]  * pe_4_4_b[15:0]  ;
assign  abs[10] = pe_4_2_b[31:16] * pe_4_2_b[31:16] + pe_4_2_b[15:0] * pe_4_2_b[15:0] ;
assign  abs[11] = pe_4_6_b[31:16] * pe_4_6_b[31:16] + pe_4_6_b[15:0] * pe_4_6_b[15:0] ;
assign  abs[12] = pe_4_1_b[31:16] * pe_4_1_b[31:16] + pe_4_1_b[15:0] * pe_4_1_b[15:0] ;
assign  abs[13] = pe_4_5_b[31:16] * pe_4_5_b[31:16] + pe_4_5_b[15:0] * pe_4_5_b[15:0] ;
assign  abs[14] = pe_4_3_b[31:16] * pe_4_3_b[31:16] + pe_4_3_b[15:0] * pe_4_3_b[15:0] ;
assign  abs[15] = pe_4_7_b[31:16] * pe_4_7_b[31:16] + pe_4_7_b[15:0] * pe_4_7_b[15:0] ;

wire [3:0]ana_1_1 = (abs[0] >= abs[1]) ? 0 : 1;
wire [3:0]ana_1_2 = (abs[2] >= abs[3]) ? 2 : 3;
wire [3:0]ana_1_3 = (abs[4] >= abs[5]) ? 4 : 5;
wire [3:0]ana_1_4 = (abs[6] >= abs[7]) ? 6 : 7;
wire [3:0]ana_1_5 = (abs[8] >= abs[9]) ? 8 : 9;
wire [3:0]ana_1_6 = (abs[10] >= abs[11]) ? 10 : 11;
wire [3:0]ana_1_7 = (abs[12] >= abs[13]) ? 12 : 13;
wire [3:0]ana_1_8 = (abs[14] >= abs[15]) ? 14 : 15;

wire [3:0]ana_2_1 = (abs[ana_1_1] >= abs[ana_1_2]) ? ana_1_1 : ana_1_2;
wire [3:0]ana_2_2 = (abs[ana_1_3] >= abs[ana_1_4]) ? ana_1_3 : ana_1_4;
wire [3:0]ana_2_3 = (abs[ana_1_5] >= abs[ana_1_6]) ? ana_1_5 : ana_1_6;
wire [3:0]ana_2_4 = (abs[ana_1_7] >= abs[ana_1_8]) ? ana_1_7 : ana_1_8;

wire [3:0]ana_3_1 = (abs[ana_2_1] >= abs[ana_2_2]) ? ana_2_1 : ana_2_2;
wire [3:0]ana_3_2 = (abs[ana_2_3] >= abs[ana_2_4]) ? ana_2_3 : ana_2_4;

assign freq = (abs[ana_3_1] >= abs[ana_3_2]) ? ana_3_1 : ana_3_2;

integer i;


always@(posedge clk or posedge rst) begin
    if(rst)begin
        cnt <= 0;
    end 
    else begin
        if(data_valid == 1)begin
            arr[cnt] <= data;
        end

        if(cnt == 15)begin
            cnt <= 0;
            for(i=0;i<15;i=i+1)
                buff[i] <= {arr[i],16'd0};
            buff[15] <= {data,16'd0};
        end
        else 
            cnt <= cnt + 1;
    end
end

always@(negedge clk or posedge rst)begin
    if(rst)begin
        pos_cnt <= 0;
        fft_valid <= 0;
        out_cnt <= 0;
    end
    else begin
        if(pos_cnt == 5)begin
            fft_valid <= 1;
            pos_cnt <= 0;
            out_cnt <= out_cnt + 1;
        end
        else if(cnt == 15 || pos_cnt != 0)
            pos_cnt <= pos_cnt + 1;
        else 
            fft_valid <= 0;
    end

end



endmodule
