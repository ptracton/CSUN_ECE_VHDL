-------------------------------------------------------------------------------
-- Title      : Hygrometer to UART
-- Project    :
-------------------------------------------------------------------------------
-- File       : hygrometer_to_uart.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    :
-- Created    : 2024-11-20
-- Last update: 2024-12-05
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2024
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-11-20  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity hygrometer_to_uart is
  port(
    -- System Interface
    clk   : in std_logic;
    reset : in std_logic;

    -- Hygrometer Data
    temperature     : in std_logic_vector(10 downto 0);
    humidity        : in std_logic_vector(7 downto 0);
    uart_data_ready : in std_logic;

    -- UART Interface
    uart_request  : out std_logic;
    uart_grant    : in  std_logic;
    uart_tx_start : out std_logic;
    uart_data_tx  : out std_logic_vector(7 downto 0);
    uart_tx_busy  : in  std_logic
    );
end hygrometer_to_uart;

architecture Behavioral of hygrometer_to_uart is

  -- 20 Character buffer for transmitting ASCII out the UART
  --TEMP: 012 HUM: 01CRLF
  type t_TransmitBuffer is array (0 to 18) of std_logic_vector(7 downto 0);
  signal transmit_buffer : t_TransmitBuffer;
  signal transmit_addr   : std_logic_vector(4 downto 0);

  --State Machine
  type state_type is (IDLE, GET_bus, PREP_TRANSMIT, TRANSMIT, START_TRANSMIT, wait_TRANSMIT);
  signal state      : state_type;
  signal next_state : state_type;

  signal uart_tx_start_r : std_logic;
  signal uart_data_tx_r  : std_logic_vector(7 downto 0);
  signal uart_request_r  : std_logic;

  function f_HEX_2_ASCII (
    r_HEX_IN : in std_logic_vector(3 downto 0))
    return std_logic_vector is
    variable v_TEMP : std_logic_vector(7 downto 0);
  begin
    if (r_HEX_in >= x"0") and (r_HEX_in <= x"9")then
      v_TEMP := x"3" & r_HEX_in;
    elsif r_HEX_in = x"A" then
      V_TEMP := x"41";
    elsif r_HEX_in = x"B" then
      V_TEMP := x"42";
    elsif r_HEX_in = x"C" then
      V_TEMP := x"43";
    elsif r_HEX_in = x"D" then
      V_TEMP := x"44";
    elsif r_HEX_in = x"E" then
      V_TEMP := x"45";
    elsif r_HEX_in = x"F" then
      V_TEMP := x"46";
    end if;
    return std_logic_vector(v_TEMP);
  end;



begin

  ------------------------------------------------------------------------------
  -- process the transmit buffer 
  ------------------------------------------------------------------------------
  transmit_buffer_proc : process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        transmit_buffer(00) <= x"54";   -- T
        transmit_buffer(01) <= x"45";   -- E
        transmit_buffer(02) <= x"4D";   -- M
        transmit_buffer(03) <= x"50";   -- P
        transmit_buffer(04) <= x"3A";   -- :
        transmit_buffer(05) <= x"20";   -- SPACE
        transmit_buffer(06) <= x"30";   -- 0
        transmit_buffer(07) <= x"30";   -- 1
        transmit_buffer(08) <= x"30";   -- 2
        transmit_buffer(09) <= x"20";   -- SPACE
        transmit_buffer(10) <= x"48";   -- H
        transmit_buffer(11) <= x"55";   -- U
        transmit_buffer(12) <= x"4D";   -- M
        transmit_buffer(13) <= x"3A";   -- :
        transmit_buffer(14) <= x"20";   -- SPACE
        transmit_buffer(15) <= x"30";   -- 0
        transmit_buffer(16) <= x"30";   -- 1
        transmit_buffer(17) <= x"0A";   -- LF
        transmit_buffer(18) <= x"0D";   -- CR
      else
        -- in this state, synchronously turn the accel data into ascii and
        -- store in the transmit buffer to send
        if state = PREP_TRANSMIT then
          transmit_buffer(06) <= f_HEX_2_ASCII('0' & temperature(10 downto 8));
          transmit_buffer(07) <= f_HEX_2_ASCII(temperature(07 downto 4));
          transmit_buffer(08) <= f_HEX_2_ASCII(temperature(03 downto 0));

          transmit_buffer(16) <= f_HEX_2_ASCII(humidity(07 downto 4));
          transmit_buffer(15) <= f_HEX_2_ASCII(humidity(03 downto 0));
        end if;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- process the transmit buffer 
  ------------------------------------------------------------------------------
  transmit_address_proc : process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        transmit_addr <= "00000";
      else

        if state = IDLE then
          transmit_addr <= "00000";
        end if;

        if state = TRANSMIT then
          transmit_addr <= std_logic_vector(unsigned(transmit_addr) + 1);
        end if;

      end if;
    end if;
  end process;

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

  -----------------------------------------------------------------------------
  -- ASynchronous state logic
  -- Detect sequence and set next_state to transition on clock
  -- Drives output, but ascynch so it is not safe!
  -----------------------------------------------------------------------------
  asynch_logic_process : process (all) is
  begin
    if reset = '1' then
      next_state      <= IDLE;
      uart_tx_start_r <= '0';
      uart_data_tx_r  <= (others => '0');
      uart_request_r  <= '0';
    else
      case (state) is

        when IDLE =>
          -- wait in IDLE until we are here and there is new data ready from
          -- the hygrometer
          uart_request_r <= '0';
          if (uart_data_ready = '1') then
            next_state <= GET_BUS;
          else
            next_state <= IDLE;
          end if;

        when GET_bus =>
          -- Make sure we have the UART and not another task
          uart_request_r <= '1';
          if uart_grant = '1' then
            next_state <= PREP_TRANSMIT;
          else
            next_state <= GET_BUS;
          end if;

        when PREP_TRANSMIT =>
          -- wait here for 1 clock to load the transmit buffer with the
          -- hygrometer data
          next_state     <= TRANSMIT;
          uart_request_r <= '1';

        when TRANSMIT =>
          -- Write the value from the transmit buffer at it's pointer to the
          -- output port and increment the pointer to the next character
          uart_request_r  <= '1';
          uart_tx_start_r <= '1';
          uart_data_tx_r  <= transmit_buffer(to_integer (unsigned(transmit_addr)));
          next_state      <= START_TRANSMIT;

        when START_TRANSMIT =>
          -- wait for the transmission to start
          uart_request_r <= '1';
          if uart_tx_busy = '0' then
            next_state <= START_TRANSMIT;
          else
            next_state <= wait_TRANSMIT;
          end if;

        when wait_TRANSMIT =>
          -- wait for the transmit process to be complete before either sending
          -- another character or being done sending characters
          uart_request_r  <= '1';
          uart_tx_start_r <= '0';
          if uart_tx_busy = '1' then
            next_state <= wait_TRANSMIT;
          else
            if ("000" & transmit_addr) = x"13" then
              next_state <= IDLE;
            else
              next_state <= TRANSMIT;
            end if;
          end if;

        when others =>
          -- We should never reach here....
          next_state <= IDLE;
      end case;
    end if;
  end process;

  -----------------------------------------------------------------------------
  --
  -- Synchronous output logic
  -- Synchronize the output from the asynch state machine logic so it is
  -- safe to use in the system
  --
  -----------------------------------------------------------------------------
  output_process : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        uart_tx_start <= '0';
        uart_data_tx  <= (others => '0');
        uart_request  <= '0';
      else
        uart_tx_start <= uart_tx_start_r;
        uart_data_tx  <= uart_data_tx_r;
        uart_request  <= uart_request_r;
      end if;
    end if;
  end process;

end Behavioral;
