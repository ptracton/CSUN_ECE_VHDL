vlib work

# DUT source code
vcom -2008 ../rtl/gpio/gpio_bit.vhd
vcom -2008 ../rtl/gpio/gpio.vhd
vcom -2008 ../rtl/top.vhd

# Simulate the specified test case
vcom -2008 ${1}.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd


vsim -onfinish stop work.testbench -l ${1}.log

do wave.do

run -all;
