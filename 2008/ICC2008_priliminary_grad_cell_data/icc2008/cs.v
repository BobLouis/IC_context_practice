module LCD_CTRL(clk,
                reset,
                datain,
                cmd,
                cmd_valid,
                dataout,
                output_valid,
                busy);
    input           clk;
    input           reset;
    input   [7:0]   datain;
    input   [3:0]   cmd;
    input           cmd_valid;
    output  [7:0]   dataout;
    output  reg        output_valid;
    output  reg        busy;
    
    reg [2:0] state; //4 states for "idle", "load", "prepare display", "display"
    reg zoom; //0 for fit 1 for zoom in
    reg [7:0] img_buf[107:0];
    reg [3:0] l,w;
    reg [7:0] fitIndex [15:0];
    reg [107:0] loadCount; //count of load 108 datain, from 0 to 107
    reg [1:0] offsetx,offsety;
    reg [1:0] rotate;
    //0 => no rotate    1 => rotate right   2 => rotate 180  3 => rotate left  
    wire [3:0] fitmap;
    wire [7:0] fitxy;
    wire  [7:0] zoomxy;
    
    assign dataout = (zoom == 0) ? img_buf[fitxy] : img_buf[zoomxy];
    assign fitmap  = offsetx + offsety*4;
    assign fitxy   = fitIndex[fitmap];
    assign zoomxy  = l + offsetx + (w+offsety)*12;
    
    always @(negedge reset) begin
        fitIndex[0]  = 13;
        fitIndex[1]  = 16;
        fitIndex[2]  = 19;
        fitIndex[3]  = 22;
        fitIndex[4]  = 37;
        fitIndex[5]  = 40;
        fitIndex[6]  = 43;
        fitIndex[7]  = 46;
        fitIndex[8]  = 61;
        fitIndex[9]  = 64;
        fitIndex[10] = 67;
        fitIndex[11] = 70;
        fitIndex[12] = 85;
        fitIndex[13] = 88;
        fitIndex[14] = 91;
        fitIndex[15] = 94;
    end
    
    
    always @(posedge clk) begin
        if (reset)
        begin
            state  <= 0;
            zoom   <= 0;
            busy   <= 0;
            rotate <= 0;
        end
        else
        begin
            if (!state)
            begin
                output_valid <= 0;
                if (cmd_valid && !busy)
                begin
                    if (cmd == 4'd0)
                    begin
                        loadCount <= 0;
                        state     <= 1;
                        busy      <= 1;
                    end
                    else
                    begin
                        state <= 2;
                        busy  <= 1;
                        if(cmd == 4'd1 && zoom == 0) //rotate left
                            rotate <= rotate -1;
                        else if (cmd == 4'd2 && zoom == 0) //rotate right
                            rotate <= rotate +1;
                        else if(cmd == 4'd3) //zoom in mode
                        begin
                            zoom <= 1;
                            l <= 4;
                            w <= 3;
                        end
                        else if(cmd == 4'd4) //zoom fit mode
                        begin
                            zoom <= 0;
                            l <= 4;
                            w <= 3;
                        end
                        else if(cmd == 4'd5 && zoom == 1) //shift right
                        begin
                            if(rotate == 0)
                            begin
                                if(l < 8)
                                    l <= l + 1;
                            end
                            else if(rotate == 1) //shift right
                            begin
                                if(w > 0)
                                    w <= w - 1;
                            end
                            else
                            begin
                                if(w < 5)
                                    w <= w + 1;
                            end
                        end
                        else if(cmd == 4'd6 && zoom == 1) //shift left
                        begin
                            if(rotate == 0)
                            begin
                                if(l > 0)
                                    l <= l - 1;
                            end
                            else if(rotate == 1) 
                            begin
                                if(w < 5)
                                    w <= w + 1;
                            end
                            else
                            begin
                                if(w > 0)
                                    w <= w - 1;
                            end
                        end
                        else if(cmd == 4'd7 && zoom == 1) //shift up
                        begin
                            if(rotate == 0)
                            begin
                                if(w > 0)
                                    w <= w - 1;
                            end
                            else if(rotate == 1) 
                            begin
                                if(l > 0)
                                    l <= l - 1;
                            end
                            else
                            begin
                                if(l < 8)
                                    l <= l + 1;
                            end
                        end
                        else if(cmd == 4'd7 && zoom == 1) //shift down
                        begin
                            if(rotate == 0)
                            begin
                                if(w < 5)
                                    w <= w + 1;
                            end
                            else if(rotate == 1) 
                            begin
                                if(l < 8)
                                    l <= l + 1;
                            end
                            else
                            begin
                                if(l > 0)
                                    l <= l - 1;
                            end
                        end
                    end
                end
            end
            else if(state == 1)  //load data 108 data
            begin
                output_valid <= 0;
                if(loadCount == 107)
                begin
                    state <= 3;
                    busy <= 1;
                    output_valid <=1;
                    l   <=4;
                    w   <=3;
                    offsetx <= 0;
                    offsety <= 0;
                    zoom <= 0;
                    rotate <= 0;
                end
                img_buf[loadCount] <= datain;
                loadCount <= loadCount + 1;

            end
            else if(state == 2) //prepare to display 
            begin
                if(rotate == 0)
                begin
                    offsetx <= 0;
                    offsety <= 0;
                end
                else if(rotate == 1) //rotate right
                begin
                    offsetx <= 0;
                    offsety <= 3;
                end
                else if(rotate == 3)// rotate left
                begin
                    offsetx <= 3;
                    offsety <= 0;
                end
                output_valid <= 1;
                state <= 3;
                busy  <= 1;
            end
            else if(state == 3) //display 
            begin
                if(rotate == 0)
                begin
                    if(offsetx == 3)
                    begin
                        if(offsety == 3)
                        begin
                            state <= 0;
                            busy  <= 0;
                            output_valid <= 0;
                        end
                        offsety <= offsety + 1;
                    end
                    offsetx <= offsetx + 1;
                end
                else if(rotate == 1)//ro right
                begin
                    if(offsety == 0)
                    begin
                        if(offsetx == 3)
                        begin
                            state <= 0;
                            busy  <= 0;
                            output_valid <= 0;
                        end
                        offsetx <= offsetx + 1;
                    end
                    offsety <= offsety - 1;
                end
                else if(rotate == 3)//ro left 3 0
                begin
                    if(offsety == 3)
                    begin
                        if(offsetx == 0)
                        begin
                            state <= 0;
                            busy  <= 0;
                            output_valid <= 0;
                        end
                        offsetx <= offsetx - 1;
                    end
                    offsety <= offsety + 1;
                end
            end
        end
    end
endmodule

