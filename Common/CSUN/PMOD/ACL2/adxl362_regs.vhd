-------------------------------------------------------------------------------
-- Title      : ADXL362 Registers
-- Project    :
-------------------------------------------------------------------------------
-- File       : adxl362_regs.vhd
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

use work.adxl362_pkg.all;

entity adxl362_regs is
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
end adxl362_regs;

architecture behavioral of adxl362_regs is

  signal local_address : std_logic_vector(7 downto 0);

begin

  -- Make the address decode 8 bits
  local_address <= "00" & address;

  ------------------------------------------------------------------------------
  -- Read registers
  ------------------------------------------------------------------------------
  read_proc : process(all)
  begin
    data_read <= (others => '0');
    if write_sig = '0' then
      case (local_address) is
        when c_ADXL362_DEVID_AD          => data_read <= x"AD";
        when c_ADXL362_DEVID_MST         => data_read <= x"1D";
        when c_ADXL362_PARTID            => data_read <= x"F2";
        when c_ADXL362_REVID             => data_read <= x"01";
        when c_ADXL362_XDATA             => data_read <= xdata(11 downto 4);
        when c_ADXL362_YDATA             => data_read <= ydata(11 downto 4);
        when c_ADXL362_ZDATA             => data_read <= zdata(11 downto 4);
        when c_ADXL362_STATUS            => data_read <= status(7 downto 0);
        when c_ADXL362_FIFO_ENTRIES_LOW  => data_read <= x"00";
        when c_ADXL362_FIFO_ENTRIES_HIGH => data_read <= x"00";
        when c_ADXL362_XDATA_LOW         => data_read <= xdata(7 downto 0);
        when c_ADXL362_XDATA_HIGH        => data_read <= x"0" & xdata(11 downto 8);
        when c_ADXL362_YDATA_LOW         => data_read <= ydata(7 downto 0);
        when c_ADXL362_YDATA_HIGH        => data_read <= x"0" & ydata(11 downto 8);
        when c_ADXL362_ZDATA_LOW         => data_read <= zdata(7 downto 0);
        when c_ADXL362_ZDATA_HIGH        => data_read <= x"0" & zdata(11 downto 8);
        when c_ADXL362_TEMP_LOW          => data_read <= temperature(7 downto 0);
        when c_ADXL362_TEMP_HIGH         => data_read <= x"0" & temperature(11 downto 8);
        when c_ADXL362_SOFT_RESET        => data_read <= x"00";
        when c_ADXL362_THRESH_ACT_LOW    => data_read <= threshold_active(07 downto 00);
        when c_ADXL362_THRESH_ACT_HIGH   => data_read <= "00000" & threshold_active(10 downto 08);
        when c_ADXL362_TIME_ACT          => data_read <= time_active;
        when c_ADXL362_THRESH_INACT_LOW  => data_read <= threshold_inactive(7 downto 0);
        when c_ADXL362_THRESH_INACT_HIGH => data_read <= "00000" & threshold_inactive(10 downto 8);
        when c_ADXL362_TIME_INACT_LOW    => data_read <= time_inactive(7 downto 0);
--        when c_ADXL362_TIME_INACT_HIGH   => data_read <= "00000" & time_inactive(10 downto 8);
        when c_ADXL362_FIFO_CONTROL      => data_read <= "0000" & fifo_ctrl;
        when c_ADXL362_FIFO_SAMPLES      => data_read <= fifo_samples;
        when c_ADXL362_INTMAP1           => data_read <= intmap1;
        when c_ADXL362_INTMAP2           => data_read <= intmap2;
        when c_ADXL362_FILTER_CTL        => data_read <= filter_ctrl;
        when c_ADXL362_POWER_CTL         => data_read <= power_ctrl;
        when c_ADXL362_SELF_TEST         => data_read <= "0000000" & self_test;
        when others                      => data_read <= x"00";
      end case;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Write registers
  ------------------------------------------------------------------------------
  write_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        threshold_active   <= (others => '0');
        time_active        <= (others => '0');
        threshold_inactive <= (others => '0');
        time_inactive      <= (others => '0');
        fifo_ctrl          <= (others => '0');
        fifo_samples       <= (others => '0');
        intmap1            <= (others => '0');
        intmap2            <= (others => '0');
        filter_ctrl        <= (others => '0');
        power_ctrl         <= (others => '0');
        self_test          <= '0';
      else
        if write_sig = '1' then
          case (local_address) is
            when c_ADXL362_THRESH_ACT_LOW    => threshold_active(07 downto 00)  <= data_write;
            when c_ADXL362_THRESH_ACT_HIGH   => threshold_active(10 downto 08)  <= data_write(2 downto 0);
            when c_ADXL362_TIME_ACT          => time_active                     <= data_write;
            when c_ADXL362_THRESH_INACT_LOW  => threshold_inactive(7 downto 0)  <= data_write;
            when c_ADXL362_THRESH_INACT_HIGH => threshold_inactive(10 downto 8) <= data_write(2 downto 0);
            when c_ADXL362_TIME_INACT_LOW    => time_inactive(7 downto 0)       <= data_write;
--            when c_ADXL362_TIME_INACT_HIGH   => time_inactive(10 downto 8)      <= data_write(2 downto 0);
            when c_ADXL362_FIFO_CONTROL      => fifo_ctrl                       <= data_write(3 downto 0);
            when c_ADXL362_FIFO_SAMPLES      => fifo_samples                    <= data_write;
            when c_ADXL362_INTMAP1           => intmap1                         <= data_write;
            when c_ADXL362_INTMAP2           => intmap2                         <= data_write;
            when c_ADXL362_FILTER_CTL        => filter_ctrl                     <= data_write;
            when c_ADXL362_POWER_CTL         => power_ctrl                      <= data_write;
            when c_ADXL362_SELF_TEST         => self_test                       <= data_write(0);
            when others                      => null;
          end case;
        end if;
      end if;
    end if;
  end process;


end behavioral;
