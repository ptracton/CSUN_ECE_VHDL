#! /usr/bin/sh

rm -rf vivado*
rm -rf uart_echo*

vivado -mode batch -source setup.tcl > xilinx_setup.txt
vivado -mode batch -source compile.tcl > xilinx_compile.txt
