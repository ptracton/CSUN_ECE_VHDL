
create_project -part  xc7z010clg400-1 -force sim_libs
set_property compxlib.modelsim_compiled_library_dir ./Xilinx_Libs  [current_project]
compile_simlib -simulator modelsim -simulator_exec_path {/opt/intelFPGA_lite/20.1/modelsim_ase/bin/} -gcc_exec_path {/usr/bin/} -family artix7 -family spartan7 -family zynq -language vhdl -library unisim -dir {./Xilinx_Libs} -force -verbose 
