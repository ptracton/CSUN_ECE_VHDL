-------------------------------------------------------------------------------
-- Title      : ADXL362 Accelerometer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adxl362_accelerometer.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-27
-- Last update: 2024-10-29
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

entity adxl362_accelerometer is
  port (
    -- System Interface
    clk         : in std_logic;
    reset       : in std_logic;
    clk_51p2KHz : in std_logic;

    -- data
    xdata       : out std_logic_vector(11 downto 0);
    ydata       : out std_logic_vector(11 downto 0);
    zdata       : out std_logic_vector(11 downto 0);
    temperature : out std_logic_vector(11 downto 0)
    );

end adxl362_accelerometer;

architecture behavioral of adxl362_accelerometer is
begin

  xdata       <= x"123";
  ydata       <= x"456";
  zdata       <= x"789";
  temperature <= x"ABC";

end architecture;
