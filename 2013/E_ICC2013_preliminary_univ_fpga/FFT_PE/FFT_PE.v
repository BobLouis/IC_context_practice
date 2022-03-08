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


	reg [2:0]state, next_state;
	reg [31:0]W_real,W_img;
	reg [31:0]data_a,data_b;


	parameter IDLE = 3'd0;
	parameter READ = 3'd1;
	parameter WRITE = 3'd2;
	parameter FINISH = 3'd3;

	always @(posedge clk or posedge rst) begin
		if(rst == 1) state <= IDLE;
		else state <= next_state;
	end

	always@(*)begin
		case(power)
			3'd0:begin W_real=32'h00010000; W_img=32'h00000000; end
			3'd1:begin W_real=32'h0000EC83; W_img=32'hFFFF9E09; end
			3'd2:begin W_real=32'h0000B504; W_img=32'hFFFF4AFC; end
			3'd3:begin W_real=32'h000061F7; W_img=32'hFFFF137D; end
			3'd4:begin W_real=32'h00000000; W_img=32'hFFFF0000; end
			3'd5:begin W_real=32'hFFFF9E09; W_img=32'hFFFF137D; end
			3'd6:begin W_real=32'hFFFF4AFC; W_img=32'hFFFF4AFC; end
			3'd7:begin W_real=32'hFFFF137D; W_img=32'hFFFF9E09; end
		endcase
	end

	always @(posedge clk) begin
		if(ab_valid)begin
			data_a <= a[31:16];
			data_b <= a[15:0];
			data_c <= b[31:16];
			data_d <= b[15:0];
		end		
	end

	always@(*)begin
		if(fft_pe_valid)begin
			fft_a = {data_a+data_c,data_b+data_d};
			fft_b = {(data_a-data_c)*W_real+(data_d-data_b)*W_img,(data_a-data_c)*W_img+(data_b-data_d)*W_real};
		end
	end
endmodule

