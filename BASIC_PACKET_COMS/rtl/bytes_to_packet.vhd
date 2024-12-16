-------------------------------------------------------------------------------
-- Title      : Bytes to Packet
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bytes_to_packet.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-12-15
-- Last update: 2024-12-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2024 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-12-15  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity bytes_to_packet is
  port(
    -- System Interface
    clk   : in std_logic;
    reset : in std_logic;

    -- UART Interface
    byte_valid   : in std_logic;
    uart_data_rx : in std_logic_vector(7 downto 0);

    -- BRAM Interface
    ena   : out std_logic;
    wea   : out std_logic_vector(0 downto 0);
    addra : out std_logic_vector(8 downto 0);
    dina  : out std_logic_vector(7 downto 0);

    -- Processing Interface
    packet_valid : out std_logic;
    packet_error : out std_logic
    );
end bytes_to_packet;

architecture rtl of bytes_to_packet is

  type state_type is (IDLE, GET_COMMAND, GET_SIZE, GET_DATA);
  signal state      : state_type;
  signal next_state : state_type;

  -- Memory Inteface
  signal addra_r    : std_logic_vector(8 downto 0);
  signal dina_r     : std_logic_vector(7 downto 0);
  signal write_byte : std_logic;
  signal size       : std_logic_vector(7 downto 0);

  -- Packet Inteface
  signal packet_valid_r : std_logic;
  signal packet_error_r : std_logic;

begin
  -----------------------------------------------------------------------------
  -- Synchronous state changing logic
  -- State can only change with the clock
  -----------------------------------------------------------------------------
  synch_state_process : process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= IDLE;
      else
        state <= next_state;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Asynchronous states
  ------------------------------------------------------------------------------
  async_logic_process : process(all) is
  begin
    if reset = '1' then
      next_state     <= IDLE;
      write_byte     <= '0';
      addra_r        <= (others => '0');
      dina_r         <= (others => '0');
      size           <= (others => '0');
      packet_error_r <= '0';
      packet_valid_r <= '0';
    else
      case (state) is
        when IDLE =>
          -- wait here for the PREAMBLE to the communications
          -- when we  get it, move on to the
          write_byte     <= '0';
          addra_r        <= (others => '0');
          dina_r         <= (others => '0');
          packet_error_r <= '0';
          packet_valid_r <= '0';
          if byte_valid = '1' and uart_data_rx = x"C7" then
            next_state <= GET_COMMAND;
          else
            next_state <= IDLE;
          end if;

        when GET_COMMAND =>
          write_byte <= '0';
          if byte_valid = '1' then
            write_byte <= '1';
            dina_r     <= uart_data_rx;
            next_state <= GET_SIZE;
          else
            next_state <= GET_COMMAND;
          end if;

        when GET_SIZE =>
          write_byte <= '0';
          if byte_valid = '1' then
            write_byte <= '1';
            dina_r     <= uart_data_rx;
            size       <= uart_data_rx;
            addra_r    <= std_logic_vector(to_unsigned(to_integer(unsigned(addra_r)) + 1, 9));
            next_state <= GET_DATA;
          else
            next_state <= GET_COMMAND;
          end if;

        when GET_DATA =>
          next_state <= IDLE;

        when others =>
          next_state     <= IDLE;
          packet_error_r <= '1';
      end case;
    end if;


  end process;

  -----------------------------------------------------------------------------
  -- Synchronous output logic
  -- Synchronize the output from the asynch state machine logic so it is
  -- safe to use in the system
  -----------------------------------------------------------------------------
  output_process : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ena          <= '0';
        wea          <= "0";
        addra        <= (others => '0');
        dina         <= (others => '0');
        packet_valid <= '0';
        packet_error <= '0';
      else

        -- Only assert the write to BRAM signal on command
        if write_byte = '1' then
          ena   <= '1';
          wea   <= "1";
          addra <= addra_r;
          dina  <= dina_r;
        else
          ena   <= '1';
          wea   <= "0";
          addra <= (others => '0');
          dina  <= (others => '0');
        end if;

        packet_valid <= packet_valid_r;
        packet_error <= packet_error_r;
      end if;
    end if;
  end process;

end rtl;
