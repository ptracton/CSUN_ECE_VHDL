set_property design_mode GateLvl [current_fileset]
set_property parent.project_path artys7.xpr [current_project]
open_checkpoint implementation/artys7_routed.dcp
write_bitstream -force bitgen/artys7.bit
#write_bmm -force bitgen/artys7.bmm
#write_hwdef -force -file bitgen/artys7.hwdef
#write_sysdef  -hwdef bitgen/artys7.hwdef -bitfile bitgen/artys7.bit -meminfo bitgen/artys7.mmi  
