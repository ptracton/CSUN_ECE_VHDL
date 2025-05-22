#! /usr/bin/env python3

import sys
import serial
import threading
import time
import serial.tools.list_ports
from PySide6.QtWidgets import (
    QApplication,
    QWidget,
    QTextEdit,
    QLineEdit,
    QPushButton,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QComboBox,
    QSplitter,
)
from PySide6.QtCore import Signal, QObject, Qt


class SerialReader(QObject):
    text_received = Signal(str)
    hex_received = Signal(str)
    error_occurred = Signal(str)

    def __init__(self):
        super().__init__()
        self.serial = None
        self._running = False
        self._thread = None

    def open(self, port, baudrate=115200):
        try:
            self.serial = serial.Serial(port, baudrate, timeout=0.1)
            self._running = True
            self._thread = threading.Thread(target=self._read_loop, daemon=True)
            self._thread.start()
            self.error_occurred.emit(f"Connected to {port}")
        except Exception as e:
            self.error_occurred.emit(f"[ERROR] {e}")

    def stop(self):
        self._running = False
        if self.serial and self.serial.is_open:
            self.serial.close()
            self.error_occurred.emit("Serial connection closed.")

    def _read_loop(self):
        while self._running:
            try:
                if self.serial and self.serial.is_open:
                    byte = self.serial.read(1)
                    if byte:
                        char = byte.decode(errors="ignore")
                        hex_text = f"{ord(char):02X}"
                        self.text_received.emit(char)
                        self.hex_received.emit(hex_text)
            except Exception as e:
                self.error_occurred.emit(f"[ERROR] {e}")

    def send_data(self, data: str):
        try:
            if self.serial and self.serial.is_open:
                self.serial.write(data.encode())
                time.sleep(0.1)
        except Exception as e:
            self.error_occurred.emit(f"[ERROR] {e}")


class SerialApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("UART Terminal (115200 8N1)")
        self.reader = SerialReader()
        self.reader.text_received.connect(self.display_text)
        self.reader.hex_received.connect(self.display_hex)
        self.reader.error_occurred.connect(self.update_status)

        self.init_ui()

    def init_ui(self):
        # Port selection
        self.port_selector = QComboBox()
        self.refresh_ports()

        self.connect_button = QPushButton("Connect")
        self.connect_button.clicked.connect(self.connect_serial)

        # Text view for characters
        self.text_display = QTextEdit()
        self.text_display.setReadOnly(True)

        # Hex view for raw bytes
        self.hex_display = QTextEdit()
        self.hex_display.setReadOnly(True)

        # Input and send
        self.text_input = QLineEdit()
        self.send_button = QPushButton("Send String")
        self.send_button.clicked.connect(self.send_data)

        # Status display
        self.status_label = QLabel("Select a port and click Connect.")

        # Layouts
        top_layout = QHBoxLayout()
        top_layout.addWidget(QLabel("Port:"))
        top_layout.addWidget(self.port_selector)
        top_layout.addWidget(self.connect_button)

        input_layout = QHBoxLayout()
        input_layout.addWidget(QLabel("Send:"))
        input_layout.addWidget(self.text_input)
        input_layout.addWidget(self.send_button)

        # Splitter for dual buffer view
        splitter = QSplitter(Qt.Vertical)
        splitter.addWidget(self.text_display)
        splitter.addWidget(self.hex_display)
        splitter.setSizes([2, 1])

        layout = QVBoxLayout()
        layout.addLayout(top_layout)
        layout.addWidget(splitter)
        layout.addLayout(input_layout)
        layout.addWidget(self.status_label)

        self.setLayout(layout)
        self.resize(700, 500)

    def refresh_ports(self):
        self.port_selector.clear()
        ports = serial.tools.list_ports.comports()
        for port in ports:
            self.port_selector.addItem(port.device)

    def connect_serial(self):
        selected_port = self.port_selector.currentText()
        if selected_port:
            self.reader.stop()
            self.reader.open(selected_port)

    def display_text(self, data: str):
        self.text_display.insertPlainText(data)
        print(f"DISPLAY TEXT: {data}")
        # self.text_display.moveCursor(self.text_display.textCursor())

    def display_hex(self, hex_str: str):
        self.hex_display.insertPlainText(hex_str + " ")

    def send_data(self):
        msg = self.text_input.text()
        if msg:
            print(f"SEND DATA: {msg}")
            for c in msg:
                self.reader.send_data(c)
                time.sleep(0.02)  # small delay to allow echo to return
            self.text_input.clear()

    def update_status(self, message: str):
        self.status_label.setText(message)

    def closeEvent(self, event):
        self.reader.stop()
        event.accept()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = SerialApp()
    window.show()
    sys.exit(app.exec())
