# operating conditions and boundary conditions #
set sdc_version 1.2
set cycle 0          ;	#clock period defined by designer

create_clock -period $cycle [get_ports  clk]
set_clock_uncertainty  0.1  [get_clocks clk]
set_clock_latency      0.5  [get_clocks clk]

set_input_delay [expr $cycle/2] -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay [expr $cycle/2] -clock clk [all_outputs]
set_load -pin_load 1  [all_outputs]
set_drive          1  [all_inputs]
