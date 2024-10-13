-------------------------------------------------------------------------------
-- Title      : UART ECHO Test 0
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_echo0.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-05
-- Last update: 2024-10-13
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
use std.env.finish;

use work.uart_tb_pkg.all;
use work.board_pkg.all;

entity test_case is
  port (
    XCLK   : in  std_logic;
    XRESET : in  std_logic;
    XRX    : in  std_logic;
    XTX    : out std_logic
    );
end test_case;

architecture behavioral of test_case is
  component UART_TX_tb
    generic (
      g_CLKS_PER_BIT : integer := 115   -- Needs to be set correctly
      );
    port (
      i_Clk       : in  std_logic;
      i_TX_DV     : in  std_logic;
      i_TX_Byte   : in  std_logic_vector(7 downto 0);
      o_TX_Active : out std_logic;
      o_TX_Serial : out std_logic;
      o_TX_Done   : out std_logic
      );
  end component;
  signal tx_byte   : std_logic_vector(7 downto 0);
  signal tx_active : std_logic;
  signal tx_done   : std_logic;
  signal tx_dv     : std_logic;

  component UART_RX_tb
    generic (
      g_CLKS_PER_BIT : integer := 115   -- Needs to be set correctly
      );
    port (
      i_Clk       : in  std_logic;
      i_RX_Serial : in  std_logic;
      o_RX_DV     : out std_logic;
      o_RX_Byte   : out std_logic_vector(7 downto 0)
      );
  end component;
  signal rx_byte : std_logic_vector(7 downto 0);
  signal rx_data : std_logic_vector(7 downto 0);
  signal rx_dv   : std_logic;
  signal phil    : std_logic_vector(7 downto 0);

  signal test_fail : boolean   := false;
  signal test_done : boolean   := false;
  signal terminate : std_logic := '0';

  
begin

    transmit : UART_TX_tb
    generic map (
      g_CLKS_PER_BIT => BOARD_TB_CLKS_PER_BIT)
    port map (
      i_Clk       => XCLK,
      i_TX_DV     => tx_dv,
      i_TX_Byte   => tx_byte,
      o_TX_Active => tx_active,
      o_TX_Serial => XTX,
      o_TX_Done   => tx_done
      );

  receive : UART_RX_tb
    generic map (
      g_CLKS_PER_BIT => BOARD_TB_CLKS_PER_BIT)
    port map (
      i_Clk       => XCLK,
      i_RX_Serial => XRX,
      o_RX_DV     => rx_dv,
      o_RX_Byte   => rx_byte
      );

  tx_test : process is
  begin
    tx_dv   <= '0';
    tx_byte <= x"00";
    wait until falling_edge(XRESET);
    wait for 5 us;

    transmit_8bits(XCLK, tx_dv, tx_byte, x"73");

    -- wait for transmission to complete
    wait until rx_dv = '1';
    -- received_8bits(rx_dv, rx_byte, rx_data);
    if rx_byte /= x"73" then
      wait for 10 us;
      test_fail <= true;
    else
      report "RECEIVED 0x73";
    end if;

    transmit_8bits(XCLK, tx_dv, tx_byte, x"A5");

    -- wait for transmission to complete
    wait until rx_dv = '1';
    --received_8bits(rx_dv, rx_byte, rx_data);
    if rx_byte /= x"A5" then
      wait for 10 us;
      test_fail <= true;
    else
      report "RECEIVED 0xA5";
    end if;


    test_done <= true;

    wait;
  end process;


  control : process (XCLK)
  begin

    if rising_edge(XCLK) then

      if test_fail = true then
        report "TEST FAILED";
        finish;
      end if;

      if test_done = true then
        report "TEST PASSED";
        finish;
      end if;

    end if;

  end process;

end behavioral;
