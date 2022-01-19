`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
 */
module CS(Y,
          X,
          reset,
          clk);
    
    input clk, reset;
    input [7:0] X;
    output reg [9:0] Y;
    wire [12:0]y_tmp;
    reg [12:0]x_reg[8:0];
    wire [12:0]x_reg_tmp[8:0];
    wire [12:0]x_avg;
    reg [3:0]cnt;
    integer i;
    wire [9:0]a,b,c,d,e,f,g,x_appr;
    
    always @(posedge clk or posedge reset) begin
        
        if (reset)begin
            for(i = 0;i < 9 ;i = i+1)begin
                x_reg[i] <= 0;
            end
            cnt <= 0;
        end
        else begin
            x_reg[8] <= X; //load data
            for(i = 0; i < 8; i = i+1)begin
                x_reg[i] <= x_reg[i+1];
            end
            if (cnt<4'd9)begin
                cnt <= cnt + 4'd1;
            end
            else begin
                cnt <= cnt;
            end
        end
    end

    always @(negedge clk) begin
        if(cnt == 4'd9)begin
          Y <= y_tmp[12:3];
        end
        else begin
          Y <= 0;
        end
    end

    assign x_avg = (x_reg[0]+x_reg[1]+x_reg[2]+x_reg[3]+x_reg[4]+x_reg[5]+x_reg[6]+x_reg[7]+x_reg[8])/9;
    assign x_reg_tmp[0] = (x_reg[0] <= x_avg)? x_reg[0]:0;
    assign x_reg_tmp[1] = (x_reg[1] <= x_avg)? x_reg[1]:0;
    assign x_reg_tmp[2] = (x_reg[2] <= x_avg)? x_reg[2]:0;
    assign x_reg_tmp[3] = (x_reg[3] <= x_avg)? x_reg[3]:0;
    assign x_reg_tmp[4] = (x_reg[4] <= x_avg)? x_reg[4]:0;
    assign x_reg_tmp[5] = (x_reg[5] <= x_avg)? x_reg[5]:0;
    assign x_reg_tmp[6] = (x_reg[6] <= x_avg)? x_reg[6]:0;
    assign x_reg_tmp[7] = (x_reg[7] <= x_avg)? x_reg[7]:0;
    assign x_reg_tmp[8] = (x_reg[8] <= x_avg)? x_reg[8]:0;
    
    
    assign a = (x_reg_tmp[0]>x_reg_tmp[1]) ? x_reg_tmp[0] : x_reg_tmp[1];
    assign b = (x_reg_tmp[2]>x_reg_tmp[3]) ? x_reg_tmp[2] : x_reg_tmp[3];
    assign c = (x_reg_tmp[4]>x_reg_tmp[5]) ? x_reg_tmp[4] : x_reg_tmp[5];
    assign d = (x_reg_tmp[6]>x_reg_tmp[7]) ? x_reg_tmp[6] : x_reg_tmp[7];

    assign e = (x_reg_tmp[8]>a) ? x_reg_tmp[8] : a;
    
    assign f = (b>c)?b:c;
    assign g = (d>e)?d:e;
    
    assign x_appr = (f>g)?f:g;
    assign y_tmp = x_reg[0]+x_appr+x_reg[1]+x_appr+x_reg[2]+x_appr+x_reg[3]+x_appr+x_reg[4]+x_appr+x_reg[5]+x_appr+x_reg[6]+x_appr+x_reg[7]+x_appr+x_reg[8]+x_appr;
endmodule
    
