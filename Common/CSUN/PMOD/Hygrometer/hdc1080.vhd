-------------------------------------------------------------------------------
-- Title      : HDC1080 IC
-- Project    : 
-------------------------------------------------------------------------------
-- File       : hdc1080.vhd
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.hdc1080_pkg.all;

entity hdc1080 is
  port (
    scl : in    std_logic;
    sda : inout std_logic
    );
end entity hdc1080;

architecture rtl of hdc1080 is

  component hdc1080_i2c is
    generic (
      SLAVE_ID_ADDR : std_logic_vector(6 downto 0)
      );
    port (
      --I2C Interface
      scl : in    std_logic;
      sda : inout std_logic;

      -- System Interface
      reg_addr       : out std_logic_vector(7 downto 0);
      reg_write      : out std_logic;
      reg_write_data : out std_logic_vector(15 downto 0);
      reg_read_data  : in  std_logic_vector(15 downto 0)

      );
  end component;

  -- System Interface
  signal reg_addr       : std_logic_vector(7 downto 0);
  signal reg_write      : std_logic;
  signal reg_write_data : std_logic_vector(15 downto 0);
  signal reg_read_data  : std_logic_vector(15 downto 0);

begin

  i2c_slave : hdc1080_i2c
    generic map(SLAVE_ID_ADDR => c_HDC1080_I2C_ADDR)
    port map(
      --I2C Interface
      scl => scl,
      sda => sda,

      --System Interface
      reg_addr       => reg_addr,
      reg_write      => reg_write,
      reg_write_data => reg_write_data,
      reg_read_data  => reg_read_data
      );

end architecture rtl;
