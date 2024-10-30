-------------------------------------------------------------------------------
-- Title      : PMOD ACL2 ADXL362 Behavioral Model
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adxl362.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-24
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
-- 2024-10-24  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.adxl362_pkg.all;

entity adxl362 is
  generic(
    accel_x_file : string := "accel_x.txt";
    accel_y_file : string := "accel_y.txt";
    accel_z_file : string := "accel_z.txt";
    temp_file    : string := "temperature.txt"
    );
  port (
    SCLK : in     std_logic;
    nCS  : in     std_logic;
    MOSI : in     std_logic;
    MISO : out    std_logic;
    INT1 : out    std_logic;
    INT2 : out    std_logic
    );
end adxl362;

architecture behavioral of adxl362 is

  component adxl362_system_controller is
    port (
      clk_51p2KHz : out std_logic;
      clk_sys     : out std_logic;
      reset       : out std_logic
      );
  end component;

  component adxl362_spi is
    port (
      -- System Interface
      clk   : in std_logic;
      reset : in std_logic;

      -- SPI Interface
      sclk : in  std_logic;
      nss  : in  std_logic;
      mosi : in  std_logic;
      miso : out std_logic;

      -- bus interface
      address         : out std_logic_vector(5 downto 0);
      data_write      : out std_logic_vector(7 downto 0);
      data_read       : in  std_logic_vector(7 downto 0);
      write_sig       : out std_logic;
      data_fifo_write : out std_logic;
      read_data_fifo  : out std_logic;
      data_fifo_read  : out std_logic_vector(15 downto 0)
      );
  end component;

  component adxl362_regs is
    port (
      -- System Interface
      clk   : in std_logic;
      reset : in std_logic;

      -- bus Interface
      write_sig  : in  std_logic;
      address    : in  std_logic_vector(5 downto 0);
      data_write : in  std_logic_vector(7 downto 0);
      data_read  : out std_logic_vector(7 downto 0);

      -- Registers
      threshold_active   : out std_logic_vector(10 downto 0);
      time_active        : out std_logic_vector(7 downto 0);
      threshold_inactive : out std_logic_vector(10 downto 0);
      time_inactive      : out std_logic_vector(7 downto 0);
      act_inact_ctrl     : out std_logic_vector(7 downto 0);
      fifo_ctrl          : out std_logic_vector(3 downto 0);
      fifo_samples       : out std_logic_vector(7 downto 0);
      intmap1            : out std_logic_vector(7 downto 0);
      intmap2            : out std_logic_vector(7 downto 0);
      filter_ctrl        : out std_logic_vector(7 downto 0);
      power_ctrl         : out std_logic_vector(7 downto 0);
      self_test          : out std_logic;

      -- Accelerometer
      xdata       : in std_logic_vector(11 downto 0);
      ydata       : in std_logic_vector(11 downto 0);
      zdata       : in std_logic_vector(11 downto 0);
      temperature : in std_logic_vector(11 downto 0);
      status      : in std_logic_vector(11 downto 0)
      );
  end component;

  component adxl362_accelerometer is
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

  end component;

  -- System Interface
  signal clk         : std_logic;
  signal clk_51p2KHz : std_logic;
  signal reset       : std_logic;

  -- bus interface
  signal address         : std_logic_vector(5 downto 0);
  signal data_write      : std_logic_vector(7 downto 0);
  signal data_read       : std_logic_vector(7 downto 0);
  signal write_sig       : std_logic;
  signal data_fifo_write : std_logic;
  signal read_data_fifo  : std_logic;
  signal data_fifo_read  : std_logic_vector(15 downto 0);

  -- Registers
  signal threshold_active   : std_logic_vector(10 downto 0);
  signal time_active        : std_logic_vector(7 downto 0);
  signal threshold_inactive : std_logic_vector(10 downto 0);
  signal time_inactive      : std_logic_vector(7 downto 0);
  signal act_inact_ctrl     : std_logic_vector(7 downto 0);
  signal fifo_ctrl          : std_logic_vector(3 downto 0);
  signal fifo_samples       : std_logic_vector(7 downto 0);
  signal intmap1            : std_logic_vector(7 downto 0);
  signal intmap2            : std_logic_vector(7 downto 0);
  signal filter_ctrl        : std_logic_vector(7 downto 0);
  signal power_ctrl         : std_logic_vector(7 downto 0);
  signal self_test          : std_logic;


  signal xdata       : std_logic_vector(11 downto 0);
  signal ydata       : std_logic_vector(11 downto 0);
  signal zdata       : std_logic_vector(11 downto 0);
  signal temperature : std_logic_vector(11 downto 0);
  signal status      : std_logic_vector(11 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Pretend to be an on board clock and reset manager
  ------------------------------------------------------------------------------
  sys_con : adxl362_system_controller
    port map(
      clk_sys     => clk,
      clk_51p2KHz => clk_51p2KHz,
      reset       => reset
      );

  ------------------------------------------------------------------------------
  -- SPI Slave Device
  ------------------------------------------------------------------------------
  spi_slave : adxl362_spi
    port map(
      -- System Interface
      clk   => clk,
      reset => reset,

      -- SPI Interface
      sclk => SCLK,
      nss  => nCS,
      mosi => MOSI,
      miso => MISO,

      -- bus interface
      address         => address,
      data_write      => data_write,
      data_read       => data_read,
      write_sig       => write_sig,
      data_fifo_write => data_fifo_write,
      read_data_fifo  => read_data_fifo,
      data_fifo_read  => data_fifo_read
      );

  ------------------------------------------------------------------------------
  -- Registers
  ------------------------------------------------------------------------------
  registers : adxl362_regs
    port map(
      -- system interface
      clk   => clk,
      reset => reset,

      -- bus interface
      write_sig  => write_sig,
      address    => address,
      data_write => data_write,
      data_read  => data_read,

      -- registers
      threshold_active   => threshold_active,
      time_active        => time_active,
      threshold_inactive => threshold_inactive,
      time_inactive      => time_inactive,
      act_inact_ctrl     => act_inact_ctrl,
      fifo_ctrl          => fifo_ctrl,
      fifo_samples       => fifo_samples,
      intmap1            => intmap1,
      intmap2            => intmap2,
      filter_ctrl        => filter_ctrl,
      power_ctrl         => power_ctrl,
      self_test          => self_test,

      -- accelerometer
      xdata       => xdata,
      ydata       => ydata,
      zdata       => zdata,
      temperature => temperature,
      status      => status
      );

  ------------------------------------------------------------------------------
  -- Accelerometer
  ------------------------------------------------------------------------------
  accelerometer : adxl362_accelerometer
    port map(
      -- System Interface
      clk         => clk,
      reset       => reset,
      clk_51p2KHz => clk_51p2KHz,

      --data
      xdata       => xdata,
      ydata       => ydata,
      zdata       => zdata,
      temperature => temperature
      );

end behavioral;
