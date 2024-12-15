#! /usr/bin/env python3

import argparse
import logging
import sys

import PySide6
import PySide6.QtWidgets


import CSUNLib
import UI

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate DTREE App Stimulus")
    parser.add_argument("-D", "--debug", help="Debug this script", action="store_true")

    args = parser.parse_args()
    if args.debug:
        print(args)

    logging.basicConfig(
        filename="basic_coms.log",
        level=logging.DEBUG,
        format="%(asctime)s,%(levelname)s,%(message)s",
        datefmt="%m/%d/%Y %I:%M:%S %p",
    )

    logging.info("BASIC PACKET COMS STARTED")
    logging.info(f"CSUNLIB Version = {CSUNLib.get_version()}")
    print(f"CSUNLIB Version = {CSUNLib.get_version()}")

    app = PySide6.QtWidgets.QApplication(sys.argv)
    gui = UI.UI()
    gui.show()
    # window = PySide6.QtWidgets.QWidget()
    # window.show()

    app.exec()

    print("\nBASIC COMS DONE")
    sys.exit(0)
