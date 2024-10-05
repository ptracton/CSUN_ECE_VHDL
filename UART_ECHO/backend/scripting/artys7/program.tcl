# Connect to the Digilent Cable on localhost:3121

open_hw
connect_hw_server
open_hw_target

# https://projectf.io/posts/vivado-tcl-build-script/
set_property PROGRAM.FILE {./bitgen/artys7.bit} [current_hw_device]
program_hw_devices [current_hw_device]
