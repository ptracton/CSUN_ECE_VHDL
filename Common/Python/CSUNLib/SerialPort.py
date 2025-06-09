#! /usr/bin/env python3

"""
SerialPort class extending PySerial with threaded read loop and callback support.
Defaults to 115200 baud, 8N1. Compatible with PySerial 3.5+.
"""

import logging
import threading
import time
import serial
import serial.tools.list_ports


class SerialPort(serial.Serial):
    def __init__(
        self,
        port="/dev/ttyUSB1",
        baud_rate="115200",
        bits=8,
        parity="None",
        stop_bits=1,
    ):
        # Convert parameters to pyserial constants
        if bits == 8:
            bytesize = serial.EIGHTBITS
        elif bits == 7:
            bytesize = serial.SEVENBITS
        elif bits == 6:
            bytesize = serial.SIXBITS
        elif bits == 5:
            bytesize = serial.FIVEBITS
        else:
            raise ValueError("Unsupported bits value")

        if parity == "None":
            parity_mode = serial.PARITY_NONE
        elif parity == "Even":
            parity_mode = serial.PARITY_EVEN
        elif parity == "Odd":
            parity_mode = serial.PARITY_ODD
        elif parity == "Mark":
            parity_mode = serial.PARITY_MARK
        elif parity == "Space":
            parity_mode = serial.PARITY_SPACE
        else:
            raise ValueError("Unsupported parity")

        if stop_bits == 1:
            stopbits = serial.STOPBITS_ONE
        elif stop_bits == 2:
            stopbits = serial.STOPBITS_TWO
        else:
            raise ValueError("Unsupported stop_bits")

        # Initialize the Serial object with correct settings
        super().__init__(
            port=port,
            baudrate=int(baud_rate),
            bytesize=bytesize,
            parity=parity_mode,
            stopbits=stopbits,
            timeout=0.1,
        )

        # Internal state
        self._running = False
        self._on_data = None
        self._on_error = None

        # Port list discovery
        try:
            com_port_list = list(serial.tools.list_ports.comports())
            self.ports = [x.device for x in com_port_list]
        except Exception:
            self.ports = ["/dev/ttyUSB0"]

        print("List of Ports:", self.ports)

    def set_data_callback(self, callback):
        """Set a callback for receiving data. Expects: callback(data: bytes)"""
        self._on_data = callback

    def set_error_callback(self, callback):
        """Set a callback for error messages. Expects: callback(message: str)"""
        self._on_error = callback

    def connect(self):
        """Open the serial port and start the read thread."""
        try:
            if not self.is_open:
                self.open()
            self._running = True
            self._thread = threading.Thread(target=self._read_loop, daemon=True)
            self._thread.start()
            logging.info("%s: Open Serial Port successful" % (__name__))
        except OSError as e:
            logging.error("%s: Failed to open Serial Port: %s" % (__name__, e))
            if self._on_error:
                self._on_error(f"[Connection Error] {e}")

    def stop(self):
        """Stop reading and close the port."""
        self._running = False
        if self.is_open:
            self.close()
        if self._on_error:
            self._on_error("[Disconnected]")

    def get_list_of_ports(self):
        """Return list of serial ports."""
        return self.ports

    def _read_loop(self):
        """Threaded read loop — reads one byte at a time."""
        while self._running:
            try:
                data = self.read(1)
                if data and self._on_data:
                    self._on_data(data)
                else:
                    time.sleep(0.001)
            except Exception as e:
                if self._on_error:
                    self._on_error(f"[Read Error] {e}")
                break

    def transmit_binary(self, data):
        """Send binary or ASCII data, one byte at a time, with short delay.

        Accepts:
        - str: sends one character at a time with delay
        - list[int]: sends each byte individually with delay
        """
        print("TX:", data)
        try:
            if self.is_open:
                if isinstance(data, str):
                    for c in data:
                        self.write(c.encode())
                        time.sleep(0.01)  # Delay to allow echo reception
                elif isinstance(data, list):
                    for b in data:
                        self.write(bytes([b]))
                        time.sleep(0.01)
                else:
                    raise TypeError("transmit_binary expects str or list[int]")
        except Exception as e:
            if self._on_error:
                self._on_error(f"[Write Error] {e}")
