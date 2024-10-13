
create_project -force artys7  -part  xc7s50csga324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_vhdl -library xil_defaultlib {
    ../../../rtl/artys7/artys7_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../rtl/edge_detector.vhd
    ../../../rtl/top.vhd     
}


read_xdc ../../constraints/artys7.xdc
set_property used_in_implementation false [get_files artys7.xdc]

synth_design -top uart_echo -part  xc7s50csga324-1
write_checkpoint -noxdef -force synthesis/artys7.dcp
catch { report_utilization -file synthesis/artys7_utilization_synth.rpt -pb synthesis/artys7_utilization_synth.pb }

open_checkpoint synthesis/artys7.dcp
write_vhdl -force -mode funcsim synthesis/top_funcsim.vhd
write_sdf -force synthesis/top_funcsim.sdf
