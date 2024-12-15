#! /usr/bin/env python3

"""
UI Class for interfacing with GPIOs on the Basys 3 FPGA board
"""

import sys

import PySide6
import PySide6.QtGui
import PySide6.QtWidgets

from . import GPIO

# import GPIO


class GPIOUI:
    """GUI class for GPIO modules."""

    def __init__(
        self, width=16, direction=None, label="GPIO", enableIcon=None, disableIcon=None
    ):
        """UI constructor."""
        self.width = width
        self.direction = direction
        self.enableIcon = enableIcon
        self.disableIcon = disableIcon
        self.listGPIO = []
        self.gpioLayout = PySide6.QtWidgets.QHBoxLayout()

        self.gpioLayout.addWidget(PySide6.QtWidgets.QLabel(label))

        for x in reversed(range(self.width)):
            button = PySide6.QtWidgets.QPushButton()
            myGPIO = GPIO.GPIO(
                index=x,
                pushButton=button,
                enableIcon=self.enableIcon,
                disableIcon=self.disableIcon,
            )
            self.gpioLayout.addWidget(myGPIO.pushButton)
            self.listGPIO.append(myGPIO)
            del myGPIO

        pass

    def getLayout(self):
        """Return our layout for easy GUI integration."""
        return self.gpioLayout


if __name__ == "__main__":

    class TestUI(PySide6.QtWidgets.QDialog):
        """Simple UI testing class."""

        def __init__(self, parent=None):
            """UI testing constructor."""
            super(TestUI, self).__init__(parent)
            layOut = PySide6.QtWidgets.QVBoxLayout()

            enableIcon = PySide6.QtGui.QIcon("green_ball.png")
            disableIcon = PySide6.QtGui.QIcon("black_ball.png")
            self.gpio_ui = GPIOUI(
                label="LEDS", enableIcon=enableIcon, disableIcon=disableIcon
            )

            enableIcon = PySide6.QtGui.QIcon("upward.png")
            disableIcon = PySide6.QtGui.QIcon("download.png")
            self.gpio_ui_sw = GPIOUI(
                label="Switches", enableIcon=enableIcon, disableIcon=disableIcon
            )

            layOut.addLayout(self.gpio_ui.getLayout())
            layOut.addLayout(self.gpio_ui_sw.getLayout())

            self.setLayout(layOut)
            pass

    app = PySide6.QtWidgets.QApplication(sys.argv)
    GUI = TestUI()
    GUI.show()
    app.exec()
