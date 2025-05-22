-------------------------------------------------------------------------------
-- Title      : Simple Timer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : simple_timer.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2025-05-11
-- Last update: 2025-05-21
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-05-11  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

entity one_shot_timer is
  generic (TIMER_COUNT : integer := 1000);
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    start         : in  std_logic;
    timer_expired : out std_logic);
end one_shot_timer;


architecture behavioral of one_shot_timer is
  -- Count to TIMER_COUNT and then assert timer_expired for 1 clock
  signal count             : integer;
  signal timer_expired_int : std_logic;
begin

  timer_proc : process(clk)
  begin
    if (reset = '1') then
      timer_expired_int <= '0';
      count         <= 0;
    else
      -- If we hit the terminal count,
      -- assert the timer_expired_int and clear the count
      if count = (TIMER_COUNT -1) then
        timer_expired_int <= '1';
        count         <= 0;
        -- If we have not expired, but the start signal is asserted
        -- start counting
      elsif start = '1' then
        timer_expired_int <= '0';
        count         <= 1;
      elsif timer_expired_int = '1' then
        timer_expired_int <= '0';
        -- If we have not expired, and we have started counting
        -- keep counting
      elsif count > 0 then
        timer_expired_int <= '0';
        count         <= count + 1;
      end if;
    end if;
  end process;

  timer_expired <= timer_expired_int;
  
end behavioral;
