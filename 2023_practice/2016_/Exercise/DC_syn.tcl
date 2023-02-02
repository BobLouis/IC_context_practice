#Read All Files
read_file LBP.v
current_design LBP
link

#Setting Clock Constraints
source -echo -verbose LBP.sdc

#Synthesis all design
compile 


write -format ddc -hierarchy -output LBP_syn.ddc
write_sdf -version 2.1 LBP_syn.sdf
write_file -format verilog -hierarchy -output LBP_syn.v
report_area > area.log
report_timing > timing.log
report_qor   >  LBP_syn.qor

