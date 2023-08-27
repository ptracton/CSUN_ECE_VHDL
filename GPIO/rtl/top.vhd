-------------------------------------------------------------------------------
-- Title      : GPIO Testing
-- Project    :
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-18
-- Last update: 2023-08-27
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2023 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2023-08-18  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is
  port(
    XLEDS     : inout std_logic_vector(15 downto 0);
    XSWITCHES : inout std_logic_vector(15 downto 0)
    );
end top;


architecture rtl of top is
  component gpio is
    generic (
      WIDTH : integer);
    port (
      oe    : in    std_logic_vector(WIDTH-1 downto 0);
      inp   : in    std_logic_vector(WIDTH-1 downto 0);
      outp  : out   std_logic_vector(WIDTH-1 downto 0);
      bidir : inout std_logic_vector(WIDTH-1 downto 0)
      );
  end component;

  signal gpio_bus : std_logic_vector(15 downto 0);

begin

  -- Drive the LED for the corresponding switch when it is high
  LEDS : gpio
    generic map(WIDTH => 16)
    port map(
      oe    => x"FFFF",                 -- LEDS are outputs
      inp   => gpio_bus,
      outp  => open,
      bidir => XLEDS
      );

  -- Read the state of the switches on the board
  SWITCHES : gpio
    generic map(WIDTH => 16)
    port map(
      oe    => x"0000",                 -- Switches are inputs
      inp   => x"0000",
      outp  => gpio_bus,
      bidir => XSWITCHES
      );


end rtl;
