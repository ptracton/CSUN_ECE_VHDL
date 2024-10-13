vlib work
vlib UNISIM
vlib modelsim_lib
vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vmap unisim UNISIM

# DUT source code
vcom -2008 ../../Common/DigiKey/UART/uart.vhd
vcom -2008 ../rtl/edge_detector.vhd
vcom -2008 ../rtl/top.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd
vcom -2008 ../testbench/uart_tx_tb.vhd
vcom -2008 ../testbench/uart_rx_tb.vhd
vcom -2008 ../testbench/uart_tb_pkg.vhd -work xil_defaultlib

vsim -onfinish stop work.testbench


run -all;
quit

