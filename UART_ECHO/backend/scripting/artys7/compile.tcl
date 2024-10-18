# Script to compile the FPGA with zynq processor system all the way to bit file.
set setupDir ./setup
set compileDir ./compile
set bitgenDir ./bitgen
set board artys7
#file mkdir $setupDir
#file mkdir $compileDir
#file mkdir $bitgenDir
open_project uart_echo.xpr

synth_ip -force [get_ips *]

synth_design -top uart_echo
write_checkpoint -force $setupDir/post_synth.dcp
report_timing_summary -file $setupDir/post_synth_timing_summary.rpt
report_utilization -file $setupDir/post_synth_util.rpt
#reportCriticalPaths $setupDir/post_synth_critpath_report.csv


opt_design
#reportCriticalPaths $compileDir/post_opt_critpath_report.csv

place_design
report_clock_utilization -file $compileDir/clock_util.rpt

phys_opt_design
write_checkpoint -force $compileDir/post_place.dcp
report_utilization -file $compileDir/post_place_util.rpt
report_timing_summary -file $compileDir/post_place_timing_summary.rpt

route_design
write_checkpoint -force $compileDir/post_route.dcp
#report_route_status -file $compileDir/$board_post_route_status.rpt
#report_timing_summary -file $compileDir/$board_post_route_timing_summary.rpt
#report_power -file $compileDir/$board_post_route_power.rpt
#report_drc -file $compileDir/$board_post_imp_drc.rpt
#report_io -file $compileDir/$board_post_imp_io.rpt
#xilinx::ultrafast::report_io_reg -verbose -file $compileDir/$board_io_regs.rpt

write_bitstream -verbose -force $bitgenDir/top.bit

close_project

