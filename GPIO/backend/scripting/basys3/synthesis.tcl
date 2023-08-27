
create_project -force basys3  -part xc7a35tcpg236-3

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_vhdl -library xil_defaultlib {
    ../../../rtl/gpio/gpio_bit.vhd
    ../../../rtl/gpio/gpio.vhd
    ../../../rtl/top.vhd    
}


read_xdc ../../constraints/basys3.xdc
set_property used_in_implementation false [get_files basys3.xdc]

synth_design -top top -part xc7a35tcpg236-3
write_checkpoint -noxdef -force synthesis/basys3.dcp
catch { report_utilization -file synthesis/basys3_utilization_synth.rpt -pb synthesis/basys3_utilization_synth.pb }

open_checkpoint synthesis/basys3.dcp
write_vhdl -mode funcsim synthesis/top_funcsim.vhd
write_sdf synthesis/top_funcsim.sdf
