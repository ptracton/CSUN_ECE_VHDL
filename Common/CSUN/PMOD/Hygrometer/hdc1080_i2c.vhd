-------------------------------------------------------------------------------
-- Title      : HDC1080 I2C Module
-- Project    :
-------------------------------------------------------------------------------
-- File       : hdc1080_i2c.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    :
-- Created    : 2024-11-21
-- Last update: 2024-11-26
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

entity hdc1080_i2c is
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
end entity;

architecture rtl of hdc1080_i2c is

  -- I2C state machine
  type i2c_state_t is (IDLE, GET_I2C_ADDR, GET_REG_ADDR, READ_DATA, WRITE_DATA);
  signal state : i2c_state_t := IDLE;

  signal sda_int   : std_logic := '0';
  signal sda_prev  : std_logic := '1';
  signal scl_prev  : std_logic := '0';
  signal bit_count : integer   := 7;

  signal data_shift     : std_logic_vector(7 downto 0) := x"00";
  signal addr_match     : std_logic                    := '0';
  signal rw_bit         : std_logic                    := '0';
  signal sda_out        : std_logic                    := '0';
  signal start_detected : std_logic                    := '0';
  signal sda_enable     : std_logic                    := '0';

  signal i2c_addr : std_logic_vector(6 downto 0);
begin

  sda      <= sda_out when sda_enable = '1' else 'Z';
  sda_int  <= '1'     when sda = 'Z'        else '0';
  i2c_addr <= data_shift(7 downto 1);

  i2c_fsm : process(scl)
    variable sda_current : std_logic;
  begin
    if falling_edge(scl) then
      scl_prev    <= scl;
      sda_prev    <= sda_int;
      sda_current := sda_int;
      case (state) is
        when IDLE =>
          bit_count      <= 8;
          sda_enable     <= '0';
          reg_write      <= '0';
          reg_addr       <= x"00";
          reg_write_data <= x"0000";
          if sda_prev = '1' and sda_int = '0' then
            state          <= GET_I2C_ADDR;
            start_detected <= '1';
            data_shift     <= (others => '0');
          end if;

        when GET_I2C_ADDR =>
          -- Get the I2C Address to be sure we are the device being
          -- communicated with
          start_detected <= '0';
          data_shift     <= data_shift(6 downto 0) & sda_current;
          if bit_count = 0 then
            if i2c_addr = SLAVE_ID_ADDR then
              addr_match <= '1';
              rw_bit     <= sda_int;
              state      <= GET_REG_ADDR;
              bit_count  <= 8;
              sda_out    <= '0';
            else
              state <= IDLE;             -- not our address, do not act
            end if;
          else
            bit_count <= bit_count - 1;  -- not enough bits, keep shifting
          end if;

        when GET_REG_ADDR =>
          -- This is the "pointer" to which register in the HDC1080 to access
          data_shift <= data_shift(6 downto 0) & sda_current;
          if bit_count = 0 then
            reg_addr   <= data_shift;
            sda_out    <= '0';
            sda_enable <= '1';
            if rw_bit = '1' then
              state     <= READ_DATA;
              bit_count <= 8;
            else
              state <= WRITE_DATA;
            end if;
          else
            bit_count <= bit_count - 1;  -- not enough bits, keep shifting
            state     <= GET_REG_ADDR;
          end if;

        when WRITE_DATA =>
          data_shift <= data_shift(6 downto 0) & sda_current;
          if bit_count = 0 then
            -- Write to the registers
            reg_write                  <= '1';
            reg_write_data(7 downto 0) <= data_shift;

            sda_enable <= '1';
            sda_out    <= '0';          -- ACK
            state      <= IDLE;
          else
            reg_write <= '0';
            bit_count <= bit_count - 1;
            state     <= WRITE_DATA;
          end if;


        when READ_DATA =>
          --sda_int    <= data_shift(7);
          data_shift <= data_shift(6 downto 0) & '0';
          if bit_count = 0 then
            if sda_current = '0' then   -- ACK received
              bit_count  <= 7;
              -- READ THE REGISTERS
              data_shift <= x"C7";
            else
              bit_count <= bit_count - 1;
              state     <= READ_DATA;
            end if;
            state <= IDLE;
          end if;

        when others =>
          -- Just in case something goes wrong
          state <= IDLE;
      end case;
    end if;
  end process;
end architecture rtl;
