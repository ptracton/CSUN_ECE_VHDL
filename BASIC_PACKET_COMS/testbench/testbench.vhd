-------------------------------------------------------------------------------
-- Title      : CSUN ECE Basic Packet Coms Testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : testbench.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2024-01-14
-- Last update: 2024-12-15
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
  component basic_packet_coms
    port (XCLK      : in    std_logic;
          XRESET    : in    std_logic;
          XLOCKED   : out   std_logic;
          XRX       : in    std_logic;
          XTX       : out   std_logic;
          XLEDS     : inout std_logic_vector(WIDTH - 1 downto 0);
          XSWITCHES : inout std_logic_vector(WIDTH - 1 downto 0)
          );

  end component;

  component test_case is
    generic (
      WIDTH : integer := 8);
    port(
      XCLK      : in  std_logic;
      XRESET    : in  std_logic;
      XLOCKED   : in  std_logic;
      XRX       : in  std_logic;
      XTX       : out std_logic;
      XLEDS     : in  std_logic_vector(WIDTH-1 downto 0);
      XSWITCHES : out std_logic_vector(WIDTH-1 downto 0)
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

  signal XLEDS     : std_logic_vector(WIDTH-1 downto 0);
  signal XSWITCHES : std_logic_vector(WIDTH-1 downto 0);

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


  DUT : basic_packet_coms
    port map (
      XCLK      => clk,
      XRESET    => reset,
      XLOCKED   => locked,
      XRX       => rx,
      XTX       => tx,
      XLEDS     => XLEDS,
      XSWITCHES => XSWITCHES
      );

  test : test_case
    generic map (WIDTH => WIDTH)
    port map(
      XCLK      => clk,
      XRESET    => reset,
      XLOCKED   => locked,
      XRX       => tx,
      XTX       => rx,
      XLEDS     => XLEDS,
      XSWITCHES => XSWITCHES
      );


end Behavioral;
