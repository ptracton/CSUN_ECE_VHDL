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

# Specify the board package to use
vcom -2008 ../rtl/${2}/${2}_pkg.vhd -work xil_defaultlib


# DUT source code
vcom -2008 ../rtl/gpio/gpio_bit.vhd
vcom -2008 ../rtl/gpio/gpio.vhd
vcom -2008 ../rtl/top.vhd

# Simulate the specified test case
vcom -2008 ${1}.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd


vsim -onfinish stop work.testbench -l ${1}_${2}_modelsim.log

do wave.do

run -all;
