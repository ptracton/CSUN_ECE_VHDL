## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports XCLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports XCLK]

## LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {XLOCKED}]

##Buttons
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports XRESET]

##USB-RS232 Interface
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports XRX]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports XTX]

##Pmod Header JB
#Pin 3 SCL
set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS33     } [get_ports { XSCL }]; #IO_L1P_T0_34 Sch=jc_p[2]

#Pin 4 SDA
set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33     } [get_ports { XSDA }]; #IO_L1N_T0_34 Sch=jc_n[2]

##Pmod Header JC -- PMOD ACL2
# https://digilent.com/reference/pmod/pmodacl2/start
#Pin 1 ~CS
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33     } [get_ports { XSS_N }]; 

#Pin 2 MOSI
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33     } [get_ports { XMOSI }]; 

#Pin 3 MISO
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33     } [get_ports { XMISO }]; 

#Pin 4 SCLK
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33     } [get_ports { XSCLK }]; 
