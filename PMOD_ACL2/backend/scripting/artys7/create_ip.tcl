
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "./generated_ip"

# Set the project name
set _xil_proj_name_ "artys7"

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# create the project
create_project -in_memory  -ip

# Set it up for Artys7-50
set_part  xc7s50csga324-1

# Set the directory path for the new project
#set proj_dir [get_property directory [current_project]]
set proj_dir "./generated_ip"
#set obj [current_project]
#set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj

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

set_property -dict [list \
  CONFIG.CLKOUT2_JITTER {197.700} \
  CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10.000} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {100} \
  CONFIG.NUM_OUT_CLKS {2} \
] [get_ips clk_wiz_0]

create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_generator_0 -dir generated_ip
set_property -dict [list \
  CONFIG.Enable_Reset_Synchronization {true} \
  CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
  CONFIG.Input_Data_Width {12} \
  CONFIG.Input_Depth {16} \
  CONFIG.Performance_Options {First_Word_Fall_Through} \
  CONFIG.Read_Data_Count {true} \
  CONFIG.Read_Data_Count_Width {5} \
  CONFIG.Use_Extra_Logic {true} \
  CONFIG.Write_Data_Count {true} \
  CONFIG.Write_Data_Count_Width {5} \
] [get_ips fifo_generator_0]
