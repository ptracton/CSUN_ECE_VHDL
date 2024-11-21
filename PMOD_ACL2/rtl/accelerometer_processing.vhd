-------------------------------------------------------------------------------
-- Title      : Accelerometer Processing
-- Project    :
-------------------------------------------------------------------------------
-- File       : accelerometer_processing.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    :
-- Created    : 2024-11-18
-- Last update: 2024-11-20
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2024
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-11-18  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity accelerometer_processing is
  port (
    -- System Interface
    clk      : in std_logic;
    clk_pmod : in std_logic;
    reset    : in std_logic;

    -- Accelerometer Signals
    data_ready     : in std_logic;
    acceleration_x : in std_logic_vector(11 downto 0);
    acceleration_y : in std_logic_vector(11 downto 0);
    acceleration_z : in std_logic_vector(11 downto 0);

    -- Data out
    uart_data_ready_x  : out std_logic;
    uart_data_ready_y  : out std_logic;
    uart_data_ready_z  : out std_logic;
    acceleration_out_x : out std_logic_vector(11 downto 0);
    acceleration_out_y : out std_logic_vector(11 downto 0);
    acceleration_out_z : out std_logic_vector(11 downto 0));
end accelerometer_processing;

architecture Behavioral of accelerometer_processing is
  component fifo_generator_0
    port (
      rst           : in  std_logic;
      wr_clk        : in  std_logic;
      rd_clk        : in  std_logic;
      din           : in  std_logic_vector(11 downto 0);
      wr_en         : in  std_logic;
      rd_en         : in  std_logic;
      dout          : out std_logic_vector(11 downto 0);
      full          : out std_logic;
      empty         : out std_logic;
      rd_data_count : out std_logic_vector(4 downto 0);
      wr_data_count : out std_logic_vector(4 downto 0);
      wr_rst_busy   : out std_logic;
      rd_rst_busy   : out std_logic
      );
  end component;

  component edge_detector is
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      data_in : in  std_logic;
      rising  : out std_logic;
      falling : out std_logic
      );
  end component;

  --FIFO Signals
  signal fifo_x_dout          : std_logic_vector(11 downto 0);  --x-axis acceleration data
  signal fifo_x_full          : std_logic;
  signal fifo_x_empty         : std_logic;
  signal fifo_x_wr_busy       : std_logic;
  signal fifo_x_rd_busy       : std_logic;
  signal fifo_x_rd_data_count : std_logic_vector(4 downto 0);
  signal fifo_x_wr_data_count : std_logic_vector(4 downto 0);


  signal fifo_y_dout          : std_logic_vector(11 downto 0);  --x-axis acceleration data
  signal fifo_y_full          : std_logic;
  signal fifo_y_empty         : std_logic;
  signal fifo_y_wr_busy       : std_logic;
  signal fifo_y_rd_busy       : std_logic;
  signal fifo_y_rd_data_count : std_logic_vector(4 downto 0);
  signal fifo_y_wr_data_count : std_logic_vector(4 downto 0);

  signal fifo_z_dout          : std_logic_vector(11 downto 0);  --x-axis acceleration data
  signal fifo_z_full          : std_logic;
  signal fifo_z_empty         : std_logic;
  signal fifo_z_wr_busy       : std_logic;
  signal fifo_z_rd_busy       : std_logic;
  signal fifo_z_rd_data_count : std_logic_vector(4 downto 0);
  signal fifo_z_wr_data_count : std_logic_vector(4 downto 0);

  signal processing_x : std_logic;
  signal processing_y : std_logic;
  signal processing_z : std_logic;

  signal processing_x_rising : std_logic;
  signal processing_y_rising : std_logic;
  signal processing_z_rising : std_logic;

  signal processing_x_falling : std_logic;
  signal processing_y_falling : std_logic;
  signal processing_z_falling : std_logic;


  signal acceleration_out_x_int : std_logic_vector(11 downto 0);
  signal acceleration_out_y_int : std_logic_vector(11 downto 0);
  signal acceleration_out_z_int : std_logic_vector(11 downto 0);

  signal fifo_x_full_rising   : std_logic;
  signal fifo_x_full_falling  : std_logic;
  signal fifo_x_empty_rising  : std_logic;
  signal fifo_x_empty_falling : std_logic;

  signal fifo_y_full_rising   : std_logic;
  signal fifo_y_full_falling  : std_logic;
  signal fifo_y_empty_rising  : std_logic;
  signal fifo_y_empty_falling : std_logic;

  signal fifo_z_full_rising   : std_logic;
  signal fifo_z_full_falling  : std_logic;
  signal fifo_z_empty_rising  : std_logic;
  signal fifo_z_empty_falling : std_logic;

begin
  fifo_x_accel : fifo_generator_0
    port map (
      rst           => reset,
      wr_clk        => clk_pmod,
      rd_clk        => clk,
      din           => acceleration_x,
      wr_en         => data_ready,
      rd_en         => processing_x,
      dout          => fifo_x_dout,
      full          => fifo_x_full,
      empty         => fifo_x_empty,
      rd_data_count => fifo_x_rd_data_count,
      wr_data_count => fifo_x_wr_data_count,
      wr_rst_busy   => fifo_x_wr_busy,
      rd_rst_busy   => fifo_x_rd_busy
      );

  fifo_y_accel : fifo_generator_0
    port map (
      rst           => reset,
      wr_clk        => clk_pmod,
      rd_clk        => clk,
      din           => acceleration_y,
      wr_en         => data_ready,
      rd_en         => processing_y,
      dout          => fifo_y_dout,
      full          => fifo_y_full,
      empty         => fifo_y_empty,
      rd_data_count => fifo_y_rd_data_count,
      wr_data_count => fifo_y_wr_data_count,
      wr_rst_busy   => fifo_y_wr_busy,
      rd_rst_busy   => fifo_y_rd_busy
      );

  fifo_z_accel : fifo_generator_0
    port map (
      rst           => reset,
      wr_clk        => clk_pmod,
      rd_clk        => clk,
      din           => acceleration_z,
      wr_en         => data_ready,
      rd_en         => processing_z,
      dout          => fifo_z_dout,
      full          => fifo_z_full,
      empty         => fifo_z_empty,
      rd_data_count => fifo_z_rd_data_count,
      wr_data_count => fifo_z_wr_data_count,
      wr_rst_busy   => fifo_z_wr_busy,
      rd_rst_busy   => fifo_z_rd_busy
      );


  fifo_x_full_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_x_full,
      rising  => fifo_x_full_rising,
      falling => fifo_x_full_falling
      );

  fifo_x_empty_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_x_empty,
      rising  => fifo_x_empty_rising,
      falling => fifo_x_empty_falling
      );

  proc_x : process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        processing_x <= '0';
      else
        if (fifo_x_full_rising = '1') then
          processing_x <= '1';
        end if;
        if (fifo_x_empty_rising = '1') then
          processing_x <= '0';
        end if;
      end if;
    end if;
  end process;


  fifo_x_processing_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => processing_x,
      rising  => processing_x_rising,
      falling => processing_x_falling
      );

  accel_x_data : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acceleration_out_x_int <= (others => '0');
        uart_data_ready_x      <= '0';
      else
        if (fifo_x_full_rising = '1') then
          acceleration_out_x_int <= (others => '0');
        end if;
        if (processing_x = '1') then
          acceleration_out_x_int <= std_logic_vector(signed(acceleration_out_x_int) + signed(fifo_x_dout));
        end if;
        if (processing_x_falling = '1') then
          -- Divide by 16 since we have that many samples
          acceleration_out_x <= "0000" & acceleration_out_x_int(11 downto 4);
          uart_data_ready_x  <= '1';
        else
          uart_data_ready_x <= '0';
        end if;
      end if;
    end if;
  end process;


  fifo_y_full_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_y_full,
      rising  => fifo_y_full_rising,
      falling => fifo_y_full_falling
      );

  fifo_y_empty_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_y_empty,
      rising  => fifo_y_empty_rising,
      falling => fifo_y_empty_falling
      );
  proc_y : process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        processing_y <= '0';
      else
        if (fifo_y_full_rising = '1') then
          processing_y <= '1';
        end if;
        if (fifo_y_empty_rising = '1') then
          processing_y <= '0';
        end if;
      end if;
    end if;
  end process;

  fifo_y_processing_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => processing_y,
      rising  => processing_y_rising,
      falling => processing_y_falling
      );

  accel_y_data : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acceleration_out_y_int <= (others => '0');
        uart_data_ready_y      <= '0';
      else
        if (fifo_y_full_rising = '1') then
          acceleration_out_y_int <= (others => '0');
        end if;
        if (processing_y = '1') then
          acceleration_out_y_int <= std_logic_vector(signed(acceleration_out_y_int) + signed(fifo_y_dout));
        end if;
        if (processing_y_falling = '1') then
          -- Divide by 16 since we have that many samples
          acceleration_out_y <= "0000" & acceleration_out_y_int(11 downto 4);
          uart_data_ready_y  <= '1';
        else
          uart_data_ready_y <= '0';
        end if;
      end if;
    end if;
  end process;



  fifo_z_full_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_z_full,
      rising  => fifo_z_full_rising,
      falling => fifo_z_full_falling
      );

  fifo_z_empty_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => fifo_z_empty,
      rising  => fifo_z_empty_rising,
      falling => fifo_z_empty_falling
      );

  proc_z : process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        processing_z <= '0';
      else
        if (fifo_z_full_rising = '1') then
          processing_z <= '1';
        end if;
        if (fifo_z_empty_rising = '1') then
          processing_z <= '0';
        end if;
      end if;
    end if;
  end process;

  fifo_z_processing_edge : edge_detector
    port map(
      clk     => clk,
      reset   => reset,
      data_in => processing_z,
      rising  => processing_z_rising,
      falling => processing_z_falling
      );

  accel_z_data : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acceleration_out_z_int <= (others => '0');
        uart_data_ready_z      <= '0';
      else
        if (fifo_z_full_rising = '1') then
          acceleration_out_z_int <= (others => '0');
        end if;
        if (processing_z = '1') then
          acceleration_out_z_int <= std_logic_vector(signed(acceleration_out_z_int) + signed(fifo_z_dout));
        end if;
        if (processing_z_falling = '1') then
          -- Divide by 16 since we have that many samples
          acceleration_out_z <= "0000" & acceleration_out_z_int(11 downto 4);
          uart_data_ready_z  <= '1';
        else
          uart_data_ready_z <= '0';
        end if;
      end if;
    end if;
  end process;

end Behavioral;
