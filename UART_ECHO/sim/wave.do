onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/clk
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/reset
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/rx
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/tx
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/tx_start
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/uart_data_rx
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/uart_data_tx
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/XCLK
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/XRESET
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/XRX
add wave -noupdate -group DUT -radix hexadecimal /testbench/DUT/XTX
add wave -noupdate -group DUT /testbench/DUT/reset_n
add wave -noupdate -group DUT /testbench/DUT/rx_busy
add wave -noupdate -group DUT /testbench/DUT/rx_busy_falling
add wave -noupdate -group DUT /testbench/DUT/rx_busy_rising
add wave -noupdate -group DUT /testbench/DUT/rx_error
add wave -noupdate -group DUT /testbench/DUT/tx_start
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/phil
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/rx_byte
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/rx_data
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/rx_dv
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/terminate
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/test_done
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/test_fail
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/tx_active
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/tx_byte
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/tx_done
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/tx_dv
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/XCLK
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/XRESET
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/XRX
add wave -noupdate -group TEST -radix hexadecimal /testbench/test/XTX
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/baud_pulse
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/baud_rate
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/clk
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/clk_freq
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/d_width
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/os_pulse
add wave -noupdate -group {DUT UART} -radix decimal /testbench/DUT/uart_inst/os_rate
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/parity
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/parity_eo
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/parity_error
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/reset_n
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_buffer
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_busy
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_data
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_error
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_parity
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/rx_state
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_buffer
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_busy
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_data
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_ena
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_parity
add wave -noupdate -group {DUT UART} -radix hexadecimal /testbench/DUT/uart_inst/tx_state
add wave -noupdate -group EDGE /testbench/DUT/edge/clk
add wave -noupdate -group EDGE /testbench/DUT/edge/data_in
add wave -noupdate -group EDGE /testbench/DUT/edge/edge
add wave -noupdate -group EDGE /testbench/DUT/edge/falling
add wave -noupdate -group EDGE /testbench/DUT/edge/reset
add wave -noupdate -group EDGE /testbench/DUT/edge/rising
add wave -noupdate -group EDGE /testbench/DUT/edge/synch
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/clk_in
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_in
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/clk_out
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/locked
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_out
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_counter
add wave -noupdate -expand -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/locked_wiz
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {213792000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 fs} {370162800 ps}
