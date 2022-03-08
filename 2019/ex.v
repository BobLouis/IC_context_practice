module  CONV(clk,reset,busy,ready,iaddr,idata,cwr,caddr_wr,cdata_wr,crd,caddr_rd,cdata_rd,csel);
input clk;
input reset;
input ready;
output busy;
output [11:0] iaddr;
input signed [19:0] idata;
output crd;
input [19:0] cdata_rd;
output [11:0] caddr_rd;
output cwr;
output [19:0] cdata_wr;
output [11:0] caddr_wr;
output [2:0] csel;
	
reg busy;
reg [11:0] iaddr;
reg crd;
reg [11:0] caddr_rd;
reg cwr;
reg signed [19:0] cdata_wr;
reg [11:0] caddr_wr;
reg [2:0] csel;

//csel cwr crd 

reg [3:0] current_State;
reg [3:0] next_State;

reg [3:0] counterRead;
reg [5:0] col,row;

reg signed [43:0] convTemp, resultTemp; // 2^20 * 2^20 * 2^4 = 2^44  By the way 2^4 = 9 pixel
wire signed [20:0] roundTemp;

//! signed to unsigned part selection occurs
reg signed [19:0] kernelTemp;
reg signed [19:0] BiasTemp;



//parameter
parameter IDLE = 4'd0;
parameter READ_CONV = 4'd1;
parameter WRITE_L0 = 4'd2;
parameter READ_L0 = 4'd3;
parameter WRITE_L1 = 4'd4;
parameter FINISH = 4'd5;

always@(*)begin
        case(counterRead)
        4'd2: kernelTemp = 20'h0A89E;
        4'd3: kernelTemp = 20'h092D5;
        4'd4: kernelTemp = 20'h06D43;
        4'd5: kernelTemp = 20'h01004;
        4'd6: kernelTemp = 20'hF8F71;
        4'd7: kernelTemp = 20'hF6E54;
        4'd8: kernelTemp = 20'hFA6D7;
        4'd9: kernelTemp = 20'hFC834;
        4'd10: kernelTemp = 20'hFAC19;
        default: kernelTemp = 20'd0;
        endcase
end

always@(posedge clk or posedge reset)
begin
    if(reset) {row,col} <= 12'd0;
    else if(current_State == WRITE_L0) begin
        if(col == 6'd63) begin
            col <= 6'd0;
            row <= row + 6'd1;
        end    
        else col <= col + 6'd1;
    end
    else if(current_State == WRITE_L1) begin
        if(col == 6'd62) begin
            col <= 6'd0;
            row <= row + 6'd2;
        end
        else col <= col + 6'd2;
    end
end

always@(posedge clk or posedge reset)
begin
    if(reset) current_State <= IDLE;
    else current_State <= next_State;
end

//next state logic
always@(*)
begin
    case (current_State)
        IDLE:
            begin
                if(ready == 1'd1) next_State = READ_CONV;
                else next_State = IDLE;
            end
        READ_CONV:
            begin
                if(counterRead == 4'd12) next_State = WRITE_L0;
                else next_State = READ_CONV;
            end
        WRITE_L0:
            begin
                if(col == 6'd63 && row == 6'd63) next_State = READ_L0;
                else next_State = READ_CONV;
            end

        READ_L0:
            begin
                if(counterRead == 4'd5) next_State = WRITE_L1;
                else next_State = READ_L0;
            end
        WRITE_L1:
            begin
                if(col == 6'd62 && row == 6'd62) next_State = FINISH;
                else next_State = READ_L0;
            end
        FINISH: 
            begin
                next_State = FINISH;
            end
        default:
            begin
                next_State = IDLE;
            end 
    endcase    
end

//counter
always@(posedge clk or posedge reset)
begin
    if(reset) counterRead <= 4'd0;
    else if(counterRead == 4'd13) counterRead <= 4'd0;    
    else if(counterRead == 4'd5 && (current_State == READ_L0) ) counterRead <= 4'd0;
    else if(current_State == READ_CONV || current_State == READ_L0) counterRead <= counterRead + 4'd1;
end

//busy
always@(posedge clk or posedge reset)
begin
    if(reset) busy <= 1'd0;
    else if(ready == 1'd1) busy <= 1'd1;
    else if(current_State == FINISH )busy <= 1'd0;
end

//cwr crd csel
always@(posedge clk or posedge reset)
begin
    if(reset) cwr <= 1'd0;
    else if (next_State == WRITE_L0) cwr <= 1'd1;
    else if (next_State == WRITE_L1) cwr <= 1'd1;
    else cwr <= 1'd0;
end

always@(posedge clk or posedge reset)
begin
    if(reset) crd <= 1'd0;
    else if(current_State == READ_L0 ) crd <= 1'd1;
    else crd<= 1'd0;
end

always@(posedge clk or posedge reset)
begin
    if(reset) csel <=3'd0;
    else if(next_State == WRITE_L1) csel <= 3'b011;
    else if(next_State == WRITE_L0) csel <= 3'b001;
    else if(current_State == READ_L0) csel <= 3'b001; 
end

//addr
always@(posedge clk or posedge reset)
begin
    if(reset)  iaddr <= 12'd0; 
    else if(current_State == READ_CONV)
    begin
        case(counterRead)
        4'd0: iaddr <= {row-6'd1,col-6'd1};
        4'd1: iaddr <= {row-6'd1,col};
        4'd2: iaddr <= {row-6'd1,col+6'd1};
        4'd3: iaddr <= {row,col-6'd1};
        4'd4: iaddr <= {row,col};
        4'd5: iaddr <= {row,col+6'd1};
        4'd6: iaddr <= {row+6'd1,col-6'd1};
        4'd7: iaddr <= {row+6'd1,col};
        4'd8: iaddr <= {row+6'd1,col+6'd1};
        default: iaddr <= 6'd0;
        endcase
    end
end

always@(posedge clk or posedge reset)
begin
    if(reset) caddr_rd <= 12'd0;
    else if(current_State == READ_L0)
    begin
        case(counterRead)
        4'd0: caddr_rd <= {row,col};
        4'd1: caddr_rd <= {row,col+6'd1};
        4'd2: caddr_rd <= {row+6'd1,col};
        4'd3: caddr_rd <= {row+6'd1,col+6'd1};
        default: caddr_rd <= 6'd0;
        endcase
    end
end

always@(posedge clk or posedge reset)
begin
    if(reset) caddr_wr <= 12'd0;
    else if(next_State == WRITE_L0) caddr_wr <= {row,col};
    else if(next_State == WRITE_L1) caddr_wr <= {row[5:1],col[5:1]};
   
end

//assign roundTemp = resultTemp[35:15] + 21'd1; //counter: 12
assign roundTemp = resultTemp[35:15] + resultTemp[15];

//cdata_wr
always@(posedge clk or posedge reset)
begin
    if(reset) cdata_wr <= 20'd0;
    else if(next_State == WRITE_L0)
    begin
        if(roundTemp[20]) cdata_wr <= 20'd0;
        else cdata_wr <= roundTemp[20:1];
    end
    else if(current_State == READ_L0 )
    begin
        if(counterRead == 4'd1) cdata_wr <= cdata_rd;
        else 
        begin
            if(cdata_rd > cdata_wr) cdata_wr <= cdata_rd;
            else cdata_wr <= cdata_wr;
        end
    end
end

reg signed [19:0] idataTemp;
wire signed [43:0] mulTemp;
assign mulTemp = kernelTemp * idataTemp;
//conv && bias
always@(posedge clk or posedge reset) idataTemp <= (reset)? 20'd0 : idata;

always@(posedge clk or posedge reset)
begin
    if(reset) convTemp <= 44'd0; 
    else if(current_State == READ_CONV)
    begin
        case(counterRead)
        
        4'd0:   convTemp <= 44'd0;
        4'd2:   if(col != 6'd0 && row != 6'd0)  convTemp <= mulTemp;
        4'd3:   if(row != 6'd0) convTemp <= convTemp + mulTemp;
        4'd4:   if(row != 6'd0 && col != 6'd63) convTemp <= convTemp + mulTemp;
        4'd5:   if(col != 6'd0) convTemp <= convTemp + mulTemp;
        4'd6:   convTemp <= convTemp + mulTemp;
        4'd7:   if(col != 6'd63) convTemp <= convTemp + mulTemp;
        4'd8:   if(col != 6'd0 && row != 6'd63) convTemp <= convTemp + mulTemp;
        4'd9:   if(row != 6'd63) convTemp <= convTemp + mulTemp;
        4'd10:   if(row != 6'd63 && col != 6'd63) convTemp <= convTemp + mulTemp;
        4'd11:  resultTemp <= convTemp + $signed({20'h01310,16'd0});//20'h01310
        endcase
    end
end

endmodule