#! /usr/bin/sh

export PROJECT_PATH="/home/ptracton/CSUN/CSUN_ECE_VHDL"

export PATH="$PATH":/opt/intelFPGA_lite/20.1/modelsim_ase/bin/
source /opt/Xilinx/Vivado/2023.2/settings64.sh
export XILINX_VIVADO="/opt/Xilnx/Vivado/2023.2/"

unset PYTHONPATH
export PYTHONPATH=$PROJECT_PATH/Common/Python/
source $PROJECT_PATH/Common/Python/CSUN_PYTHON/bin/activate
