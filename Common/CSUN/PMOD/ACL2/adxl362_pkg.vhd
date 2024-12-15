-------------------------------------------------------------------------------
-- Title      : PMOD ACL2 ADXL362 Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adxl362_pkg.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-24
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
-- 2024-10-24  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package adxl362_pkg is
  constant c_ADXL362_DEVID_AD          : std_logic_vector := x"00";
  constant c_ADXL362_DEVID_MST         : std_logic_vector := x"01";
  constant c_ADXL362_PARTID            : std_logic_vector := x"02";
  constant c_ADXL362_REVID             : std_logic_vector := x"03";
  constant c_ADXL362_XDATA             : std_logic_vector := x"08";
  constant c_ADXL362_YDATA             : std_logic_vector := x"09";
  constant c_ADXL362_ZDATA             : std_logic_vector := x"0A";
  constant c_ADXL362_STATUS            : std_logic_vector := x"0B";
  constant c_ADXL362_FIFO_ENTRIES_LOW  : std_logic_vector := x"0C";
  constant c_ADXL362_FIFO_ENTRIES_HIGH : std_logic_vector := x"0D";
  constant c_ADXL362_XDATA_LOW         : std_logic_vector := x"0E";
  constant c_ADXL362_XDATA_HIGH        : std_logic_vector := x"0F";
  constant c_ADXL362_YDATA_LOW         : std_logic_vector := x"10";
  constant c_ADXL362_YDATA_HIGH        : std_logic_vector := x"11";
  constant c_ADXL362_ZDATA_LOW         : std_logic_vector := x"12";
  constant c_ADXL362_ZDATA_HIGH        : std_logic_vector := x"13";
  constant c_ADXL362_TEMP_LOW          : std_logic_vector := x"14";
  constant c_ADXL362_TEMP_HIGH         : std_logic_vector := x"15";
  constant c_ADXL362_SOFT_RESET        : std_logic_vector := x"1F";
  constant c_ADXL362_THRESH_ACT_LOW    : std_logic_vector := x"20";
  constant c_ADXL362_THRESH_ACT_HIGH   : std_logic_vector := x"21";
  constant c_ADXL362_TIME_ACT          : std_logic_vector := x"22";
  constant c_ADXL362_THRESH_INACT_LOW  : std_logic_vector := x"23";
  constant c_ADXL362_THRESH_INACT_HIGH : std_logic_vector := x"24";
  constant c_ADXL362_TIME_INACT_LOW    : std_logic_vector := x"25";
  constant c_ADXL362_TIME_INACT_HIGH   : std_logic_vector := x"26";
  constant c_ADXL362_ACT_INACT_CTL     : std_logic_vector := x"27";
  constant c_ADXL362_FIFO_CONTROL      : std_logic_vector := x"28";
  constant c_ADXL362_FIFO_SAMPLES      : std_logic_vector := x"29";
  constant c_ADXL362_INTMAP1           : std_logic_vector := x"2A";
  constant c_ADXL362_INTMAP2           : std_logic_vector := x"2B";
  constant c_ADXL362_FILTER_CTL        : std_logic_vector := x"2C";
  constant c_ADXL362_POWER_CTL         : std_logic_vector := x"2D";
  constant c_ADXL362_SELF_TEST         : std_logic_vector := x"2E";
  constant c_ADXL362_COMMAND_WRITE     : std_logic_vector := x"0A";
  constant c_ADXL362_COMMAND_READ      : std_logic_vector := x"0B";
  constant c_ADXL362_COMMAND_FIFO      : std_logic_vector := x"0D";


end adxl362_pkg;
