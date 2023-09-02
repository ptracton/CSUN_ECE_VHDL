set_property design_mode GateLvl [current_fileset]
set_property parent.project_path zybo.xpr [current_project]
add_files -quiet synthesis/zybo.dcp
read_xdc ../../constraints/zybo.xdc
link_design -top zybo -part  xc7z010clg400-1

opt_design 
write_checkpoint -force implementation/zybo_opt.dcp
catch {report_drc -file implementation/zybo_drc_opted.rpt}

place_design 
write_checkpoint -force implementation/zybo_placed.dcp
catch { report_io -file implementation/zybo_io_placed.rpt }
catch { report_utilization -file implementation/zybo_utilization_placed.rpt -pb implementation/zybo_utilization_placed.pb }
catch { report_control_sets -verbose -file implementation/zybo_control_sets_placed.rpt }

route_design 
write_checkpoint -force implementation/zybo_routed.dcp
catch { report_drc -file implementation/zybo_drc_routed.rpt -pb implementation/zybo_drc_routed.pb }
catch { report_timing_summary -warn_on_violation -max_paths 10 -file implementation/zybo_timing_summary_routed.rpt -rpx implementation/zybo_timing_summary_routed.rpx }
catch { report_power -file implementation/zybo_power_routed.rpt -pb implementation/zybo_power_summary_routed.pb }
catch { report_route_status -file implementation/zybo_route_status.rpt -pb implementation/zybo_route_status.pb }
catch { report_clock_utilization -file implementation/zybo_clock_utilization_routed.rpt }

open_checkpoint implementation/zybo_routed.dcp
write_vhdl implementation/top_timesim.vhd
write_sdf implementation/top_timesim.sdf
