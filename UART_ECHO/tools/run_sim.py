#! /usr/bin/env python3

"""
run_sim.py

Run VHDL FPGA simulations via Vivado or Modelsim

"""

import json
import os
import shlex
import subprocess
import sys
import argparse
import string


def which(program):
    """
    Find the path to an executable program
    """

    def is_exe(fpath):
        """
        Return True is the fpath exists and is executable.  This is needed since the
        executables are specifed in the JSON files, but not the path to them.  The
        executables may be in different locations based on which PC is running this.
        """
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run FPGA Simulation")
    parser.add_argument("-D", "--debug", help="Debug this script", action="store_true")
    parser.add_argument("--corner", help="Fast or Slow", default="RTL", action="store")
    parser.add_argument("--modelsim", help="Use Altera Modelsim", action="store_true")
    parser.add_argument("--vivado", help="Use Xilinx Vivado XSim", action="store_true")

    parser.add_argument(
        "--board",
        help="Which board are we running on, artys7, basys3 boolean or zybo",
        required=True,
        action="store",
    )

    parser.add_argument(
        "--simulation",
        help="Which simulation test case to run",
        required=True,
        action="store",
    )

    print(os.environ["PATH"])
    args = parser.parse_args()
    if args.debug:
        print(args)

    if args.modelsim:
        json_file = "../configurations/simulate_modelsim.json"
        tool = "modelsim"
    if args.vivado:
        json_file = "../configurations/simulate_vivado.json"
        tool = "vivado"

    try:
        f = open(json_file, "r")
        json_data = json.load(f)
    except:
        print("Failed to open %s" % (json_file))
        sys.exit(-1)

    flow_steps = json_data["flow_steps"]
    print(flow_steps)

    os.environ["SIMULATION_TEST_CASE"] = args.simulation
    os.environ["SIMULATION_BOARD"] = args.board

    for step in sorted(flow_steps.keys()):
        print("Running Step: %s " % step)
        executable = json_data["flow"][flow_steps[step]]["executable"]
        arguments = string.Template(json_data["flow"][flow_steps[step]]["arguments"])
        arguments_str = arguments.safe_substitute(
            simulation=args.simulation, board=args.board, corner=args.corner, tool=tool
        )
        # executable = which(executable)
        print(executable)
        if arguments == None:
            command = executable
        else:
            command = executable + " " + arguments_str

        print(command)
        command = shlex.split(command)
        p = subprocess.Popen(command)
        p.communicate()
