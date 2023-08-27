#! /usr/bin/env python3

"""
run_regression.py

Run VHDL FPGA simulations via Vivado or Modelsim as a regression

"""

import argparse
import datetime
import re
import shlex
import subprocess
import sys


if __name__ == "__main__":

    regression_start_time = datetime.datetime.now()

    parser = argparse.ArgumentParser(description="Run FPGA Simulation")
    parser.add_argument("-D", "--debug", help="Debug this script", action="store_true")
    parser.add_argument("--tests", help="List of tests to run", action="store")
    parser.add_argument("--modelsim", help="Use Altera Modelsim", action="store_true")
    parser.add_argument("--vivado", help="Use Xilinx Vivado XSim", action="store_true")
    parser.add_argument(
        "--corner", help="RTL or Fast or Slow", default="RTL", action="store"
    )

    args = parser.parse_args()
    if args.debug:
        print(args)

    try:
        f = open(args.tests, "r")
        lines = f.readlines()
        f.close()
    except:
        print("Failed to open or read %s" % (args.tests))
        sys.exit(-1)

    # Run the simulations
    tool = None
    for line in lines:
        if args.modelsim:
            command = f"../tools/run_sim.py --modelsim"
            tool = "modelsim"
        elif args.vivado:
            command = f"../tools/run_sim.py --vivado"
            tool = "vivado"
        else:
            print("Modelsim or Vivado must be specified")
            sys.exit(-1)

        command = command + f" --simulation {line}"
        print(command)
        command = shlex.split(command)
        p = subprocess.Popen(command)
        p.communicate()

    # Collect the results
    test_passed_count = 0
    test_results_dict = {}
    for line in lines:
        log_file_name = line.rstrip() + f".{tool}.log"
        try:
            f = open(log_file_name)
            log_lines = f.readlines()
            f.close()
        except:
            print(f"Failed  to open or read from {log_file_name}")
            break

        key = f"{line}"
        test_results_dict[key] = False
        for row in log_lines:
            match = re.search("Note: TEST PASSED", row)
            if match:
                test_passed_count = test_passed_count + 1
                test_results_dict[key] = True

    regression_finish_time = datetime.datetime.now()
    print(f"\n\nRegression {args.tests} is DONE")
    print(f"Run Time = {regression_finish_time - regression_start_time}")
    print(f"Ran {len(lines)} tests")
    print(f"Passed {test_passed_count} tests")
    print(f"Passing Rate = {(test_passed_count/len(lines))  * 100}%")

    print("\nResults")
    for k, v in test_results_dict.items():

        print(f"{k.rstrip()} {v}")
