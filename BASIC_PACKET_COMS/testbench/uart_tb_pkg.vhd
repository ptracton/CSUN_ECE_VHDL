-------------------------------------------------------------------------------
-- Title      : UART TB Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tb_pkg.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-23
-- Last update: 2023-08-23
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2023 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2023-08-23  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package uart_tb_pkg is

  constant BAUD_RATE : integer := 115200;
  constant CLK_FREQ  : integer := 100e6;

  procedure transmit_8bits(signal clk     : in  std_logic;
                           signal start   : out std_logic;
                           signal tx_byte : out std_logic_vector(7 downto 0);
                           constant tx_data : in  std_logic_vector(7 downto 0));

  procedure received_8bits(signal data_ready : in  std_logic;
                           signal rx_byte    : in  std_logic_vector(7 downto 0);
                           signal rx_data    : out std_logic_vector(7 downto 0)
                           );
end uart_tb_pkg;


package body uart_tb_pkg is

  procedure received_8bits(signal data_ready : in  std_logic;
                           signal rx_byte    : in  std_logic_vector(7 downto 0);
                           signal rx_data    : out std_logic_vector(7 downto 0)
                           ) is

  begin
    wait until data_ready = '1';
    rx_data <= rx_byte;
  end procedure;


  procedure transmit_8bits(signal clk     : in  std_logic;
                           signal start   : out std_logic;
                           signal tx_byte : out std_logic_vector(7 downto 0);
                           constant tx_data : in  std_logic_vector(7 downto 0)) is
  begin

    wait until rising_edge(clk);
    start   <= '1';
    tx_byte <= tx_data;

    wait until rising_edge(clk);
    start <= '0';

  end procedure;

end uart_tb_pkg;