# This script sets up a Vivado project with all ip references resolved.
file delete -force *.xpr *.os *.jou *.log pmod_acl2.srcs pmod_acl2.cache pmod_acl2.runs
#
# Create the project/environment
create_project -part  XC7S50-CSGA324-2 -force gpio
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet

# Read in the IP and generate the outputs for use in simulation and synthesis

# Read our VHDL files and make sure everything is VHDL2008
read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../../Common/Boards/boolean/boolean_pkg.vhd
    ../../../rtl/gpio/gpio.vhd
    ../../../rtl/gpio/gpio_bit.vhd
    ../../../rtl/top.vhd      
}

#Read constraint file
read_xdc ../../constraints/boolean.xdc

# Close the project
close_project
