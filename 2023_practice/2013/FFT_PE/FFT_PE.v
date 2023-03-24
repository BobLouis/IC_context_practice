module FFT_PE(
			 clk, 
			 rst, 			 
			 a, 
			 b,
			 power,			 
			 ab_valid, 
			 fft_a, 
			 fft_b,
			 fft_pe_valid
			 );
input clk, rst; 		 
input signed [31:0] a, b;
input [2:0] power;
input ab_valid;		
output reg[31:0] fft_a, fft_b;
output reg fft_pe_valid;

reg signed[31:0] W_real, W_img;
reg signed[15:0] a_real, a_img, b_real, b_img;
reg signed[31:0] a_real_tmp, a_img_tmp, b_real_tmp, b_img_tmp;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		a_real <= 0;
		a_img <= 0;
		b_real <= 0;
		b_img <= 0;
		fft_pe_valid <= 0;
	end
	else begin
		if(ab_valid == 1)begin
			if(fft_pe_valid == 0)begin
				fft_pe_valid <= 1;
			end

			a_real <= a[31:16];
			a_img <= a[15:0];
			b_real <= b[31:16];
			b_img <= b[15:0];
		end
	end
end

always@(negedge clk)begin
	fft_a <= {a_real_tmp[15:0],a_img_tmp[15:0]};
	fft_b <= {b_real_tmp[31:16],b_img_tmp[31:16]};
end

always@(*)begin
	a_real_tmp = a_real+b_real;
	a_img_tmp  = a_img +b_img;
	b_real_tmp = 17'(a_real-b_real)*W_real + 17'(b_img-a_img)*W_img;
	b_img_tmp =  17'(a_real-b_real)*W_img + 17'(a_img-b_img)*W_real;
end


always@(*)begin
	case(power)
		0:begin W_real = 32'h00010000; W_img  = 32'h00000000; end
		1:begin W_real = 32'h0000EC83; W_img  = 32'hFFFF9E09; end
		2:begin W_real = 32'h0000B504; W_img  = 32'hFFFF4AFC; end
		3:begin W_real = 32'h000061F7; W_img  = 32'hFFFF137D; end
		4:begin W_real = 32'h00000000; W_img  = 32'hFFFF0000; end
		5:begin W_real = 32'hFFFF9E09; W_img  = 32'hFFFF137D; end
		6:begin W_real = 32'hFFFF4AFC; W_img  = 32'hFFFF4AFC; end
		7:begin W_real = 32'hFFFF137D; W_img  = 32'hFFFF9E09; end
	endcase
end
endmodule

