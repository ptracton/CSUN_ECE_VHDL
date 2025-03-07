
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "./generated_ip"

# Set the project name
set _xil_proj_name_ "boolean"

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# create the project
create_project -in_memory  -ip

# Set it up for Boolean
set_part XC7S50-CSGA324-2

# Set the directory path for the new project
#set proj_dir [get_property directory [current_project]]
set proj_dir "./generated_ip"

create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0 -dir generated_ip

set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {80.0} \
  CONFIG.CLKOUT1_JITTER {119.348} \
  CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
  CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
  CONFIG.PRIM_IN_FREQ {100.000} \
] [get_ips clk_wiz_0]
generate_target all [get_ips]

