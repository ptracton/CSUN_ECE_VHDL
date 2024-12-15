-------------------------------------------------------------------------------
-- Title      : CSUN ECE 420 Lab 8 Testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : testbench.vhd<lab_8.srcs>
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2024-01-14
-- Last update: 2024-11-21
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
use std.env.finish;
use ieee.numeric_std.all;

use work.board_pkg.all;

entity testbench is
end testbench;

architecture Behavioral of testbench is

-- This is our Device Under Test (DUT)
  component top
    port (
      -- System Interface
      XCLK    : in     std_logic;
      XRESET  : in     std_logic;
      XLOCKED : out    std_logic;
      -- UART Interface
      XRX     : in     std_logic;
      XTX     : out    std_logic;
      -- SPI Interface
      XSCLK   : buffer std_logic;
      XSS_N   : buffer std_logic_vector(0 downto 0);
      XMISO   : in     std_logic;
      XMOSI   : out    std_logic;

      --I2C Interface
      XSCL : inout std_logic;
      XSDA : inout std_logic
      );

  end component;

  component test_case is
    port(
      -- System Interface
      XCLK    : in  std_logic;
      XRESET  : in  std_logic;
      XLOCKED : in  std_logic;
      -- UART Interface
      XRX     : in  std_logic;
      XTX     : out std_logic;
      -- SPI Interface
      XSCLK   : in  std_logic;
      XSS_N   : in  std_logic_vector(0 downto 0);
      XMISO   : out std_logic;
      XMOSI   : in  std_logic;

      --I2C Interface
      XSCL : in    std_logic;
      XSDA : inout std_logic
      );
  end component;

  -- https://stackoverflow.com/questions/17904514/vhdl-how-should-i-create-a-clock-in-a-testbench
  -- Procedure for clock generation
  procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity failure;
    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

  signal clk    : std_logic;
  signal reset  : std_logic;
  signal locked : std_logic;
  signal tx     : std_logic;
  signal rx     : std_logic;

  signal sclk : std_logic;
  signal ss_n : std_logic_vector(0 downto 0);

  signal sclk_buffer : std_logic;
  signal ss_n_buffer : std_logic_vector(0 downto 0);

  signal miso : std_logic;
  signal mosi : std_logic;

  signal scl  : std_logic;
  signal XSCL : std_logic;
  signal XSDA : std_logic;
begin

  -- generate the free running 125 MHz clock from the Zybo board
  clk_gen(clk, BOARD_TB_CLK_SPEED);

  -- generate a reset pulse to put the DUT into the correct state
  tb_reset : process
  begin
    reset <= '0';
    wait for 200 ns;
    report "RESET ASSERTED";
    reset <= '1';

    wait for 200 ns;
    reset <= '0';
    report "RESET RELEASED";

    -- don't do anything else
    wait;
  end process;


  DUT : top
    port map (
      XCLK    => clk,
      XRESET  => reset,
      XLOCKED => locked,
      XRX     => rx,
      XTX     => tx,
      XSCLK   => sclk_buffer,
      XSS_N   => ss_n_buffer,
      XMISO   => miso,
      XMOSI   => mosi,
      XSCL    => XSCL,
      XSDA    => XSDA
      );

  sclk <= sclk_buffer;
  ss_n <= ss_n_buffer;

  -- pullup resistor
  scl <= '1' when XSCL = 'Z' else '0';
  test : test_case
    port map(
      XCLK    => clk,
      XRESET  => reset,
      XLOCKED => locked,
      XRX     => tx,
      XTX     => rx,
      XSCLK   => sclk,
      XSS_N   => ss_n,
      XMISO   => miso,
      XMOSI   => mosi,
      XSCL    => scl,
      XSDA    => XSDA
      );


end Behavioral;
