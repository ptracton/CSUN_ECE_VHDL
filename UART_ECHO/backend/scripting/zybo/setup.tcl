# This script sets up a Vivado project with all ip references resolved.
file delete -force uart_echo.xpr *.os *.jou *.log uart_echo.srcs uart_echo.cache uart_echo.runs
#
create_project -part  xc7z010clg400-1 -force uart_echo
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet

file delete -force ./generated_IP
file mkdir ./generated_IP

#read_ip ../source/ip/sine_rom/sine_rom.xci
read_ip  IP/clk_wiz_0.xci
upgrade_ip -quiet [get_ips *]
generate_target {all} [get_ips *]

# Read in the hdl source.
#read_vhdl [glob ../source/chirp_gen.vhd]
#read_vhdl [glob ../source/top.vhd]

read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../rtl/zybo/zybo_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../../Common/CSUN/system_controller.vhd
    ../../../../Common/CSUN/edge_detector.vhd
    ../../../rtl/top.vhd      
}

#read_xdc ../source/top.xdc
read_xdc ../../constraints/zybo.xdc
close_project
