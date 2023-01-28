module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);
   input clk, reset, nt;
   input [2:0] xi, yi;
   output reg busy, po;
   output reg [2:0] xo, yo;
  
   reg [2:0] x1, y1, x2, y2, x3, y3;
   reg [2:0] state, next_state;
   reg [2:0] x0, y0;
   reg [2:0] cnt;
   reg nt_reg;
   reg in, judge;  //high if the dot is in the tri

   wire ori;
   wire [5:0]eq1,eq2,eq3; 
   assign ori = (x2>x1)?1:0;//1 for right 0 for left
   assign eq1 = (x0-x2)/(y0-y2);
   assign eq2 = (x2-x1)/(y2-y1);
   assign eq3 = (x3-x2)/(y3-y2);

   parameter IDLE =     3'd0;//000
	parameter INPUT=     3'd1;//001 
	parameter CAL  =     3'd2;//011
	parameter OUTPUT =   3'd3;//100
	parameter DONE =     3'd4;//101



   always @(posedge clk or posedge reset) begin
		if(reset)
			state <= IDLE;
		else 
			state <= next_state;
	end

   always @(*) begin
		case(state)
			IDLE :begin
				next_state = INPUT;
			end
			INPUT :begin
            if(cnt == 3)
               next_state = CAL;
            else 
               next_state = INPUT;
         end
         CAL :begin
            if(x0 == 7 && y0 == 7)begin
               next_state = DONE;
            end
            else if(in == 1)begin
               next_state = OUTPUT;
            end
            else begin
               next_state =CAL;
            end
         end
         OUTPUT:begin
            next_state = CAL;
         end
			DONE:
				next_state = INPUT;
			default: next_state = IDLE;
		endcase
	end

   //input
   always @(posedge clk or posedge reset) begin
      if(reset || next_state == DONE)begin
         x1  <= 0;
         x2  <= 0;
         x3  <= 0;
         y1  <= 0;
         y2  <= 0;
         y3  <= 0;
         cnt <= 0;
      end
      else if(nt)begin
         nt_reg <= 1;
         x1  <= xi;
         y1  <= yi;
         cnt <= 1;
      end
      else if(nt_reg == 1 && cnt == 1)begin
         x2 <= xi;
         y2 <= yi;
         cnt <= 2;
      end
      else if(nt_reg == 1 && cnt == 2)begin
         x3 <= xi;
         y3 <= yi;
         cnt <= 3;
         nt_reg = 0;
      end
   end

   //x0 y0 
   always @(posedge clk or posedge reset) begin
      if(reset || next_state == DONE)begin
         y0 <= 0;
         x0 <= 0;
      end
      else if((next_state == CAL || next_state == OUTPUT)&& judge == 1)begin
         if(x0 == 7)begin
            y0 <= y0 + 1;
         end
         x0 <= x0 + 1;
      end
   end

   //cal
   always @(posedge clk or posedge reset) begin
      if(next_state == CAL && judge == 0)begin
         if((x0 < x1 && ori == 1) || (x0 > x1 && ori == 0))begin //not in the tri
            judge <= 1;
            in <= 0;
         end
         else if(ori == 1 && eq1 <= eq2 && eq1 <= eq3)begin//right
            judge <= 1;
            in <= 1;
         end
         else if(ori == 0 && eq1 >= eq2 && eq1 >= eq3)begin//left
            judge <= 1;
            in <= 1;
         end
         else begin
            judge <= 1;
            in <= 0;
         end
      end
      else begin
         judge <= 0;
         in <=0;
      end
   end

   always @(posedge clk or posedge reset) begin
      if(next_state == OUTPUT)begin
         xo <= x0;
         yo <= y0;
         po <= 1;
      end
      else begin
         po <= 0;
      end
   end

   always @(posedge clk or posedge reset) begin
      if(nt_reg == 1)begin
         busy <= 1;
      end
      else if(next_state == DONE)begin
         busy <= 0;
      end
   end

endmodule