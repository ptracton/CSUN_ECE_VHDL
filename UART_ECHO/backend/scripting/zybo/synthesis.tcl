
create_project -part  xc7z010clg400-1 -force uart_echo

set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet


read_vhdl -vhdl2008 -library xil_defaultlib {
    ../../../rtl/zybo/zybo_pkg.vhd
    ../../../../Common/DigiKey/UART/uart.vhd
    ../../../../Common/CSUN/system_controller.vhd
    ../../../../Common/CSUN/edge_detector.vhd
    ../../../rtl/top.vhd      
}

read_ip  IP/clk_wiz_0.xci
upgrade_ip -quiet [get_ips *]
generate_target {all} [get_ips *]

#file rename -force [glob ../../../zybo.gen/sources_1/ip/*] ./generated_IP/

# Set VHDL-2008 standard for all VHDL files
set_property FILE_TYPE {VHDL 2008} [get_files *.vhd]

read_xdc ../../constraints/zybo.xdc

synth_ip -force [get_ips *]

synth_design -top uart_echo

write_vhdl -force -mode funcsim synthesis/top_funcsim.vhd
write_sdf -force synthesis/top_funcsim.sdf

write_checkpoint -noxdef -force synthesis/zybo.dcp
catch { report_utilization -file synthesis/zybo_utilization_synth.rpt -pb synthesis/zybo_utilization_synth.pb }

close_project
