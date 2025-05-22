#! /usr/bin/env python3
import sys
import asyncio
import serial.tools.list_ports
import serial_asyncio
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
from PySide6.QtCore import QTimer, Qt
from qasync import QEventLoop, asyncSlot


class SerialProtocol(asyncio.Protocol):
    def __init__(self, gui):
        self.gui = gui
        self.transport = None
        self.buffer = b""

    def connection_made(self, transport):
        self.transport = transport
        self.gui.update_status("Connected.")

    def data_received(self, data):
        self.gui.append_received(data)

    def connection_lost(self, exc):
        self.gui.update_status("Disconnected.")
        self.transport = None

    def send(self, data: str):
        if self.transport:
            self.transport.write(data.encode())


class SerialApp(QWidget):
    def __init__(self, loop):
        super().__init__()
        self.setWindowTitle("UART Async Terminal (115200 8N1)")
        self.protocol = None
        self.loop = loop

        self.init_ui()
        self.check_ports()

        # Refresh ports every 3 seconds
        self.port_timer = QTimer()
        self.port_timer.timeout.connect(self.check_ports)
        self.port_timer.start(3000)

    def init_ui(self):
        self.port_selector = QComboBox()
        self.connect_button = QPushButton("Connect")
        self.connect_button.clicked.connect(self.connect_serial)

        self.text_display = QTextEdit()
        self.text_display.setReadOnly(True)

        self.hex_display = QTextEdit()
        self.hex_display.setReadOnly(True)

        self.text_input = QLineEdit()
        self.send_button = QPushButton("Send String")
        self.send_button.clicked.connect(self.send_string)

        self.status_label = QLabel("Select a port and click Connect.")

        top_layout = QHBoxLayout()
        top_layout.addWidget(QLabel("Port:"))
        top_layout.addWidget(self.port_selector)
        top_layout.addWidget(self.connect_button)

        input_layout = QHBoxLayout()
        input_layout.addWidget(QLabel("Send:"))
        input_layout.addWidget(self.text_input)
        input_layout.addWidget(self.send_button)

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

    def check_ports(self):
        current = self.port_selector.currentText()
        self.port_selector.clear()
        ports = serial.tools.list_ports.comports()
        for port in ports:
            self.port_selector.addItem(port.device)
        index = self.port_selector.findText(current)
        if index != -1:
            self.port_selector.setCurrentIndex(index)

    def update_status(self, message: str):
        self.status_label.setText(message)

    async def async_connect(self, port):
        try:
            print(f"ASYNC CONNECT {port}")
            transport, protocol = await serial_asyncio.create_serial_connection(
                loop=self.loop,
                protocol_factory=lambda: SerialProtocol(self),
                url=port,
                baudrate=115200,
            )
            self.protocol = protocol
            self.update_status(f"Connected to {port}")
        except Exception as e:
            import traceback

            self.update_status(f"[ERROR] {e}")
            traceback.print_exc()

    @asyncSlot()
    async def connect_serial(self):
        port = self.port_selector.currentText()
        print(f"CONNECT SERIAL {port}")
        if port:
            await self.async_connect(port)

    def append_received(self, data: bytes):
        try:
            text = data.decode(errors="ignore")
            hex_text = " ".join(f"{b:02X}" for b in data)
            self.text_display.insertPlainText(text)
            # self.text_display.moveCursor(self.text_display.textCursor())
            self.hex_display.insertPlainText(hex_text + " ")
            # self.hex_display.moveCursor(self.hex_display.textCursor())
        except Exception as e:
            self.update_status(f"[Decode ERROR] {e}")

    def send_string(self):
        if not self.protocol:
            self.update_status("Not connected.")
            return

        msg = self.text_input.text()
        self.text_input.clear()
        self.loop.create_task(self._send_and_wait_for_echo(msg))

    async def _send_and_wait_for_echo(self, msg: str):
        for char in msg:
            self.protocol.send(char)
            await asyncio.sleep(0.01)  # avoid flooding echo receiver

    def closeEvent(self, event):
        if self.protocol and self.protocol.transport:
            self.protocol.transport.close()
        event.accept()


def main():
    app = QApplication(sys.argv)

    loop = QEventLoop(app)
    asyncio.set_event_loop(loop)

    window = SerialApp(loop)
    window.show()

    with loop:
        loop.run_forever()


if __name__ == "__main__":
    main()
