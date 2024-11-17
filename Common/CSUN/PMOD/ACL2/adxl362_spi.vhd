-------------------------------------------------------------------------------
-- Title      : ADXL362 SPI Slave Device
-- Project    :
-------------------------------------------------------------------------------
-- File       : adxl362_spi.vhd
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

entity adxl362_spi is
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
end adxl362_spi;

architecture behavioral of adxl362_spi is

  -- SPI Signals
  signal bit_count          : integer range 0 to 7         := 0;
  signal bit_count_previous : integer range 0 to 7         := 0;
  signal spi_data_in        : std_logic_vector(7 downto 0) := x"00";
  signal spi_data_out       : std_logic_vector(7 downto 0) := x"00";

  --State Machine
  type state_type is (IDLE, wait_START_ADDRESS, READ_ADDRESS, wait_START_DATA, wait_START_READ_RESPONSE, READ_DATA, WRITE_register, WRITE_register_DONE, WRITE_INCREMENT_ADDRESS, wait_DONE_READ_RESPONSE, READ_INCREMENT_ADDRESS);
  signal state      : state_type;
  signal next_state : state_type;

  -- Internal Signals
  signal command        : std_logic_vector(7 downto 0);
  signal spi_byte_done  : boolean;
  signal spi_byte_begin : boolean;
  signal first          : std_logic;
begin

  ------------------------------------------------------------------------------
  -- Keep track of the number of bits that have been shifted in
  ------------------------------------------------------------------------------
  spi_bit_shift : process (sclk, nss)
  begin
    if nss = '1' then
      bit_count          <= 0;
      bit_count_previous <= 0;
      spi_data_in        <= (others => '0');
    -- miso               <= '0';
    else
      if rising_edge(sclk) then
        if nss = '1' then
          bit_count          <= 0;
          bit_count_previous <= 0;
          spi_data_in        <= (others => '0');
         -- miso               <= '0';
        else
          bit_count_previous <= bit_count;

          if bit_count = 7 then
            bit_count <= 0;
          else
            bit_count <= bit_count + 1;
          end if;

          spi_data_in <= spi_data_in(spi_data_in'high-1 downto spi_data_in'low) & mosi;
        --   miso        <= spi_data_out(7-bit_count);
        end if;
      end if;
    end if;
  end process;

  miso           <= spi_data_out(7-bit_count);
  spi_byte_done  <= (bit_count = 0) and (bit_count_previous = 7) and (nss = '0');
  spi_byte_begin <= (bit_count = 1) and (bit_count_previous = 0);


  ------------------------------------------------------------------------------
  -- State Machine Synchronous
  ------------------------------------------------------------------------------
  state_synch : process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        state <= IDLE;
      else
        state <= next_state;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- State Machine Asynchronous
  ------------------------------------------------------------------------------
  asynch_logic_process : process (all) is
  begin
    if (reset = '1') then
      next_state <= IDLE;
    else
      case (state) is
        when IDLE =>
          if nss = '1' then
            spi_data_out <= (others => '0');
            next_state   <= IDLE;
            address      <= (others => '0');
            spi_data_out <= (others => '0');
            data_write   <= (others => '0');
            first        <= '0';
            command      <= (others => '0');
          else
            if spi_byte_done then
              command    <= spi_data_in;
              next_state <= wait_START_ADDRESS;
            else
              next_state <= IDLE;
            end if;
          end if;

        when wait_START_ADDRESS =>
          if nss = '1' then
            next_state <= IDLE;
          else
            if spi_byte_begin = true then
              next_state <= READ_ADDRESS;
            else
              next_state <= wait_START_ADDRESS;
            end if;
          end if;

        when READ_ADDRESS =>
          if nss = '1' then
            next_state <= IDLE;
          else
            if spi_byte_done = true then
              address      <= spi_data_in(5 downto 0);
              spi_data_out <= data_read;
              if c_ADXL362_COMMAND_READ = command then
                next_state <= wait_START_READ_RESPONSE;
              end if;
              if c_ADXL362_COMMAND_WRITE = command then
                next_state <= wait_START_DATA;
              end if;
            else
              next_state <= READ_ADDRESS;
            end if;
          end if;

        when wait_START_DATA =>
          if nss = '0' then
            if spi_byte_begin = true then
              next_state <= READ_DATA;
            else
              next_state <= wait_START_DATA;
            end if;
          else
            next_state <= IDLE;
          end if;

        when READ_DATA =>
          if nss = '1' then
            next_state <= IDLE;
          else
            if (spi_byte_done = true) then
              data_write <= spi_data_in;
              next_state <= WRITE_register;
            else
              next_state <= READ_DATA;
            end if;
          end if;

        when WRITE_register =>
          write_sig  <= '1';
          next_state <= WRITE_register_DONE;

        when WRITE_register_DONE =>
          if nss = '1' then
            next_state <= IDLE;
          else
            write_sig  <= '0';
            first      <= '1';
            next_state <= WRITE_INCREMENT_ADDRESS;
          end if;

        when WRITE_INCREMENT_ADDRESS =>
          if nss = '1' then
            next_state <= IDLE;
          else
            if first = '1' then
              address <= std_logic_vector(unsigned(address) + 1);
              first   <= '0';
            else
              next_state <= wait_START_DATA;
            end if;
          end if;

        when wait_START_READ_RESPONSE =>
          if nss = '0' then
            spi_data_out <= data_read;
            if (spi_byte_begin = true) then
              next_state <= wait_DONE_READ_RESPONSE;
            else
              next_state <= wait_START_READ_RESPONSE;
            end if;
          else
            next_state <= IDLE;
          end if;

        when wait_DONE_READ_RESPONSE =>
          if (nss = '0') then
            if (spi_byte_done = true) then
              first      <= '1';
              next_state <= READ_INCREMENT_ADDRESS;
            else
              next_state <= wait_DONE_READ_RESPONSE;
            end if;
          else
            next_state <= IDLE;
          end if;

        when READ_INCREMENT_ADDRESS =>
          if (nss = '1') then
            next_state <= IDLE;
          else
            if (first = '1') then
              first   <= '0';
              address <= std_logic_vector(unsigned(address) + 1);
            end if;
            next_state <= wait_START_READ_RESPONSE;
          end if;

        when others =>
          next_state <= IDLE;

      end case;
    end if;
  end process;

end behavioral;
