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
