# Vivado batch script: build one design and program the board.
#Code taken from https://github.com/ddsva1/bu-ec551-proj1
# Run by fpga_build.py, which copies this script and the design files into one
# work folder and runs Vivado there as:
#   vivado -mode batch -source build.tcl -tclargs <part> <bitfile> <xdc> <verilog files...>

lassign $argv part bitfile xdc
set sources [lrange $argv 3 end]

# 1. read the design: the generated circuit_sop / circuit_pos and the board wrapper
foreach file $sources {
    read_verilog $file
}
read_xdc $xdc

# 2. synthesis and implementation
synth_design -top top -part $part
opt_design
place_design
route_design

# 3. bitstream
write_bitstream -force $bitfile

# 4. program the board connected over USB
open_hw_manager
connect_hw_server
if {[catch {open_hw_target}]} {
    puts "ERROR: no board found. Plug in the board over USB, turn it on, and run again."
    puts "       (The bitstream was written to build/$bitfile)"
    exit 1
}
set device [lindex [get_hw_devices xc7*] 0]
current_hw_device $device
set_property PROGRAM.FILE $bitfile $device
program_hw_devices $device
close_hw_manager
puts "Programmed $device with build/$bitfile"
