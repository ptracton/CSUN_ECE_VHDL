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
read_ip ./generated_ip/fifo_generator_0/fifo_generator_0.xci
upgrade_ip -quiet [get_ips *]
generate_target {all} [get_ips *]

# Read our VHDL files and make sure everything is VHDL2008
read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../../Common/Boards/zybo/zybo_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../../Common/CSUN/edge_detector.vhd
    ../../../rtl/accelerometer_processing.vhd
    ../../../rtl/accelerometer_to_uart.vhd
    ../../../rtl/system_controller.vhd
    ../../../rtl/top.vhd      
}
read_vhdl  -library xil_defaultlib {
    ../../../../Common/DigiKey/SPI/spi_master.vhd
    ../../../../Common/DigiKey/PMOD/pmod_accelerometer_adxl362.vhd
    ../../../../Common/DigiKey/I2C/i2c_master.vhd
    ../../../../Common/DigiKey/PMOD/pmod_hygrometer.vhd    
}

#Read constraint file
read_xdc ../../constraints/zybo.xdc

# Close the project
close_project
