-------------------------------------------------------------------------------
-- Title      : ADXL362 Accelerometer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adxl362_accelerometer.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-27
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
-- 2024-10-27  1.0      ptracton        Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.adxl362_pkg.all;

entity adxl362_accelerometer is
  port (
    -- System Interface
    clk         : in std_logic;
    reset       : in std_logic;
    clk_51p2KHz : in std_logic;

    -- bus interface
    address  : in std_logic_vector(5 downto 0);
    read_sig : in std_logic;

    -- data
    xdata       : out std_logic_vector(11 downto 0);
    ydata       : out std_logic_vector(11 downto 0);
    zdata       : out std_logic_vector(11 downto 0);
    temperature : out std_logic_vector(11 downto 0)
    );

end adxl362_accelerometer;

architecture behavioral of adxl362_accelerometer is
begin

  xdata_process : process(clk, reset)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        xdata <= x"123";
      else
        if (read_sig = '1') and ("00"&address = c_ADXL362_XDATA_LOW) then
          xdata <= std_logic_vector(unsigned(xdata) + 1);
        end if;
      end if;
    end if;
  end process;

  ydata_process : process(clk, reset)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ydata <= x"456";
      else
        if (read_sig = '1') and ("00"&address = c_ADXL362_YDATA_LOW) then
          ydata <= std_logic_vector(unsigned(ydata) + 1);
        end if;
      end if;
    end if;
  end process;

  zdata_process : process(clk, reset)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        zdata <= x"789";
      else
        if (read_sig = '1') and ("00"&address = c_ADXL362_ZDATA_LOW) then
          zdata <= std_logic_vector(unsigned(zdata) + 1);
        end if;
      end if;
    end if;
  end process;
  
  temperature <= x"ABC";

end architecture;
