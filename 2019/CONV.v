
`timescale 1ns/10ps

module  CONV(
	input			clk,
	input			reset,
	output	reg		busy,	
	input			ready,	
			
	output	reg 	[11:0]	iaddr,
	input			[19:0]	idata,	
	
	output	reg 	cwr,
	output	reg 	[11:0] 	caddr_wr,
	output	reg 	[19:0] 	cdata_wr,
	
	output	reg  	crd,
	output	reg 	[11:0] 	caddr_rd,
	input			[19:0] 	cdata_rd,
	
	output	reg		[2:0] 	csel
	);

	reg [2:0] state;
	reg [5:0]x;
	reg [5:0]y;
	reg [39:0]conv_val;
	reg [19:0]img[0:8];
	reg [19:0]ker[0:8];
	reg [3:0] ker_cnt;
	reg [11:0] img_pos;
	reg flag;
	integer  i;

	assign img_pos = img_cnt - ((ker_cnt/3) -1) * 64 + (ker_cnt%3) -1; 
	always @(posedge clk) begin
		if(reset)begin // init
			state <= 0;
			img_cnt <= 0;
			ker_cnt <= 0;
			x <= 0;
			y <= 0;
			flag <= 0;
			for(i=0;i<9;i=i+1) begin
				img[i] <= 0;
			end
			ker[0] <= 0x0A89E;
			ker[1] <= 0x092D5;
			ker[2] <= 0x06D43;
			ker[3] <= 0x01004;
			ker[4] <= 0xF8F71;
			ker[5] <= 0xF6E54;
			ker[6] <= 0xFA6D7;
			ker[7] <= 0xFC834;
			ker[8] <= 0xFAC19;
		end
		else begin
			if(state == 0)begin //idle
				if(ready == 1) begin
					busy <= 1;
					state <= 1;
				end
			end
			else if (state == 1) begin //convolution get data
 				//get image data
				if(ker_cnt == 0)begin
					flag <= (y == 0 || x == 0)?0:1;
				end
				else if(ker_cnt == 1)begin
					flag <= (y == 0) ? 0:1;
				end
				else if(ker_cnt == 2)begin
					flag <= (y == 0 || x == 63) ? 0:1;
				end
				else if(ker_cnt == 3)begin
					flag <= (x == 0) ? 0:1;
				end
				else if(ker_cnt == 4)begin
					flag <= 1;
				end
				else if(ker_cnt == 5)begin
					flag <= (x== 63) ? 0:1;
				end
				else if(ker_cnt == 6)begin
					flag <= (y == 63 || x == 0) ? 0:1;
				end
				else if(ker_cnt == 7)begin
					flag <= (y == 63) ? 0:1;
				end
				else if(ker_cnt == 8)begin
					flag <= (y == 63 || x == 63) ? 0:1;
				end
				iaddr <= img_pos;
				if(ker_cnt > 0)begin
					img[ker_cnt - 1] <= ? (flag) :idata;
				end
				ker_cnt = ker_cnt+1;
				if(ker_cnt == 9)begin
					state <= 2;
				end
			end
			else if (state == 2)begin
				
			end
		end
	end



endmodule




