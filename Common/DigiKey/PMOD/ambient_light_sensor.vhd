--------------------------------------------------------------------------------
--
--   FileName:         ambient_light_sensor.vhd
--   Dependencies:     spi_master.vhd
--   Design Software:  Vivado 2017.2
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 01/29/2019 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ambient_light_sensor IS
    GENERIC(
        spi_clk_div :   INTEGER := 13);  -- spi_clk_div = clk/8 (answer rounded up, clk in MHz)
    PORT(
        clk         :   IN      STD_LOGIC;                          --system clock
        reset_n     :   IN      STD_LOGIC;                          --active low reset
        miso        :   IN      STD_LOGIC;                          --SPI master in, slave out
        sclk        :   BUFFER  STD_LOGIC;                          --SPI clock
        ss_n        :   BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);       --SPI slave select
        als_data    :   OUT     STD_LOGIC_VECTOR(7 DOWNTO 0));      --ambient light sensor data
END ambient_light_sensor;

ARCHITECTURE behavior OF ambient_light_sensor IS
    SIGNAL   spi_rx_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);    --latest data received by SPI

    --declare SPI Master component
    COMPONENT spi_master IS
        GENERIC(
            slaves  : INTEGER := 1;  --number of spi slaves
            d_width : INTEGER := 16); --data bus width
        PORT(
            clock   : IN     STD_LOGIC;                             --system clock
            reset_n : IN     STD_LOGIC;                             --asynchronous reset
            enable  : IN     STD_LOGIC;                             --initiate transaction
            cpol    : IN     STD_LOGIC;                             --spi clock polarity
            cpha    : IN     STD_LOGIC;                             --spi clock phase
            cont    : IN     STD_LOGIC;                             --continuous mode command
            clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
            addr    : IN     INTEGER;                               --address of slave
            tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
            miso    : IN     STD_LOGIC;                             --master in, slave out
            sclk    : BUFFER STD_LOGIC;                             --spi clock
            ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
            mosi    : OUT    STD_LOGIC;                             --master out, slave in
            busy    : OUT    STD_LOGIC;                             --busy / data ready signal
            rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
    END COMPONENT spi_master;

BEGIN

  --instantiate and configure the SPI Master component
  spi_master_0:  spi_master
     GENERIC MAP(slaves => 1, d_width => 16)
     PORT MAP(clock => clk, reset_n => reset_n, enable => '1', cpol => '1',
           cpha => '1', cont => '0', clk_div => spi_clk_div, addr => 0,
           tx_data => (OTHERS => '0'), miso => miso, sclk => sclk, ss_n => ss_n,
           mosi => open, busy => open, rx_data => spi_rx_data);

    als_data <= spi_rx_data(12 DOWNTO 5);   --assign ambient light data bits to output

END behavior;