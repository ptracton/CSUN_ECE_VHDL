-------------------------------------------------------------------------------
-- Title      : UART ECHO
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top.vhd<rtl>
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-05
-- Last update: 2024-10-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-10-05  1.0      ptracton        Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.board_pkg.all;

entity top is
  port (
    -- System Interface
    XCLK    : in  std_logic;
    XRESET  : in  std_logic;
    XLOCKED : out std_logic;

    --UART Interface
    XRX : in  std_logic;
    XTX : out std_logic;

    -- SPI Interface
    XSCLK : buffer std_logic;
    XSS_N : buffer std_logic_vector(0 downto 0);
    XMISO : in     std_logic;
    XMOSI : out    std_logic
    );
end top;

architecture Behavioral of top is

  component uart is
    generic(
      clk_freq  : integer   := 50_000_000;  --frequency of system clock in Hertz
      baud_rate : integer   := 19_200;  --data link baud rate in bits/second
      os_rate   : integer   := 16;  --oversampling rate to find center of receive bits (in samples per baud period)
      d_width   : integer   := 8;       --data bus width
      parity    : integer   := 1;       --0 for no parity, 1 for parity
      parity_eo : std_logic := '0');    --'0' for even, '1' for odd parity
    port(
      clk      : in  std_logic;         --system clock
      reset_n  : in  std_logic;         --ascynchronous reset
      tx_ena   : in  std_logic;         --initiate transmission
      tx_data  : in  std_logic_vector(d_width-1 downto 0);  --data to transmit
      rx       : in  std_logic;         --receive pin
      rx_busy  : out std_logic;         --data reception in progress
      rx_error : out std_logic;     --start, parity, or stop bit error detected
      rx_data  : out std_logic_vector(d_width-1 downto 0);  --data received
      tx_busy  : out std_logic;         --transmission in progress
      tx       : out std_logic);        --transmit pin
  end component;

  component system_controller is
    generic (RESET_COUNT : integer := 32);
    port(
      clk_in    : in  std_logic;
      reset_in  : in  std_logic;
      clk_out   : out std_logic;
      locked    : out std_logic;
      reset_out : out std_logic
      );
  end component;

  component edge_detector is
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      data_in : in  std_logic;
      rising  : out std_logic;
      falling : out std_logic
      );
  end component;

  component pmod_accelerometer_adxl362 is
    generic(
      clk_freq   : integer          := 50;     --system clock frequency in MHz
      data_rate  : std_logic_vector := "011";  --data rate code to configure the accelerometer
      data_range : std_logic_vector := "00");  --data range code to configure the accelerometer
    port(
      clk            : in     std_logic;       --system clock
      reset_n        : in     std_logic;       --active low asynchronous reset
      miso           : in     std_logic;       --SPI bus: master in, slave out
      sclk           : buffer std_logic;       --SPI bus: serial clock
      ss_n           : buffer std_logic_vector(0 downto 0);  --SPI bus: slave select
      mosi           : out    std_logic;       --SPI bus: master out, slave in
      acceleration_x : out    std_logic_vector(11 downto 0);  --x-axis acceleration data
      acceleration_y : out    std_logic_vector(11 downto 0);  --y-axis acceleration data
      acceleration_z : out    std_logic_vector(11 downto 0));  --z-axis acceleration data
  end component;

  -- UART Signals
  signal tx_start        : std_logic;
  signal uart_data_rx    : std_logic_vector(7 downto 0);
  signal uart_data_tx    : std_logic_vector(7 downto 0);
  signal rx_busy         : std_logic;
  signal rx_error        : std_logic;
  signal rx_busy_rising  : std_logic;
  signal rx_busy_falling : std_logic;

  -- System Signals
  signal clk     : std_logic;
  signal reset   : std_logic;
  signal reset_n : std_logic;

  --SPI Signals
  signal acceleration_x : std_logic_vector(11 downto 0);  --x-axis acceleration data
  signal acceleration_y : std_logic_vector(11 downto 0);  --y-axis acceleration data
  signal acceleration_z : std_logic_vector(11 downto 0);  --z-axis acceleration data
begin

  ------------------------------------------------------------------------------
  --
  -- System Controller cleans up the clock and reset signals from the board
  --
  ------------------------------------------------------------------------------
  sys_con : system_controller
    port map(
      clk_in    => XCLK,
      reset_in  => XRESET,
      clk_out   => clk,
      reset_out => reset,
      locked    => XLOCKED
      );

  -- Inverted reset for the UART module
  reset_n <= not reset;

  ------------------------------------------------------------------------------
  -- Taken from DigiKey
  ------------------------------------------------------------------------------
  uart_inst : UART
    generic map(
      clk_freq  => BOARD_ROOT_CLK_SPEED,
      baud_rate => BOARD_BAUD_RATE,
      parity    => 0
      )
    port map (
      clk      => clk,
      reset_n  => reset_n,
      tx_ena   => tx_start,
      tx_data  => uart_data_tx,
      rx_data  => uart_data_rx,
      rx_error => rx_error,
      rx_busy  => rx_busy,
      rx       => XRX,
      tx       => XTX
      );

  ------------------------------------------------------------------------------
  -- Detect the falling edge of rx_busy to indicate it has finished receiving a
  -- letter
  ------------------------------------------------------------------------------
  edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => rx_busy,
      rising  => rx_busy_rising,
      falling => rx_busy_falling
      );

  ------------------------------------------------------------------------------
  -- Catch received byte and transmit it back to user
  ------------------------------------------------------------------------------
  echo : process (clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        tx_start     <= '0';
        uart_data_tx <= x"00";
      elsif rx_busy_falling = '1' then
        tx_start     <= '1';
        uart_data_tx <= uart_data_rx;
      else
        tx_start <= '0';
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Taken from DigiKey
  ------------------------------------------------------------------------------
  spi_pmod_acl2 : pmod_accelerometer_adxl362
    generic map(
      clk_freq => 125
      )
    port map(
      clk            => clk,
      reset_n        => reset_n,
      miso           => XMISO,
      sclk           => XSCLK,
      ss_n           => XSS_N,
      mosi           => XMOSI,
      acceleration_x => acceleration_x,
      acceleration_y => acceleration_y,
      acceleration_z => acceleration_z
      );

end Behavioral;