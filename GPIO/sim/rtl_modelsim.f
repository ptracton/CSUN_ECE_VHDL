vlib work

# DUT source code
vcom -2008 ../rtl/gpio/gpio_bit.vhd
vcom -2008 ../rtl/gpio/gpio.vhd
vcom -2008 ../rtl/top.vhd

# Testbench and simulation source code
vcom -2008 ../testbench/testbench.vhd

vsim -onfinish stop work.testbench

do wave.do

run -all;
quit
