read_verilog "adder_unit.v"
read_verilog "shifter_unit.v"
read_verilog "retention_store.v"
read_verilog "top_system.v"
read_xdc "nexys_a7.xdc"

synth_design -top "top_system" -part "xc7a100tcsg324-1"
opt_design
place_design
route_design

write_bitstream -force "top_system.bit"

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set dev [lindex [get_hw_devices] 0]
current_hw_device $dev
set_property PROGRAM.FILE "top_system.bit" $dev
program_hw_devices $dev
close_hw_manager
