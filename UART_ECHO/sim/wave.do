onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/XLEDS
add wave -noupdate -expand -group TESTBENCH -radix hexadecimal /testbench/XSWITCHES
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XLEDS
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XSWITCHES
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/gpio_bus
add wave -noupdate -expand -group LEDS -radix hexadecimal /testbench/DUT/LEDS/WIDTH
add wave -noupdate -expand -group LEDS -radix hexadecimal /testbench/DUT/LEDS/bidir
add wave -noupdate -expand -group LEDS -radix hexadecimal /testbench/DUT/LEDS/inp
add wave -noupdate -expand -group LEDS -radix hexadecimal /testbench/DUT/LEDS/oe
add wave -noupdate -expand -group LEDS -radix hexadecimal /testbench/DUT/LEDS/outp
add wave -noupdate -expand -group SWITCHES -radix hexadecimal /testbench/DUT/SWITCHES/WIDTH
add wave -noupdate -expand -group SWITCHES -radix hexadecimal /testbench/DUT/SWITCHES/bidir
add wave -noupdate -expand -group SWITCHES -radix hexadecimal /testbench/DUT/SWITCHES/inp
add wave -noupdate -expand -group SWITCHES -radix hexadecimal /testbench/DUT/SWITCHES/oe
add wave -noupdate -expand -group SWITCHES -radix hexadecimal /testbench/DUT/SWITCHES/outp
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
WaveRestoreZoom {0 ps} {3780 ns}
