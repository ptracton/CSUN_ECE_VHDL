-------------------------------------------------------------------------------
-- Title      : BASIC Packet Communications
-- Project    : 
-------------------------------------------------------------------------------
-- File       : basic_packet_coms.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-12-15
-- Last update: 2024-12-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-12-15  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.board_pkg.all;

entity basic_packet_coms is
  generic (WIDTH : integer := WIDTH);
  port (
    XCLK      : in    std_logic;
    XRESET    : in    std_logic;
    XLOCKED   : out   std_logic;
    XRX       : in    std_logic;
    XTX       : out   std_logic;
    XLEDS     : inout std_logic_vector(WIDTH - 1 downto 0);
    XSWITCHES : inout std_logic_vector(WIDTH - 1 downto 0)
    );
end basic_packet_coms;

architecture rtl of basic_packet_coms is
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

  component blk_mem_gen_0
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(8 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      clkb  : in  std_logic;
      enb   : in  std_logic;
      addrb : in  std_logic_vector(8 downto 0);
      doutb : out std_logic_vector(7 downto 0)
      );
  end component;

  component bytes_to_packet is
    port(
      -- System Interface
      clk   : in std_logic;
      reset : in std_logic;

      -- UART Interface
      byte_valid   : in std_logic;
      uart_data_rx : in std_logic_vector(7 downto 0);

      -- BRAM Interface
      ena   : out std_logic;
      wea   : out std_logic_vector(0 downto 0);
      addra : out std_logic_vector(8 downto 0);
      dina  : out std_logic_vector(7 downto 0);

      -- Processing Interface
      packet_valid : out std_logic;
      packet_error : out std_logic
      );
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

  -- RX Packet memory
  signal rx_ena   : std_logic;
  signal rx_wea   : std_logic_vector(0 downto 0);
  signal rx_addra : std_logic_vector(8 downto 0);
  signal rx_dina  : std_logic_vector(7 downto 0);
  signal rx_enb   : std_logic;
  signal rx_addrb : std_logic_vector(8 downto 0);
  signal rx_doutb : std_logic_vector(7 downto 0);

begin
  ------------------------------------------------------------------------------
  -- System clock and reset controller
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
  -- Memory to hold the incoming packet from the PC
  ------------------------------------------------------------------------------
  rx_packet : blk_mem_gen_0
    port map (
      clka  => clk,
      ena   => rx_ena,
      wea   => rx_wea,
      addra => rx_addra,
      dina  => rx_dina,
      clkb  => clk,
      enb   => rx_enb,
      addrb => rx_addrb,
      doutb => rx_doutb
      );

  ------------------------------------------------------------------------------
  -- FSM to take data from UART and create packet in BRAM
  ------------------------------------------------------------------------------  
  packet_rx : bytes_to_packet
    port map(
      clk          => clk,
      reset        => reset,
      byte_valid   => rx_busy_falling,
      uart_data_rx => uart_data_rx,
      ena          => rx_ena,
      wea          => rx_wea,
      addra        => rx_addra,
      dina         => rx_dina
      );

end rtl;
