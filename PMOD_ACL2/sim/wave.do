onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TESTBENCH -radix hexadecimal /testbench/clk
add wave -noupdate -group TESTBENCH -radix hexadecimal /testbench/reset
add wave -noupdate -group TESTBENCH -radix hexadecimal /testbench/rx
add wave -noupdate -group TESTBENCH -radix hexadecimal /testbench/tx
add wave -noupdate -group TESTBENCH /testbench/ss_n
add wave -noupdate -group TESTBENCH /testbench/miso
add wave -noupdate -group TESTBENCH /testbench/mosi
add wave -noupdate -group TESTBENCH /testbench/sclk
add wave -noupdate -expand -group DUT /testbench/DUT/XSS_N
add wave -noupdate -expand -group DUT /testbench/DUT/XMISO
add wave -noupdate -expand -group DUT /testbench/DUT/XMOSI
add wave -noupdate -expand -group DUT /testbench/DUT/XSCLK
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/acceleration_x
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/acceleration_y
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/acceleration_z
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/tx_start
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/uart_data_rx
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/uart_data_tx
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XCLK
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XRESET
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XRX
add wave -noupdate -expand -group DUT -radix hexadecimal /testbench/DUT/XTX
add wave -noupdate -expand -group DUT /testbench/DUT/clk
add wave -noupdate -expand -group DUT /testbench/DUT/reset
add wave -noupdate -expand -group DUT /testbench/DUT/clk_pmod
add wave -noupdate -expand -group DUT /testbench/DUT/reset_pmod
add wave -noupdate -expand -group DUT /testbench/DUT/reset_n
add wave -noupdate -expand -group DUT /testbench/DUT/rx_busy
add wave -noupdate -expand -group DUT /testbench/DUT/rx_busy_falling
add wave -noupdate -expand -group DUT /testbench/DUT/rx_busy_rising
add wave -noupdate -expand -group DUT /testbench/DUT/uart_request
add wave -noupdate -expand -group DUT /testbench/DUT/uart_grant
add wave -noupdate -expand -group DUT /testbench/DUT/rx_error
add wave -noupdate -expand -group DUT /testbench/DUT/tx_start
add wave -noupdate -group TEST /testbench/test/XSCLK
add wave -noupdate -group TEST /testbench/test/XSS_N
add wave -noupdate -group TEST /testbench/test/XMISO
add wave -noupdate -group TEST /testbench/test/XMOSI
add wave -noupdate -group TEST /testbench/test/int1
add wave -noupdate -group TEST /testbench/test/int2
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
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/clk_in
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_in
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/clk_out
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/locked
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_out
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/reset_counter
add wave -noupdate -group {SYS CON} -radix hexadecimal /testbench/DUT/sys_con/locked_wiz
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/slaves
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/d_width
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/clock
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/reset_n
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/enable
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/cpol
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/cpha
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/cont
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/clk_div
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/addr
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/tx_data
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/miso
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/sclk
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/ss_n
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/mosi
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/busy
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/rx_data
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/state
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/slave
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/clk_ratio
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/count
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/clk_toggles
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/assert_data
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/continue
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/rx_buffer
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/tx_buffer
add wave -noupdate -group {SPI PMOD MASTER} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_master_0/last_bit_rx
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/clk_freq
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/data_rate
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/data_range
add wave -noupdate -group {SPI PMOD} /testbench/DUT/spi_pmod_acl2/clk
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/reset_n
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/miso
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/sclk
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/ss_n
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/mosi
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_x
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_y
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_z
add wave -noupdate -group {SPI PMOD} -color White -radix hexadecimal /testbench/DUT/spi_pmod_acl2/state
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/parameter
add wave -noupdate -group {SPI PMOD} -color {Medium Orchid} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/parameter_addr
add wave -noupdate -group {SPI PMOD} -color {Medium Orchid} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/parameter_data
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_busy_prev
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_busy
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_ena
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_cont
add wave -noupdate -group {SPI PMOD} -color {Medium Orchid} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/spi_tx_data
add wave -noupdate -group {SPI PMOD} -radix hexadecimal -childformat {{/testbench/DUT/spi_pmod_acl2/spi_rx_data(7) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(6) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(5) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(4) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(3) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(2) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(1) -radix hexadecimal} {/testbench/DUT/spi_pmod_acl2/spi_rx_data(0) -radix hexadecimal}} -subitemconfig {/testbench/DUT/spi_pmod_acl2/spi_rx_data(7) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(6) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(5) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(4) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(3) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(2) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(1) {-height 16 -radix hexadecimal} /testbench/DUT/spi_pmod_acl2/spi_rx_data(0) {-height 16 -radix hexadecimal}} /testbench/DUT/spi_pmod_acl2/spi_rx_data
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_x_int
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_y_int
add wave -noupdate -group {SPI PMOD} -radix hexadecimal /testbench/DUT/spi_pmod_acl2/acceleration_z_int
add wave -noupdate -group {TB UART RX} -radix unsigned /testbench/test/receive/g_CLKS_PER_BIT
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/i_Clk
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/i_RX_Serial
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/o_RX_DV
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/o_RX_Byte
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/r_SM_Main
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/r_Clk_Count
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/r_Bit_Index
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/r_RX_Byte
add wave -noupdate -group {TB UART RX} -radix hexadecimal /testbench/test/receive/r_RX_DV
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/clk
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/clk_pmod
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/reset
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/data_ready
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_x
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_y
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_z
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_x
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_y
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_z
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_x_int
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_y_int
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/acceleration_out_z_int
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_dout
add wave -noupdate -group {Data Processing} -color Magenta -radix hexadecimal /testbench/DUT/data_processing/fifo_x_full
add wave -noupdate -group {Data Processing} -color Khaki -radix hexadecimal /testbench/DUT/data_processing/fifo_x_empty
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_wr_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_rd_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_dout
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_full
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_empty
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_wr_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_rd_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_dout
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_full
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_empty
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_wr_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_rd_busy
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/processing_x
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/processing_y
add wave -noupdate -group {Data Processing} -radix hexadecimal /testbench/DUT/data_processing/processing_z
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/rst
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/wr_clk
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/rd_clk
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/din
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/wr_en
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/rd_en
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/dout
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/full
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/empty
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/wr_rst_busy
add wave -noupdate -group {FIFO X} -radix hexadecimal /testbench/DUT/data_processing/fifo_x_accel/rd_rst_busy
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/rst
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/wr_clk
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/rd_clk
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/din
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/wr_en
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/rd_en
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/dout
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/full
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/empty
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/wr_rst_busy
add wave -noupdate -group {FIFO Y} -radix hexadecimal /testbench/DUT/data_processing/fifo_y_accel/rd_rst_busy
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/rst
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/wr_clk
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/rd_clk
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/din
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/wr_en
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/rd_en
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/dout
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/full
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/empty
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/wr_rst_busy
add wave -noupdate -group {FIFO Z} -radix hexadecimal /testbench/DUT/data_processing/fifo_z_accel/rd_rst_busy
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/clk
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/reset
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_data_ready_x
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_data_ready_y
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_data_ready_z
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/acceleration_out_x
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/acceleration_out_y
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/acceleration_out_z
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_tx_start
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_data_tx
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_tx_busy
add wave -noupdate -group {ACCEL to UART} -radix ascii /testbench/DUT/accel_to_uart/transmit_buffer
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/transmit_addr
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/state
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/next_state
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_tx_start_r
add wave -noupdate -group {ACCEL to UART} -radix hexadecimal /testbench/DUT/accel_to_uart/uart_data_tx_r
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/sys_clk_freq
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/humidity_resolution
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/temperature_resolution
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/clk
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/reset_n
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/scl
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/sda
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_ack_err
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/data_ready
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/relative_humidity
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/temperature
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/state
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_ena
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_addr
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_rw
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_data_wr
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_data_rd
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/i2c_busy
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/busy_prev
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/rh_time
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/temp_time
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/rh_res_bits
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/temp_res_bit
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/humidity_data
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/temperature_data
add wave -noupdate -group {PMOD HYGRO} -radix hexadecimal /testbench/DUT/i2c_pmod_hygro/hygrometer_addr
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/clk
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/reset
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/temperature
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/humidity
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_data_ready
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_request
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_grant
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_tx_start
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_data_tx
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_tx_busy
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/transmit_buffer
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/transmit_addr
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/state
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/next_state
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_tx_start_r
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_data_tx_r
add wave -noupdate -group {HYGRO UART} -radix hexadecimal /testbench/DUT/hygro_to_uart/uart_request_r
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/scl
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/sda
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/reg_addr
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/reg_write
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/reg_write_data
add wave -noupdate -group {HDC1080 TOP} /testbench/test/pmod1/reg_read_data
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/SLAVE_ID_ADDR
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/scl
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/sda
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/reg_addr
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/reg_write
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/reg_write_data
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/reg_read_data
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/state
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/sda_int
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/sda_prev
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/scl_prev
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/bit_count
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/data_shift
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/addr_match
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/rw_bit
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/sda_out
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/start_detected
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/sda_enable
add wave -noupdate -group {HDC1080 I2C} /testbench/test/pmod1/i2c_slave/i2c_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {480896100000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 327
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
WaveRestoreZoom {0 fs} {2466752400 ps}
