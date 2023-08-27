-------------------------------------------------------------------------------
-- Title      : Simple test case for VHDL GPIO
-- Project    :
-------------------------------------------------------------------------------
-- File       : gpio_test.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-27
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
-- 2023-08-27  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use std.env.finish;
use ieee.numeric_std.all;               -- needed for shifting


entity test_case is
  port(
    XLEDS     : in  std_logic_vector(15 downto 0);
    XSWITCHES : out std_logic_vector(15 downto 0)
    );
end test_case;

architecture behavioral of test_case is
  signal shifting : std_logic_vector(15 downto 0) := x"0001";
begin
  test : process is
  begin

    -- all LEDS off
    XSWITCHES <= x"0000";

    wait for 1 us;

    XSWITCHES <= x"FFFF";

    wait for 1 us;

    for i in 0 to 15 loop
      XSWITCHES <= shifting;
      shifting  <= shifting(14 downto 0) & shifting(15);
      wait for 100 ns;
    end loop;

    report "TEST PASSED";
    finish;

  end process;
end behavioral;
