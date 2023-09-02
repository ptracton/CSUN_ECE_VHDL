set_property design_mode GateLvl [current_fileset]
set_property parent.project_path artys7.xpr [current_project]
add_files -quiet synthesis/artys7.dcp
read_xdc ../../constraints/artys7.xdc
link_design -top artys7 -part  xc7s50csga324-1

opt_design 
write_checkpoint -force implementation/artys7_opt.dcp
catch {report_drc -file implementation/artys7_drc_opted.rpt}

place_design 
write_checkpoint -force implementation/artys7_placed.dcp
catch { report_io -file implementation/artys7_io_placed.rpt }
catch { report_utilization -file implementation/artys7_utilization_placed.rpt -pb implementation/artys7_utilization_placed.pb }
catch { report_control_sets -verbose -file implementation/artys7_control_sets_placed.rpt }

route_design 
write_checkpoint -force implementation/artys7_routed.dcp
catch { report_drc -file implementation/artys7_drc_routed.rpt -pb implementation/artys7_drc_routed.pb }
catch { report_timing_summary -warn_on_violation -max_paths 10 -file implementation/artys7_timing_summary_routed.rpt -rpx implementation/artys7_timing_summary_routed.rpx }
catch { report_power -file implementation/artys7_power_routed.rpt -pb implementation/artys7_power_summary_routed.pb }
catch { report_route_status -file implementation/artys7_route_status.rpt -pb implementation/artys7_route_status.pb }
catch { report_clock_utilization -file implementation/artys7_clock_utilization_routed.rpt }

open_checkpoint implementation/artys7_routed.dcp
write_vhdl implementation/top_timesim.vhd
write_sdf implementation/top_timesim.sdf
