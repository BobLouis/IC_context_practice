`timescale 1ns/10ps
`define CYCLE  20.00
`define INFILE "INa.DAT"

module test;
parameter INPUT_DATA = `INFILE;
reg RESET_;
reg ENCODE_;
reg CLK;
tri [3:0]  CODE;
tri [15:0] DATA;

reg [15:0] data_in ;
reg [3:0]  code_in;
reg ready1;
reg ready2;
reg flag1, flag2, flag3, flag4;

integer i, j, k, out_f, err;
integer a, b, c, d;
reg     [35:0] N_PAT;

assign DATA = (ENCODE_ ==1'b0) ? data_in : 16'bz;
assign CODE = (ENCODE_ ==1'b1) ? code_in : 4'bz;


reg [35:0]  data_base [0:20000];


reg [15:0]  data_pat[0:20000-1];
reg [3:0]   code_pat[0:20000-1];

reg [15:0]  data_answer[0:20000-1];
reg [3:0]   code_answer[0:20000-1];




CODEC top(DATA, CODE, RESET_, ENCODE_, CLK);
//initial $sdf_annotate("CODEC.timing",top);

initial	$readmemh( INPUT_DATA,  data_base);

initial begin
   N_PAT = data_base[0];
   for  (i = 0; i < N_PAT; i = i + 1)  begin
      {data_pat[i], code_pat[i], data_answer[i]}  = data_base[i+1];
      code_answer[i] = code_pat[i];
   end
end

initial begin
$dumpvars;
$dumpfile("codec1.vcd");
   RESET_ = 1'b1;
   ENCODE_ = 1'b0;
   CLK = 1'b1;
   data_in = 16'bz;
   code_in = 4'bz;
   ready1 =0;
   ready2 =0;
   j = 0;
   k = 0;
   err = 0;
   a = 0;
   b = 0;
   c = 0;
   d = 0;
end

specify
$setup(CODE, posedge CLK &&& ready1, 0.5, flag1);
$hold(posedge CLK &&& ready1, CODE, 0.5, flag2);

$setup(DATA, posedge CLK &&& ready2, 0.5, flag3);
$hold(posedge CLK &&& ready2, DATA, 0.5, flag4);
endspecify

always @(flag1)
   if(flag1 == 1'b1 || flag1 == 1'b0)
     a = a +1;

always @(flag2)
   if(flag2 == 1'b1  || flag2 == 1'b0)
     b = b +1;

always @(flag3)
   if(flag3 == 1'b1  || flag3 == 1'b0)
     c = c +1;

always @(flag4)
   if(flag4 == 1'b1  || flag4 == 1'b0)
     d = d +1;


initial begin
   out_f = $fopen("OUT.DAT");
   if (out_f == 0) begin
        $display("Output file open error !");
        $finish;
   end
end

always begin #(`CYCLE/2) CLK = ~CLK;
end

initial begin
   @(negedge CLK)          RESET_ = 1'b0;
   $display ("\n******START to VERIFY ENCODING OPERATION ******\n");
   @(negedge CLK)          RESET_ = 1'b1;
   #(`CYCLE*0.25)          data_in = data_pat[0];
   @(posedge CLK) 
   #(`CYCLE*0.25)           data_in = 16'bz; 
   @(negedge CLK)           ready1=1; 
   for  (i = 1; i < N_PAT; i = i + 1) begin
      #(`CYCLE*0.25)  data_in = data_pat[i];
      #(`CYCLE*0.5)  data_in = 16'bz;
      @(negedge CLK);
   end 
   #(`CYCLE)
   ready1 = 0;
   #(`CYCLE *3)
   @(negedge CLK)
   ENCODE_ =1'b1; 
   #(`CYCLE)             RESET_ = 1'b0;
   $display ("\n******START to VERIFY DECODING OPERATION ******\n");
   #(`CYCLE)             RESET_ = 1'b1;
   #(`CYCLE*0.25)        code_in = code_pat[0];
   @(posedge CLK)
   #(`CYCLE*0.25)         code_in = 4'bz;
   @(negedge CLK)        ready2=1;
   for  (i = 1; i < N_PAT; i = i + 1) begin
      #(`CYCLE*0.25)  code_in = code_pat[i];
      #(`CYCLE*0.5)   code_in = 4'bz;
      @(negedge CLK);
   end

   #(`CYCLE)
   ready2 = 0;
   #(`CYCLE*10) ready2=0;
end  

 		
always @ (posedge CLK) begin
   if (ready1) begin
      $fdisplay(out_f,"%h",CODE);
      $display("%d :  %h", j, CODE);
      if ( CODE !== code_answer[j]) begin
        $display("ERROR at %d:output %h!=expect%h",j, CODE,code_answer[j]);
        err = err + 1;
      end
      j = j + 1;
   end
   
  if (ready2) begin
      $fdisplay(out_f,"%h",DATA);
      $display("%d :  %h", k, DATA);
      if ( DATA !== data_answer[k]) begin
        $display("ERROR at %d:output %h!=expect%h",k, DATA,data_answer[k]);
        err = err + 1;
      end
      k = k + 1;
   end

   if (j >=N_PAT  && k>=N_PAT) begin
      if (a !=0)
         $display("There are %d setup time violations during encode", a);
      if (b !=0)
         $display("There are %d hold time violations during encode", b);
      if (c !=0)
         $display("There are %d setup time violations during decode", c);
      if (d !=0)
         $display("There are %d hold time violations during decode", d);
     
      $display("---------------------------------------------");
      if (err == 0)
         $display("All data have been generated successfully!");
      else 
         $display("There are %d errors!", err);
      $display("---------------------------------------------");
      $finish;
   end
end
initial begin
 //  $shm_open("shm/shm_g.db");
 //  $shm_probe("AS");
end
endmodule
