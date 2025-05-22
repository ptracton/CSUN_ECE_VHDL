#! /usr/bin/env python3

"""
This is our Serial Port class.  It inherits from PySerial.  We extend it for
our needs as a packet communication system.
"""
import array
import logging
import serial
import threading
import time
import serial.tools.list_ports

# import Packet


class SerialPort(serial.Serial):
    """
    This is the SerialPort class.

    It inherits from pyserial,
    http://pyserial.sourceforge.net/.  It defaults to 115200 baud rate
    8 data bits, no parity and 1 stop bit.
    """

    def __init__(
        self,
        port="/dev/ttyUSB1",
        baud_rate="115200",
        bits=8,
        parity="None",
        stop_bits=1,
    ):
        """Manage the serial port.

        This will open the serial port specified or terminate the program if it can not open it.
        """
        super(SerialPort, self).__init__(timeout=0.25)
        try:
            com_port_list = list(serial.tools.list_ports.comports())
            self.ports = [x[0] for x in com_port_list]
        except (NameError, TypeError):
            self.ports = ["/dev/ttyUSB0"]

        print("List of Ports {}".format(self.ports))

        bits = 8
        parity = "None"
        self.baudrate = 115200

        if bits == 8:
            # self.setByteSize(serial.EIGHTBITS)
            self.bytesize = serial.EIGHTBITS
        elif bits == 7:
            # self.setByteSize(serial.SEVENBITS)
            self.bytesize = serial.SEVENBITS
        elif bits == 6:
            # self.setByteSize(serial.SIXBITS)
            self.bytesize = serial.SIXBITS
        elif bits == 5:
            # self.setByteSize(serial.FIVEBITS)
            self.bytesize = serial.FIVEBITS

        if parity == "None":
            # self.setParity(serial.PARITY_NONE)
            self.parity = serial.PARITY_NONE
        elif parity == "Even":
            # self.setParity(serial.PARITY_EVEN)
            self.parity = serial.PARITY_EVEN
        elif parity == "Odd":
            # self.setParity(serial.PARITY_ODD)
            self.parity = serial.PARITY_ODD
        elif parity == "Mark":
            # self.setParity(serial.PARITY_MARK)
            self.parity = serial.PARITY_MARK
        elif parity == "Space":
            # self.setParity(serial.PARITY_SPACE)
            self.parity = serial.PARITY_SPACE
        if stop_bits == 1:
            # self.setStopbits(serial.STOPBITS_ONE)
            self.stopbits = serial.STOPBITS_ONE
        elif stop_bits == 2:
            # self.setStopbits(serial.STOPBITS_TWO)
            self.stopbits = serial.STOPBITS_TWO

        self.running = True
        self.receive_thread = threading.Thread(target=self.receive_data)
        self.receive_thread.daemon = (
            True  # Allow program to exit even if thread is running
        )
        self.receive_thread.start()

        return

    def connect(self):
        """Attempt to open the serial port."""
        try:
            self.open()
            logging.info("%s: Open Serial Port successful" % (__name__))
        except OSError:
            logging.error("%s: Failed to open Serial Port" % (__name__,))
        return

    def get_list_of_ports(self):
        """Return a list of serial ports on this computer."""
        return self.ports

    def receive_data(self):
        data = None
        print(f"Receive Data Starting")
        while self.running:
            print(f"Receive Data Running {self.in_waiting}")
            if self.is_open is True and self.in_waiting > 0:
                data = self.read()
                print(f"Received: {data} {self.in_waiting}")
                # time.sleep(0.1)
            else:
                time.sleep(1)

    def transmit_binary(self, data):
        """Send binary data and NOT ASCII data.

        We expect a list of numbers to be transmitted.
        """
        #
        # http://stackoverflow.com/questions/472977/binary-data-with-pyserialpython-serial-port
        #
        print("Trans Binary: ", data)
        # transmit = array.array("B", data).tostring()
        # transmit = {!r}'.format(data)'
        # print("Transmit", transmit)
        self.write(data.encode())

        return
