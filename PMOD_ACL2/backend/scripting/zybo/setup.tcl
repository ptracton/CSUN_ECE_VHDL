# This script sets up a Vivado project with all ip references resolved.
file delete -force pmod_acl2.xpr *.os *.jou *.log pmod_acl2.srcs pmod_acl2.cache pmod_acl2.runs
#
# Create the project/environment
create_project -part  xc7z010clg400-1 -force pmod_acl2
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet

# Read in the IP and generate the outputs for use in simulation and synthesis
read_ip ./generated_ip/clk_wiz_0/clk_wiz_0.xci
upgrade_ip -quiet [get_ips *]
generate_target {all} [get_ips *]

# Read our VHDL files and make sure everything is VHDL2008
read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../rtl/zybo/zybo_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../../Common/CSUN/edge_detector.vhd
    ../../../rtl/system_controller.vhd
    ../../../rtl/top.vhd      
}

#Read constraint file
read_xdc ../../constraints/zybo.xdc

# Close the project
close_project
