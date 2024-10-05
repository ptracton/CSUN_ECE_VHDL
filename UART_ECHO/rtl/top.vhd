-------------------------------------------------------------------------------
-- Title      : UART ECHO
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top.vhd<rtl>
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-05
-- Last update: 2024-10-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-10-05  1.0      ptracton	Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity uart_echo is
  port (XCLK   : in  std_logic;
        XRESET : in  std_logic;
        XRX    : in  std_logic;
        XTX    : out std_logic
        );
end uart_echo;

architecture Behavioral of uart_echo is

  component UART is
    port(
      clk      : in std_logic;
      reset    : in std_logic;
      tx_start : in std_logic;

      data_in       : in  std_logic_vector (7 downto 0);
      data_out      : out std_logic_vector (7 downto 0);
      rx_data_ready : out std_logic;

      rx : in  std_logic;
      tx : out std_logic
      );
  end component;

  signal tx_start      : std_logic;
  signal uart_data_rx  : std_logic_vector(7 downto 0);
  signal uart_data_tx  : std_logic_vector(7 downto 0);
  signal rx_data_ready : std_logic;

begin

  --
  -- Taken from https://github.com/AlexHDL/UART_controller
  --
  uart_inst : UART
    port map (
      clk           => XCLK,
      reset         => XRESET,
      tx_start      => tx_start,
      data_in       => uart_data_tx,
      data_out      => uart_data_rx,
      rx_data_ready => rx_data_ready,
      rx            => XRX,
      tx            => XTX
      );


  --
  -- Catch received byte and transmit it back to user
  --
  echo : process (XCLK)
  begin
    if rising_edge(XCLK) then
      if (XRESET = '1') then
        tx_start     <= '0';
        uart_data_tx <= x"00";
      elsif rx_data_ready = '1' then
        tx_start     <= '1';
        uart_data_tx <= uart_data_rx;
      else
        tx_start <= '0';
      end if;
    end if;
  end process;

end Behavioral;
