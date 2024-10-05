onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/clk
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/reset
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/rx
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/tx
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/rx_data_ready
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/tx_start
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/uart_data_rx
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/uart_data_tx
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XCLK
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XRESET
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XRX
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XTX
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/phil
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/rx_byte
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/rx_data
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/rx_dv
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/terminate
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/test_done
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/test_fail
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/tx_active
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/tx_byte
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/tx_done
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/tx_dv
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/XCLK
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/XRESET
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/XRX
add wave -noupdate -expand -group TEST -radix hexadecimal /testbench/test/XTX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {29515697400 ps}
