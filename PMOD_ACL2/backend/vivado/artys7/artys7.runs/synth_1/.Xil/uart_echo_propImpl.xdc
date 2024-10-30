set_property SRC_FILE_INFO {cfile:/home/ptracton/CSUN/CSUN_ECE_VHDL/UART_ECHO/backend/constraints/artys7.xdc rfile:../../../../../constraints/artys7.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD SSTL135} [get_ports XCLK]
set_property src_info {type:XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { XRESET }]; #IO_L18N_T2_A23_15 Sch=btn[0]
set_property src_info {type:XDC file:1 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { XLOCKED }]; #IO_L14N_T2_SRCC_15 Sch=led0_g
set_property src_info {type:XDC file:1 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { XTX }]; #IO_25_14 Sch=uart_rxd_out
set_property src_info {type:XDC file:1 line:14 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { XRX }]; #IO_L24N_T3_A00_D16_14 Sch=uart_txd_in
