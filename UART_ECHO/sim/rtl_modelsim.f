set XILINX_DIR $env(XILINX_VIVADO)
set BOARD $env(SIMULATION_BOARD)
set TEST_CASE $env(SIMULATION_TEST_CASE)

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
vcom -2008 $XILINX_DIR/data/vhdl/src/unisims/unisim_VCOMP.vhd -work unisim

#
# Build the IP Cores simulation files.  NOTE they are all VERILOG!  This is why
# we use vlog instead of vcomp.  The glbl.v file is needed if you have any verilog
# code in a simulation
#
vlog -work xil_defaultlib  "+incdir+../ipstatic" "../backend/scripting/${BOARD}/generated_ip/clk_wiz_0/clk_wiz_0.v" 
vlog -work xil_defaultlib  "+incdir+../ipstatic"  "../backend/scripting/${BOARD}/generated_ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" 


# DUT source code
vcom -2008 ../../Common/DigiKey/UART/uart.vhd
vcom -2008 ../../Common/CSUN/system_controller.vhd
vcom -2008 ../../Common/CSUN/edge_detector.vhd
vcom -2008 ../rtl/top.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd
vcom -2008 ../testbench/uart_tx_tb.vhd
vcom -2008 ../testbench/uart_rx_tb.vhd
vcom -2008 ../testbench/uart_tb_pkg.vhd -work work

# Build glbl for the IP catalog components
vlog ../../Common/Xilinx/glbl.v

vcom -2008 ${TEST_CASE}.vhd

vsim -onfinish stop work.testbench -L xil_defaultlib -L unisims_ver xil_defaultlib.clk_wiz_0 xil_defaultlib.glbl


run -all;
quit

