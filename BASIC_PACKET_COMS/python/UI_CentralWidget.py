import PySide6
import PySide6.QtWidgets
import PySide6.QtGui
import PySide6.QtCore

import CSUNLib

# import GPIOUI
# import SerialPortUI


class UI_CentralWidget(PySide6.QtWidgets.QDialog):
    """GUI class to hold all the elements."""

    def __init__(self, parent=None):
        """UI constructor."""
        super(UI_CentralWidget, self).__init__(parent)

        topVboxLayout = PySide6.QtWidgets.QVBoxLayout()
        self.mySerialPort = CSUNLib.SerialPortUI.SerialPortUI()
        # self.mySerialPort.connectButtonSignal.connect(self.serialPortConnect)

        enableIcon = PySide6.QtGui.QIcon("green_ball.png")
        disableIcon = PySide6.QtGui.QIcon("black_ball.png")
        self.GPIO_LEDS = CSUNLib.GPIOUI.GPIOUI(
            label="LEDS", enableIcon=enableIcon, disableIcon=disableIcon
        )

        enableIcon = PySide6.QtGui.QIcon("upward.png")
        disableIcon = PySide6.QtGui.QIcon("download.png")
        self.GPIO_SW = CSUNLib.GPIOUI.GPIOUI(
            label="Switches", enableIcon=enableIcon, disableIcon=disableIcon
        )
        topVboxLayout.addLayout(self.mySerialPort.getLayout())
        topVboxLayout.addLayout(self.GPIO_LEDS.getLayout())
        topVboxLayout.addLayout(self.GPIO_SW.getLayout())

        self.setLayout(topVboxLayout)
        # for i in self.GPIO_LEDS.listGPIO:
        # print(type(i.pushButtonSignal))
        # print(i.index)
        # i.pushButtonSignal.connect(self.ledsPushButtonClicked)

        return

    def serialPortConnect(self):
        """Serial Port Connected."""

        print("UI Central Widget serial Port Connect")
        # identification = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_IDENTIFICATION)
        # print("SYSCON IDENTIFICATION {:08x}".format(identification))
        # self.mySyscon.updateIdentification(identification)

        # control = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_CONTROL)
        # self.mySyscon.SysconControlLineEdit.setText("{:08x}".format(control))

        # status = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_STATUS)
        # print("SYSCON STATUS {:08x}".format(status))
        # if status & B_SYSCON_STATUS_LOCKED:
        #    self.mySyscon.SysconStatusLockedCheckBox.setChecked(True)

    def ledsPushButtonClicked(self, index=None):
        """Called when led Push button being clicked."""
        if self.mySerialPort.serial_port.is_open is False:
            return

        if index is None:
            return

        myBit = 1 << index
        print("\n")
        print("*" * 80)
        print("ledsPushButtonClicked {} {:x} ".format(index, myBit))

        """
        READ
        """
        # gpioLEDS = self.mySerialPort.serial_port.CPU_Read(GPIO_R_OUT)
        # print("Response gpioLEDS = {}".format(gpioLEDS))

        """
        MODIFY
        """
        # gpioLEDS = gpioLEDS ^ myBit
        # print("Modified gpioLEDS = {:x}".format(gpioLEDS))

        """
        WRITE
        """
        # self.mySerialPort.serial_port.CPU_Write(GPIO_R_OUT, gpioLEDS)

        """
        Update GPIO UI
        """
        # self.GPIO_LEDS.listGPIO[15 - index].updateState()
        return
