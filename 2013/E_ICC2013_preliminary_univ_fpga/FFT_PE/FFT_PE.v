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

	reg signed [31:0]a_tmp_real,a_tmp_img,b_tmp_real,b_tmp_img;
	reg [2:0]state, next_state;
	reg pe_flag;
	reg signed[31:0]W_real,W_img;
	reg signed[31:0]a_real,a_img,b_real,b_img;
	

	parameter IDLE = 3'd0;
	parameter READ = 3'd1;
	parameter WRITE = 3'd2;
	parameter FINISH = 3'd3;

	always @(posedge clk or posedge rst) begin
		if(rst == 1) state <= IDLE;
		else state <= next_state;
	end

	always @(posedge clk) begin
		if(ab_valid) next_state <= READ;
		else if(pe_flag) next_state <= WRITE;
		else next_state <= IDLE;
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
			a_real <= a[31:16];
			a_img <= a[15:0];
			b_real <= b[31:16];
			b_img <= b[15:0];
			pe_flag <= 1;
		end
		else 
		begin
			pe_flag <= 0;		
		end
	end

	always @(negedge clk) begin
		if(pe_flag)
		begin
			fft_pe_valid <= 1;
			fft_a <= {a_tmp_real[15:0],a_tmp_img[15:0]};
			fft_b <= {b_tmp_real[31:16],b_tmp_img[31:16]};
		end
		else fft_pe_valid<= 0;
	end

	always@(*)begin
		a_tmp_real = a_real+b_real;
		a_tmp_img = a_img+b_img;
		b_tmp_real = (a_real-b_real)*W_real+(b_img-a_img)*W_img;
		b_tmp_img = (a_real-b_real)*W_img+(a_img-b_img)*W_real;
	end
endmodule

