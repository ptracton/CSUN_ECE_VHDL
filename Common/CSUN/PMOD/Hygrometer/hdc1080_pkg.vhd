-------------------------------------------------------------------------------
-- Title      : HDC1080 Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : hdc1080_pkg.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-11-21
-- Last update: 2024-11-21
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-11-21  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

-- https://www.ti.com/lit/ds/symlink/hdc1080.pdf
package hdc1080_pkg is
  constant c_HDC1080_TEMPERATURE     : std_logic_vector := x"00";
  constant c_HDC1080_HUMIDITY        : std_logic_vector := x"01";
  constant c_HDC1080_CONFIGURATION   : std_logic_vector := x"02";
  constant c_HDC1080_SERIAL_ID0      : std_logic_vector := x"FB";
  constant c_HDC1080_SERIAL_ID1      : std_logic_vector := x"FC";
  constant c_HDC1080_SERIAL_ID2      : std_logic_vector := x"FD";
  constant c_HDC1080_MANUFACTURER_ID : std_logic_vector := x"FE";
  constant c_HDC1080_DEVICE_ID       : std_logic_vector := x"FF";

  constant c_HDC1080_I2C_ADDR : std_logic_vector := "1000000";

end hdc1080_pkg;
