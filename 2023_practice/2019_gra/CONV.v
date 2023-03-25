
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output		busy,	
	input		ready,	
			
	output		iaddr,
	input		idata,	
	
	output	 	cwr,
	output	 	caddr_wr,
	output	 	cdata_wr,
	
	output	 	crd,
	output	 	caddr_rd,
	input	 	cdata_rd,
	
	output	 reg	csel
	);

reg [2:0]state, next_state;
parameter IDLE = 3'd0,
	  READ = 3'd1,
	  CAL = 3'd2,
	  OUT = 3'd3;

reg ker_choose;
reg signed [19:0] ker;


always@(posedge clk or posedge reset)begin
    if(reset)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(reset)
        next_state = IDLE;
    else begin
        case(state)
            IDLE:
                next_state = READ;
            READ:begin
                if() next_state = CAL;
                else next_state = READ;  
            end
            CAL:begin
                if() next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                next_state = READ; 
            default:    next_state = IDLE;
        endcase
    end 
end


//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin

    end
    else begin


    end
end


always@(*)begin
	
	if(ker_choose == 0)begin
		case(cnt)
			0:	ker = 20'h0A89E;
			1:	ker = 20'h092D5;
			2:	ker = 20'h06D43;
			

		endcase
	end
	case(cnt)
		0: 


	endcase
	
end

endmodule




