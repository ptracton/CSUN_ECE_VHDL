-------------------------------------------------------------------------------
-- Title      : VHDL GPIO TEST BENCH
-- Project    :
-------------------------------------------------------------------------------
-- File       : testbench.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-27
-- Last update: 2023-09-01
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
use ieee.numeric_std.all;               -- needed for shifting

--library xil_defaultlib;
--use xil_defaultlib.board_pkg.all;
use work.board_pkg.all;

entity testbench is
end testbench;

architecture Behavioral of testbench is
  component top is
    generic (WIDTH : integer := 8);
    port(
      XLEDS     : inout std_logic_vector(WIDTH-1 downto 0);
      XSWITCHES : inout std_logic_vector(WIDTH-1 downto 0)
      );
  end component;

  component test_case is
    generic (WIDTH : integer := 8);
    port(
      XLEDS     : in  std_logic_vector(WIDTH-1 downto 0);
      XSWITCHES : out std_logic_vector(WIDTH-1 downto 0)
      );
  end component;

  signal XLEDS     : std_logic_vector(WIDTH-1 downto 0);
  signal XSWITCHES : std_logic_vector(WIDTH-1 downto 0);

begin

  -- This is our Device Under Test (DUT)
  -- This is the FPGA image that will be synthesized and downloaded
  DUT : top
    generic map (WIDTH => WIDTH)
    port map (
      XLEDS     => XLEDS,
      XSWITCHES => XSWITCHES
      );

  -- This is our test case.  By simulation we can choose different modules
  -- that create this module and therefore run different test cases
  test : test_case
    generic map (WIDTH => WIDTH)
    port map(
      XLEDS     => XLEDS,
      XSWITCHES => XSWITCHES
      );
  process is
  begin
    report "TB WIDTH " & integer'image(WIDTH);
    wait;
  end process;

end Behavioral;
