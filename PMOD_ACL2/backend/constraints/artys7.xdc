## Clock signal
set_property -dict {PACKAGE_PIN R2 IOSTANDARD SSTL135} [get_ports XCLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports XCLK]

## Buttons
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { XRESET }]; #IO_L18N_T2_A23_15 Sch=btn[0]

## RGB LEDs
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { led0_r }]; #IO_L23N_T3_FWE_B_15 Sch=led0_r
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { XLOCKED }]; #IO_L14N_T2_SRCC_15 Sch=led0_g

## USB-UART Interface
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { XTX }]; #IO_25_14 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { XRX }]; #IO_L24N_T3_A00_D16_14 Sch=uart_txd_in

##Pmod Header JB
#Pin 3 SCL
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33     } [get_ports { XSCL }]; #IO_L1P_T0_34 Sch=jc_p[2]

#Pin 4 SDA
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33     } [get_ports { XSDA }]; #IO_L1N_T0_34 Sch=jc_n[2]

##Pmod Header JC -- PMOD ACL2
# https://digilent.com/reference/pmod/pmodacl2/start
#Pin 1 ~CS
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33     } [get_ports { XSS_N }]; 

#Pin 2 MOSI
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33     } [get_ports { XMOSI }]; 

#Pin 3 MISO
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33     } [get_ports { XMISO }]; 

#Pin 4 SCLK
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33     } [get_ports { XSCLK }]; 


## Configuration options, can be used for all designs
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## SW3 is assigned to a pin M5 in the 1.35v bank. This pin can also be used as
## the VREF for BANK 34. To ensure that SW3 does not define the reference voltage
## and to be able to use this pin as an ordinary I/O the following property must
## be set to enable an internal VREF for BANK 34. Since a 1.35v supply is being
## used the internal reference is set to half that value (i.e. 0.675v). Note that
## this property must be set even if SW3 is not used in the design.
set_property INTERNAL_VREF 0.675 [get_iobanks 34]
