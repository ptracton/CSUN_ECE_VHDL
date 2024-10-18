-------------------------------------------------------------------------------
-- Title      : CSUN ECE 420 Edge Detector
-- Project    :
-------------------------------------------------------------------------------
-- File       : edge_detect.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : CSUN
-- Created    : 2024-01-23
-- Last update: 2024-10-12
-- Platform   : Modelsim on Linux
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2024 CSUN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-01-23  1.0      ptracton        Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity edge_detector is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    data_in : in  std_logic;
    rising  : out std_logic;
    falling  : out std_logic
    );
end edge_detector;


architecture behavioral of edge_detector is
  signal synch : std_logic;
  signal edge  : std_logic;

begin

  -----------------------------------------------------------------------------
  --
  -- 2 Flops solution to edge detection
  -- The first flop, synch makes sure we are in this clock domain.  data_in might
  -- be asynchronous, so watch out for timing issues.
  --
  -- The second flop catches the synchronized signal. The output of this is good.
  --
  -----------------------------------------------------------------------------
  rising_detection : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        synch <= '0';
        edge  <= '0';
      else
        synch <= data_in;
        edge  <= synch;
      end if;
    end if;
  end process;

  -- if the synched signal is high, but the edge is not yet, we must be rising
  rising <= '1' when synch = '1' and edge = '0' else '0';

  -- if the synched signal is low but the edge is high, we must be falling
  falling <= '1' when synch ='0' and edge = '1' else '0';
end Behavioral;
