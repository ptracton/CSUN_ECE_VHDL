# CSUN_ECE_VHDL
Some example VHDL code for ECE students at Cal State University at Northridge (CSUN)

# Projects
+ [GPIO](https://github.com/ptracton/CSUN_ECE_VHDL/tree/main/GPIO) is a basic fully combinational design to demonstrate switch to LED connections with a General Purpose Input Ouptut module.

+ [UART_ECHO](https://github.com/ptracton/CSUN_ECE_VHDL/tree/main/UART_ECHO) is a basic UART echoing module.  Any character sent to it via putty, gets sent right back.

+ [PMOD_ACL2](https://github.com/ptracton/CSUN_ECE_VHDL/tree/main/PMOD_ACL2) is a more complicated module with 2 PMODs that transmit their data up to the PC via a UART.  The controllers come from Digikey and there is a small arbiter to make sure only 1 module is printing at a time.
