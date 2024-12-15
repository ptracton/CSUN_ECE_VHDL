-------------------------------------------------------------------------------
-- Title      : System Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : system_controller.vhd
-- Author     : Phil Tracton  <ptracton@gmail.com>
-- Company    : 
-- Created    : 2024-10-13
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
-- 2024-10-13  1.0      ptracton        Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

--Uncomment the following library declaration if instantiating
--any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.vcomponents.all;

entity system_controller is
  generic (RESET_COUNT : integer := 32);
  port(
    clk_in     : in  std_logic;
    reset_in   : in  std_logic;
    clk_out    : out std_logic;
    clk_pmod   : out std_logic;
    locked     : out std_logic;
    reset_out  : out std_logic;
    reset_pmod : out std_logic
    );
end system_controller;

architecture Behavioral of system_controller is
  component clk_wiz_0
    port
      (                                 -- Clock in ports
        -- Clock out ports
        clk_out1 : out std_logic;
        clk_out2 : out std_logic;
        -- Status and control signals
        reset    : in  std_logic;
        locked   : out std_logic;
        clk_in1  : in  std_logic
        );
  end component;
  signal reset_counter      : std_logic_vector(RESET_COUNT-1 downto 0);
  signal reset_counter_pmod : std_logic_vector(RESET_COUNT-1 downto 0);
  signal locked_wiz         : std_logic;
  signal clk_bufg           : std_logic;
  signal clk_pmod_int       : std_logic;
begin

  ------------------------------------------------------------------------------
  -- Synch the incoming reset to the local clock.  This clock might not be stable
  -- yet!
  ------------------------------------------------------------------------------        
  reset_sync : process (clk_in, reset_in)
  begin
    -- Asynch capture of reset signal and then hold it for RESET_COUNTS
    -- This lets all down stream logic have enough time to do a synch reset
    if (reset_in = '1') then
      reset_counter <= (others => '1');
    elsif (rising_edge(clk_in)) then
      reset_counter(RESET_COUNT-1 downto 1) <= reset_counter(RESET_COUNT-2 downto 0);
      -- https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Setting-up-Vivado-to-use-VHDL-2008
      reset_counter(0)                      <= '0' when (locked_wiz = '1') else '1';
    end if;
  end process;

  reset_sync_pmod : process (clk_pmod_int, reset_in)
  begin
    -- Asynch capture of reset signal and then hold it for RESET_COUNTS
    -- This lets all down stream logic have enough time to do a synch reset
    if (reset_in = '1') then
      reset_counter_pmod <= (others => '1');
    elsif (rising_edge(clk_pmod_int)) then
      reset_counter_pmod(RESET_COUNT-1 downto 1) <= reset_counter_pmod(RESET_COUNT-2 downto 0);
      -- https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Setting-up-Vivado-to-use-VHDL-2008
      reset_counter_pmod(0)                      <= '0' when (locked_wiz = '1') else '1';
    end if;
  end process;


  ------------------------------------------------------------------------------
  -- Clk Wiz the incoming clock to something stable and at a fequency we want
  ------------------------------------------------------------------------------        
  clk_wizard : clk_wiz_0
    port map (
      -- Clock out ports  
      clk_out1 => clk_out,
      clk_out2 => clk_pmod_int,
      -- Status and control signals                
      reset    => reset_in,
      locked   => locked_wiz,
      -- Clock in ports
      clk_in1  => clk_in
      );

  ------------------------------------------------------------------------------
  -- Drive outputs based on internal signals
  ------------------------------------------------------------------------------        
  reset_out  <= reset_counter(RESET_COUNT-1);
  reset_pmod <= not reset_counter_pmod(RESET_COUNT -1);
  locked     <= locked_wiz;
  clk_pmod   <= clk_pmod_int;

end Behavioral;
