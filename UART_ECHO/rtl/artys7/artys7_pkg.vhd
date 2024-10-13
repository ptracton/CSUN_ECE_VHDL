-------------------------------------------------------------------------------
-- Title      : Zybo Z7010 Board Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : zybo_pkg.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2023-08-31
-- Last update: 2024-10-12
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2023 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2023-08-31  1.0      ptracton        Created
-------------------------------------------------------------------------------

package board_pkg is

  -- This is for the Arty S7 which has 4 switches and LEDs
  constant WIDTH                 : integer := 4;
  constant BOARD_ROOT_CLK_SPEED  : integer := 100_000_000;
  constant BOARD_TB_CLK_SPEED    : real    := 100.0e6;
  constant BOARD_TB_CLKS_PER_BIT : integer := 868;
  constant BOARD_BAUD_RATE       : integer := 115200;
end package;

