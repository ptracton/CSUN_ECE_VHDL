# This script sets up a Vivado project with all ip references resolved.
file delete -force uart_echo.xpr *.os *.jou *.log uart_echo.srcs uart_echo.cache uart_echo.runs
#
create_project -part XC7S50-CSGA324-2 -force uart_echo
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet


read_ip   generated_ip/clk_wiz_0/clk_wiz_0.xci
upgrade_ip -quiet [get_ips *]
generate_target {all} [get_ips *]

read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../rtl/boolean/boolean_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../../Common/CSUN/system_controller.vhd
    ../../../../Common/CSUN/edge_detector.vhd
    ../../../rtl/top.vhd      
}

read_xdc ../../constraints/boolean.xdc
close_project
