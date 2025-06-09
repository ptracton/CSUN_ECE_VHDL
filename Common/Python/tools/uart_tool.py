#! /usr/bin/env python3

import logging
import sys

import PySide6
import PySide6.QtWidgets

import SerialPortUI


class UI_CentralWidget(PySide6.QtWidgets.QDialog):
    """
    This class holds the GUI elements
    """

    def __init__(self, parent=None):
        super(UI_CentralWidget, self).__init__(parent)
        top_vbox_layout = PySide6.QtWidgets.QVBoxLayout()
        self.my_serial_port = SerialPortUI.SerialPortUI()

        self.my_serial_port.serial_port.set_data_callback(self.serial_data_callback)
        self.my_serial_port.serial_port.set_error_callback(self.serial_error_callback)

        top_hbox_layout = PySide6.QtWidgets.QHBoxLayout()
        uart_tx_name = PySide6.QtWidgets.QLabel("Transmit Character")
        uart_rx_name = PySide6.QtWidgets.QLabel("Receive Character")
        self.tx_char_line_edit = PySide6.QtWidgets.QLineEdit()
        self.rx_char_line_edit = PySide6.QtWidgets.QLineEdit()
        self.transmit_button = PySide6.QtWidgets.QPushButton("Send")
        self.transmit_button.clicked.connect(self.transmit_button_clicked)

        top_hbox_layout.addWidget(uart_tx_name)
        top_hbox_layout.addWidget(self.tx_char_line_edit)
        top_hbox_layout.addWidget(uart_rx_name)
        top_hbox_layout.addWidget(self.rx_char_line_edit)
        top_hbox_layout.addWidget(self.transmit_button)

        top_vbox_layout.addLayout(self.my_serial_port.getLayout())
        top_vbox_layout.addLayout(top_hbox_layout)
        self.setLayout(top_vbox_layout)

    def transmit_button_clicked(self):
        """Transmit button clicked handler"""
        character = self.tx_char_line_edit.displayText()
        if self.my_serial_port.serial_port.is_open is True:
            print(f"TRANSMIT CLICKED {character} {type(character)}")
            for x in character:
                self.my_serial_port.serial_port.transmit_binary(x)
        else:
            print(f"Can't TRANSMIT CLICKED {character} {type(character)}")
        return

    def serial_data_callback(self, data):
        """Callback on receiving data"""
        print(f"Data Callback {data}")
        current_text = self.rx_char_line_edit.text()
        self.rx_char_line_edit.setText(current_text + data.decode("utf-8"))
        return

    def serial_error_callback(self, msg):
        """When an error happens, this is the handler"""
        print(f"Error Callback {msg}")
        return


class UI(PySide6.QtWidgets.QMainWindow):
    """
    Top level UI class
    """

    def __init__(self, parent=None):
        super(UI, self).__init__(parent)

        # Create Main Window Elements
        self.statusBar().showMessage("Status Bar")
        self.setWindowTitle("UART Tool App")

        # Create our central widget
        self.centralWidget = UI_CentralWidget()
        self.setCentralWidget(self.centralWidget)

        # Display
        self.show()


if __name__ == "__main__":
    print(f"UART Tool Starting")
    logging.basicConfig(
        filename="uart_tool.log",
        level=logging.INFO,
        format="%(asctime)s,%(levelname)s,%(message)s",
        datefmt="%m/%d/%Y %I:%M:%S %p",
    )

    logging.info("UART TOOL Starting")

    app = PySide6.QtWidgets.QApplication(sys.argv)
    gui = UI()
    gui.show()
    app.exec()
