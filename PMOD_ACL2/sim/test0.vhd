-------------------------------------------------------------------------------
-- Title      : UART ECHO Test 0
-- Project    : 
-------------------------------------------------------------------------------
-- File       : test0.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-05
-- Last update: 2024-11-17
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
    -- System Interface
    XCLK    : in     std_logic;
    XRESET  : in     std_logic;
    XLOCKED : in     std_logic;
    -- UART Interface
    XRX     : in     std_logic;
    XTX     : out    std_logic;
    -- SPI Interface
    XSCLK   : in     std_logic;
    XSS_N   : in     std_logic_vector(0 downto 0);
    XMISO   : out    std_logic;
    XMOSI   : in     std_logic
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

  component adxl362 is
    generic(
      accel_x_file : string := "accel_x.txt";
      accel_y_file : string := "accel_y.txt";
      accel_z_file : string := "accel_z.txt";
      temp_file    : string := "temperature.txt"
      );
    port (
      SCLK : in     std_logic;
      nCS  : in     std_logic;
      MOSI : in     std_logic;
      MISO : out    std_logic;
      INT1 : out    std_logic;
      INT2 : out    std_logic
      );
  end component;


  signal rx_byte : std_logic_vector(7 downto 0);
  signal rx_data : std_logic_vector(7 downto 0);
  signal rx_dv   : std_logic;

  signal test_fail : boolean   := false;
  signal test_done : boolean   := false;
  signal terminate : std_logic := '0';

  signal int1 : std_logic;
  signal int2 : std_logic;

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
      i_Clk       => XSCLK,
      i_RX_Serial => XRX,
      o_RX_DV     => rx_dv,
      o_RX_Byte   => rx_byte
      );


  pmod : adxl362
    port map(
      SCLK => XSCLK,
      nCS  => XSS_N(0),
      MOSI => XMOSI,
      MISO => XMISO,
      INT1 => int1,
      INT2 => int2
      );

  tx_test : process is
  begin
    tx_dv   <= '0';
    tx_byte <= x"00";
    wait until falling_edge(XRESET);
    wait until rising_edge(XLOCKED);
    wait for 5 us;

    transmit_8bits(XCLK, tx_dv, tx_byte, x"73");

     wait for 20 us;
    test_done <= true;
    
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
