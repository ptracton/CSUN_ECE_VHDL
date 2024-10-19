#! /usr/bin/sh

rm -rf Xilinx_Libs/
vivado -mode batch -source gen_libs.tcl

rm -rf sim_libs*

