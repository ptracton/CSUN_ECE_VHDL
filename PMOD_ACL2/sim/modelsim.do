vlib work
vlib UNISIM
vlib modelsim_lib
vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlib UNISIM
vmap unisim UNISIM

# Compile the unisim VCOMP file into the unisim library
vcom -2008 /opt/Xilinx/Vivado/2023.2/data/vhdl/src/unisims/unisim_VCOMP.vhd -work unisim

#
# Build the IP Cores simulation files.  NOTE they are all VERILOG!  This is why
# we use vlog instead of vcomp.  The glbl.v file is needed if you have any verilog
# code in a simulation
#
vlog -work xil_defaultlib  "+incdir+../ipstatic" "../backend/scripting/${2}/generated_ip/clk_wiz_0/clk_wiz_0.v" 
vlog -work xil_defaultlib  "+incdir+../ipstatic"  "../backend/scripting/${2}/generated_ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" 

vlog -work xil_defaultlib  "+incdir+../ipstatic"  "../backend/scripting/${2}/generated_ip/fifo_generator_0/sim/fifo_generator_0.v"

# Specify the board package to use
vcom -2008 ../../Common/Boards/${2}/${2}_pkg.vhd -work work


# DUT source code
vcom -2008 ../../Common/DigiKey/UART/uart.vhd
vcom  ../../Common/DigiKey/PMOD/pmod_accelerometer_adxl362.vhd
vcom  ../../Common/DigiKey/SPI/spi_master.vhd
vcom  ../../Common/DigiKey/I2C/i2c_master.vhd
vcom  ../../Common/DigiKey/PMOD/pmod_hygrometer.vhd    

vcom -2008 ../../Common/CSUN/edge_detector.vhd
vcom -2008 ../rtl/accelerometer_processing.vhd
vcom -2008 ../rtl/accelerometer_to_uart.vhd
vcom -2008 ../rtl/hygrometer_to_uart.vhd    
vcom -2008 ../rtl/system_controller.vhd
vcom -2008 ../rtl/top.vhd

# Simulate the specified test case
vcom -2008 ../testbench/uart_tb_pkg.vhd -work work
vcom -2008 ${1}.vhd

# Simulate the PMOD ACL2 board
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362_pkg.vhd -work work
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362_accelerometer.vhd
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362_regs.vhd
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362_spi.vhd
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362_system_controller.vhd
vcom -2008 ../../Common/CSUN/PMOD/ACL2/adxl362.vhd

vcom -2008 ../../Common/CSUN/PMOD/Hygrometer/hdc1080_pkg.vhd -work work
vcom -2008 ../../Common/CSUN/PMOD/Hygrometer/hdc1080_i2c.vhd
vcom -2008 ../../Common/CSUN/PMOD/Hygrometer/hdc1080.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd
vcom -2008 ../testbench/uart_tx_tb.vhd
vcom -2008 ../testbench/uart_rx_tb.vhd

# Build glbl for the IP catalog components
vlog ../../Common/Xilinx/glbl.v


vsim -onfinish stop work.testbench -l ${1}_${2}_modelsim.log -L xil_defaultlib -L unisims_ver xil_defaultlib.clk_wiz_0 xil_defaultlib.fifo_generator_0 xil_defaultlib.glbl -L fifo_generator_v13_2_9

do wave.do

run -all
