-------------------------------------------------------------------------------
-- Title      : ADXL362 Clock and Reset Manager
-- Project    :
-------------------------------------------------------------------------------
-- File       : adxl362_system_controller.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    :
-- Created    : 2024-10-27
-- Last update: 2024-10-27
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2024
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-10-27  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity adxl362_system_controller is
  port (
    clk_51p2KHz : out std_logic;
    clk_sys     : out std_logic;
    reset       : out std_logic
    );
end adxl362_system_controller;

architecture behavioral of adxl362_system_controller is

  constant c_CLK_SYS_PERIOD   : time := 10 ns;
  constant c_CLK_51KHZ_PERIOD : time := 976 ns;

  signal clk_sys_internal : std_logic;
  signal clk_internal     : std_logic;
begin

  ------------------------------------------------------------------------------
  -- System Clocking
  ------------------------------------------------------------------------------
  clk_sys_process : process
  begin
    clk_sys          <= '0';
    clk_sys_internal <= '0';
    wait for c_CLK_SYS_PERIOD/2;
    clk_sys          <= '1';
    clk_sys_internal <= '1';
    wait for c_CLK_SYS_PERIOD/2;
  end process;


  ------------------------------------------------------------------------------
  -- Clock at 51.2 KHz
  ------------------------------------------------------------------------------
  clk_process : process
  begin
    clk_51p2KHz  <= '0';
    clk_internal <= '0';
    wait for c_CLK_51KHZ_PERIOD/2;
    clk_51p2KHz  <= '1';
    clk_internal <= '1';
    wait for c_CLK_51KHZ_PERIOD/2;
  end process;

  ------------------------------------------------------------------------------
  -- Reset
  ------------------------------------------------------------------------------
  reset_proc : process
  begin
    reset <= '0';
    wait until rising_edge(clk_internal);
    reset <= '1';
    wait until rising_edge(clk_sys_internal);
    wait until rising_edge(clk_internal);
    reset <= '0';
    wait;
  end process;

end behavioral;
