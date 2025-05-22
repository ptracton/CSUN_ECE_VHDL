#! /usr/bin/sh

# ADJUST THIS LINE FOR YOUR PATH
export CSUN_ECE_VHDL_ROOT_DIR="/home/ptracton/CSUN/CSUN_ECE_VHDL/"

# DO NOT MODIFY BELOW HERE
export PATH="$PATH":/opt/intelFPGA_pro/21.1/modelsim_ase/bin
source /opt/Xilinx/Vivado/2023.2/settings64.sh
export XILINX_VIVADO="/opt/Xilinx/Vivado/2023.2/"
export PYTHONPATH=$CSUN_ECE_VHDL_ROOT_DIR/Common/Python/CSUNLib
source $CSUN_ECE_VHDL_ROOT_DIR/Common/Python/CSUN_PYTHON/bin/activate
