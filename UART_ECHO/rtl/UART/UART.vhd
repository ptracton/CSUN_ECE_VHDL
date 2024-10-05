-------------------------------------------------------------------------------
-- Title      : CSUN ECE 420 UART Module
-- Project    : 
-------------------------------------------------------------------------------
-- File       : UART.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2024-01-14
-- Last update: 2024-01-14
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-01-14  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity UART is

  port(
    clk      : in std_logic;            -- Free running 125 MHz clock
    reset    : in std_logic;            -- Synchronous Reset
    tx_start : in std_logic;  -- assert for 1 clock to start transmitting a byte

    data_in       : in  std_logic_vector (7 downto 0);  -- data to transmit
    data_out      : out std_logic_vector (7 downto 0);  -- data received
    rx_data_ready : out std_logic;      -- data has been received

    rx : in  std_logic;
    tx : out std_logic
    );
end UART;


architecture Behavioral of UART is

  component UART_tx
    port(
      clk         : in  std_logic;
      reset       : in  std_logic;
      tx_start    : in  std_logic;
      tx_data_in  : in  std_logic_vector (7 downto 0);
      tx_data_out : out std_logic
      );
  end component;


  component UART_rx
    port(
      clk           : in  std_logic;
      reset         : in  std_logic;
      rx_data_in    : in  std_logic;
      rx_data_ready : out std_logic;
      rx_data_out   : out std_logic_vector (7 downto 0)
      );
  end component;

begin

  transmitter : UART_tx
    port map(
      clk         => clk,
      reset       => reset,
      tx_start    => tx_start,
      tx_data_in  => data_in,
      tx_data_out => tx
      );


  receiver : UART_rx
    port map(
      clk           => clk,
      reset         => reset,
      rx_data_in    => rx,
      rx_data_ready => rx_data_ready,
      rx_data_out   => data_out
      );


end Behavioral;
