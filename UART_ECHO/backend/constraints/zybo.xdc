##Clock signal
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { XCLK }]; #IO_L12P_T1_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { XCLK }];

##Buttons
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { XRESET }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]

set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { XTX }]; #IO_L18N_T2_34 Sch=je[2]                     
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { XRX }]; #IO_25_35 Sch=je[3] 