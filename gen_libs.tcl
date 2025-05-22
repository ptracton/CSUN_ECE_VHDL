
create_project -part  xc7z010clg400-1 -force sim_libs
set_property compxlib.modelsim_compiled_library_dir ./Xilinx_Libs  [current_project]
compile_simlib -simulator modelsim -simulator_exec_path {/opt/intelFPGA_pro/21.1/modelsim_ase/bin} -gcc_exec_path {/usr/bin} -family all -language all -library unisim -dir {./Xilinx_Libs} -force -verbose
