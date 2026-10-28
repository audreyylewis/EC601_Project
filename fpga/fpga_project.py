"""Prepare a Vivado project folder for a design, to build in the Vivado
Code taken from https://github.com/ddsva1/bu-ec551-proj1
Usage:
    py fpga_project.py <board> <input file>
    board: nexys  (Digilent Nexys 4 DDR)
"""

import os
import shutil
import sys

from fpga_build import BOARDS
from logic import TooLargeError
from main import load_design
from verilog_gen import verilog_name, write_verilog

TCL_TEMPLATE = """\
# Creates and opens the Vivado project for {name} on the {board} board.
# Works in any recent Vivado version:
#   Tools -> Run Tcl Script... -> select this file
#   (or in the Tcl Console:  source <path to this file>)
# Then: Generate Bitstream -> Open Hardware Manager -> Program Device.

set here [file dirname [file normalize [info script]]]
create_project {project} $here/project -part {part} -force
# [list ...] keeps paths with spaces (e.g. "EC 551") in one piece
add_files -norecurse [list {sources}]
add_files -fileset constrs_1 -norecurse [list $here/{xdc}]
set_property top top [current_fileset]
update_compile_order -fileset sources_1
"""


def main():
    if len(sys.argv) != 3 or sys.argv[1] not in BOARDS:
        print(__doc__)
        sys.exit(1)
    board_name = sys.argv[1]
    board = BOARDS[board_name]
    input_path = os.path.abspath(sys.argv[2])

    # work from the project folder so the paths below are short and relative
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    # 1. generate the Verilog straight into the design's folder
    design = load_design(input_path)
    base = verilog_name(design.name)
    project = f"{base}_{board_name}"
    folder = "vivado/" + project
    try:
        write_verilog(design.functions, design.name, design.path, folder)
    except TooLargeError as error:
        print("Stopped:", error)
        sys.exit(1)

    # 2. copy the board wrapper and constraints next to it
    shutil.copy(board["top"], folder)
    shutil.copy(board["xdc"], folder)

    # 3. write the script that creates the project on the lab machine
    sources = [f"{base}_sop.v", f"{base}_pos.v", os.path.basename(board["top"])]
    tcl = TCL_TEMPLATE.format(
        name=design.name, board=board_name, project=project, part=board["part"],
        sources=" ".join("$here/" + s for s in sources),
        xdc=os.path.basename(board["xdc"]))
    with open(os.path.join(folder, "create_project.tcl"), "w") as file:
        file.write(tcl)

    print(f"\nProject folder ready: {folder}/")
    print(f"  1. commit and push it:  git add {folder} && git commit -m \"{project}\" && git push")
    print("  2. on the lab machine:  git pull, then in Vivado:")
    print(f"     Tools -> Run Tcl Script... -> {folder}/create_project.tcl")
    print("  3. Generate Bitstream -> Open Hardware Manager -> Program Device")


if __name__ == "__main__":
    main()
