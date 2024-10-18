open_project uart_echo.xpr


set_property design_mode GateLvl [current_fileset]
set_property parent.project_path zybo.xpr [current_project]
open_checkpoint implementation/zybo_post_route.dcp
write_bitstream -force bitgen/zybo.bit
