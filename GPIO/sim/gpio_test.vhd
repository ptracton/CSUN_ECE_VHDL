-------------------------------------------------------------------------------
-- Title      : Simple test case for VHDL GPIO
-- Project    :
-------------------------------------------------------------------------------
-- File       : gpio_test.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-27
-- Last update: 2023-08-31
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2023 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2023-08-27  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use std.env.finish;
use ieee.numeric_std.all;               -- needed for shifting

entity test_case is
  generic (
    WIDTH : integer := 8);
  port(
    XLEDS     : in  std_logic_vector(WIDTH-1 downto 0);
    XSWITCHES : out std_logic_vector(WIDTH-1 downto 0)
    );
end test_case;

architecture behavioral of test_case is
  signal shifting : std_logic_vector(WIDTH-1 downto 0) := (0 => '1', others => '0');
begin
  test : process is
  begin

    -- all LEDS off
    XSWITCHES <= (others => '0');

    wait for 1 us;

    XSWITCHES <= (others => '1');

    wait for 1 us;

    for i in 0 to WIDTH-1 loop
      XSWITCHES <= shifting;
      shifting  <= shifting(WIDTH-2 downto 0) & shifting(WIDTH-1);
      wait for 100 ns;
    end loop;

    report "TEST PASSED";
    finish;

  end process;
end behavioral;
