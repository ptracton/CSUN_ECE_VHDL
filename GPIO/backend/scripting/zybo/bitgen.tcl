set_property design_mode GateLvl [current_fileset]
set_property parent.project_path zybo.xpr [current_project]
open_checkpoint implementation/zybo_routed.dcp
write_bitstream -force bitgen/zybo.bit
#write_bmm -force bitgen/zybo.bmm
#write_hwdef -force -file bitgen/zybo.hwdef
#write_sysdef  -hwdef bitgen/zybo.hwdef -bitfile bitgen/zybo.bit -meminfo bitgen/zybo.mmi  
