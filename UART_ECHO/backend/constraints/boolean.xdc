# clk input is from the 100 MHz oscillator on Boolean board
create_clock -period 10.000 -name gclk [get_ports XCLK]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {XCLK}]

# Set Bank 0 voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# On-board Slide Switches
# set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[0]}]
# set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[1]}]
# set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[2]}]
# set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[3]}]
# set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[4]}]
# set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[5]}]
# set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[6]}]
# set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[7]}]
# set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[8]}]
# set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[9]}]
# set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[10]}]
# set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[11]}]
# set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[12]}]
# set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[13]}]
# set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[14]}]
# set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports {XSWITCHES[15]}]

# On-board XLEDSs
# set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {XLEDS[0]}]
# set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {XLEDS[1]}]
# set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {XLEDS[2]}]
# set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {XLEDS[3]}]
# set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {XLEDS[4]}]
# set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {XLEDS[5]}]
# set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {XLEDS[6]}]
# set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {XLEDS[7]}]
# set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {XLEDS[8]}]
# set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {XLEDS[9]}]
# set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {XLEDS[10]}]
# set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {XLEDS[11]}]
# set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {XLEDS[12]}]
# set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {XLEDS[13]}]
# set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {XLEDS[14]}]
# set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {XLEDS[15]}]

# On-board Buttons
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {XRESET}]
#set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
#set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]
#set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]

# On-board color LEDs
#set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports {RGB0[0]}];   # RBG0_R
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {XLOCKED}];   # RBG0_G
#set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports {RGB0[2]}];   # RBG0_B
#set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {RGB1[0]}];   # RBG1_R
#set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {RGB1[1]}];   # RBG1_G
#set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {RGB1[2]}];   # RBG1_B

# On-board 7-Segment display 0
#set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {D0_AN[0]}]
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {D0_AN[1]}]
#set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {D0_AN[2]}]
#set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {D0_AN[3]}]
#set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[0]}]
#set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[1]}]
#set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[2]}]
#set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[3]}]
#set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[4]}]
#set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[5]}]
#set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[6]}]
#set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[7]}]

# On-board 7-Segment display 1
#set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {D1_AN[0]}]
#set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {D1_AN[1]}]
#set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {D1_AN[2]}]
#set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS33} [get_ports {D1_AN[3]}]
#set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[0]}]
#set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[1]}]
#set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[2]}]
#set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[3]}]
#set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[4]}]
#set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[5]}]
#set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[6]}]
#set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {D1_SEG[7]}]

## UART
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {XRX}]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {XTX}]

##HDMI Signals
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD TMDS_33 } [get_ports {hdmi_clk_n}]
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD TMDS_33 } [get_ports {hdmi_clk_p}]

#set_property -dict { PACKAGE_PIN T15   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_n[0]}]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_n[1]}]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_n[2]}]
                                    
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_p[0]}]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_p[1]}]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD TMDS_33  } [get_ports {hdmi_tx_p[2]}]

## PWM audio signals
#set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports {left_audio_out}]
#set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {right_audio_out}]

## BLE UART signals
#set_property -dict {PACKAGE_PIN G5 IOSTANDARD LVCMOS33} [get_ports {ble_uart_tx}]
#set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports {ble_uart_rx}]
#set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {ble_uart_rts}]
#set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {ble_uart_cts}]

## Servomotor signals
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {servo0}]
#set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {servo1}]
#set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {servo2}]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {servo3}]
