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
output [31:0] fft_a, fft_b;
output fft_pe_valid;

reg [31:0] W_real, W_img;



always@(*)begin
	case(power)
		0:begin
			W_real = 32'h00010000;
			W_img  = 32'h00000000;
		end
		1:begin
			W_real = 32'h0000EC83;
			W_img  = 32'hFFFF9E09;
		end
		2:begin
			W_real = 32'h0000B504;
			W_img  = 32'hFFFF4AFC;
		end
		3:begin
			W_real = 32'h000061F7;
			W_img  = 32'hFFFF137D;
		end
		4:begin
			W_real = 32'h00000000;
			W_img  = 32'hFFFF0000;
		end
		5:begin
			W_real = 32'hFFFF9E09;
			W_img  = 32'hFFFF137D;
		end
		6:begin
			W_real = 32'hFFFF4AFC;
			W_img  = 32'hFFFF4AFC;
		end
		7:begin
			W_real = 32'hFFFF137D;
			W_img  = 32'hFFFF9E09;
		end
	endcase

end
endmodule

