--------------------------------------------------------------------------------
--
--   FileName:         pmod_compass.vhd
--   Dependencies:     i2c_master.vhd (Version 2.2)
--   Design Software:  Quartus Prime Version 17.0.0 Build 595 SJ Lite Edition
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
--   Version 1.0 03/27/2020 Scott Larson
--     Initial Public Release
-- 
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pmod_compass IS
  GENERIC(
    sys_clk_freq : INTEGER := 50_000_000;                  --input clock speed from user logic in Hz
    resolution   : INTEGER RANGE 0 TO 16 := 16;            --resolution in bits (must be 12, 14, or 16)
    update_freq  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11");  --code defining measurement frequency
  PORT(
    clk         : IN    STD_LOGIC;                                --system clock
    reset_n     : IN    STD_LOGIC;                                --asynchronous active-low reset
    scl         : INOUT STD_LOGIC;                                --I2C serial clock
    sda         : INOUT STD_LOGIC;                                --I2C serial data
    i2c_ack_err : OUT   STD_LOGIC;                                --I2C slave acknowledge error flag
    x           : OUT   STD_LOGIC_VECTOR(resolution-1 DOWNTO 0);  --x-axis data obtained
    y           : OUT   STD_LOGIC_VECTOR(resolution-1 DOWNTO 0);  --y-axis data obtained
    z           : OUT   STD_LOGIC_VECTOR(resolution-1 DOWNTO 0)); --z-axis data obtained
END pmod_compass;

ARCHITECTURE behavior OF pmod_compass IS
  CONSTANT compass_addr : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000";  --I2C address of the compass pmod
  TYPE machine IS(start, configure, pause, read_data, output_result); --needed states
  SIGNAL state           : machine;                       --state machine
  SIGNAL i2c_ena         : STD_LOGIC;                     --i2c enable signal
  SIGNAL i2c_addr        : STD_LOGIC_VECTOR(6 DOWNTO 0);  --i2c address signal
  SIGNAL i2c_rw          : STD_LOGIC;                     --i2c read/write command signal
  SIGNAL i2c_data_wr     : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c write data
  SIGNAL i2c_data_rd     : STD_LOGIC_VECTOR(7 DOWNTO 0);  --i2c read data
  SIGNAL i2c_busy        : STD_LOGIC;                     --i2c busy signal
  SIGNAL busy_prev       : STD_LOGIC;                     --previous value of i2c busy signal
  SIGNAL pause_factor    : INTEGER RANGE 0 TO 500;        --ratio to get correct pause duration
  SIGNAL resolution_bits : STD_LOGIC_VECTOR(1 DOWNTO 0);  --bits to set resolution in sensor register
  SIGNAL x_data          : STD_LOGIC_VECTOR(15 DOWNTO 0); --x-axis data buffer
  SIGNAL y_data          : STD_LOGIC_VECTOR(15 DOWNTO 0); --y-axis data buffer
  SIGNAL z_data          : STD_LOGIC_VECTOR(15 DOWNTO 0); --z-axis data buffer

  COMPONENT i2c_master IS
    GENERIC(
      input_clk : INTEGER;  --input clock speed from user logic in Hz
      bus_clk   : INTEGER); --speed the i2c bus (scl) will run at in Hz
    PORT(
      clk       : IN     STD_LOGIC;                    --system clock
      reset_n   : IN     STD_LOGIC;                    --active low reset
      ena       : IN     STD_LOGIC;                    --latch in command
      addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
      rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
      data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
      busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
      data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
      ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
      sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
      scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
  END COMPONENT;

BEGIN

  --instantiate the i2c master
  i2c_master_0:  i2c_master
    GENERIC MAP(input_clk => sys_clk_freq, bus_clk => 400_000)
    PORT MAP(clk => clk, reset_n => reset_n, ena => i2c_ena, addr => i2c_addr,
             rw => i2c_rw, data_wr => i2c_data_wr, busy => i2c_busy,
             data_rd => i2c_data_rd, ack_error => i2c_ack_err, sda => sda,
             scl => scl);

  --set the pause factor used to implement wait between updates
  WITH update_freq SELECT
    pause_factor <= 15  WHEN "00",
                    130 WHEN "01",
                    250 WHEN "10",
                    500 WHEN OTHERS;
               
   --determine the bits to set the resolution in the magnetic sensor's control register
  WITH resolution SELECT
    resolution_bits <= "11" WHEN 12,
                       "10" WHEN 14,
                       "00" WHEN OTHERS;             
         
  PROCESS(clk, reset_n)
    VARIABLE busy_cnt    : INTEGER RANGE 0 TO 7 := 0;                --counts the I2C busy signal transistions
    VARIABLE pwr_up_cnt  : INTEGER RANGE 0 TO sys_clk_freq/100 := 0; --counts 10ms to wait before communicating
    VARIABLE pause_cnt   : INTEGER := 0;                             --counter for wait periods between updates
  BEGIN
  
    IF(reset_n = '0') THEN               --reset activated
      pwr_up_cnt := 0;                     --clear power up counter
      i2c_ena <= '0';                      --clear I2C enable
      busy_cnt := 0;                       --clear busy counter
      pause_cnt := 0;                      --clear pause counter
      x <= (OTHERS => '0');                --clear the x-axis result output
      y <= (OTHERS => '0');                --clear the y-axis result output
      z <= (OTHERS => '0');                --clear the z-axis result output
      state <= start;                      --return to start state

    ELSIF(clk'EVENT AND clk = '1') THEN  --rising edge of system clock
      CASE state IS                        --state machine
      
        --give magnetic compass 10ms to power up before communicating
        WHEN start =>
          IF(pwr_up_cnt < sys_clk_freq/100) THEN  --10ms not yet reached
            pwr_up_cnt := pwr_up_cnt + 1;           --increment power up counter
          ELSE                                    --10ms reached
            pwr_up_cnt := 0;                        --clear power up counter
            state <= configure;                     --advance to configure the compass
          END IF;
        
        --configure the device (set the continuous mode feature and the resolution)
        WHEN configure =>
          busy_prev <= i2c_busy;                        --capture the value of the previous i2c busy signal
          IF(busy_prev = '0' AND i2c_busy = '1') THEN   --i2c busy just went high
            busy_cnt := busy_cnt + 1;                     --counts the times busy has gone from low to high during transaction
          END IF;
          CASE busy_cnt IS                              --busy_cnt keeps track of which command we are on
            WHEN 0 =>                                     --no command latched in yet
              i2c_ena <= '1';                               --initiate the transaction
              i2c_addr <= compass_addr;                     --set the address of the compass
              i2c_rw <= '0';                                --command 1 is a write
              i2c_data_wr <= "00000111";                    --set the register pointer to Control Register 0
            WHEN 1 =>                                     --1st busy high: command 1 latched, okay to issue command 2
              i2c_data_wr <= "0000" & update_freq & "10";   --set the update frequency and activate continuous mode
            WHEN 2 =>                                     --2nd busy high: command 2 latched
              i2c_data_wr <= "000000" & resolution_bits;    --set the resolution (register pointer auto-incremented)
            WHEN 3 =>                                     --2nd busy high: command 2 latched
              i2c_ena <= '0';                               --deassert enable to stop transaction after command 3
              IF(i2c_busy = '0') THEN                       --transaction complete
                busy_cnt := 0;                                --reset busy_cnt for next transaction
                state <= pause;                               --advance to the pause state
              END IF;
            WHEN OTHERS => NULL;
          END CASE;
      
        --wait for 1 update period
        WHEN pause =>
          IF(pause_cnt < sys_clk_freq*10/pause_factor) THEN  --update period time not met
            pause_cnt := pause_cnt + 1;                        --increment pause counter
          ELSE                                               --update period time met
            pause_cnt := 0;                                    --reset pause counter
            state <= read_data;                                --advance to reading data
          END IF;
       
        --gather all magnetic field data 
        WHEN read_data =>
          busy_prev <= i2c_busy;                       --capture the value of the previous i2c busy signal
          IF(busy_prev = '0' AND i2c_busy = '1') THEN  --i2c busy just went high
            busy_cnt := busy_cnt + 1;                    --counts the times busy has gone from low to high during transaction
          END IF;
          CASE busy_cnt IS                             --busy_cnt keeps track of which command we are on
            WHEN 0 =>                                    --no command latched in yet
              i2c_ena <= '1';                              --initiate the transaction
              i2c_addr <= compass_addr;                    --set the address of the compass
              i2c_rw <= '0';                               --command 1 is a write
              i2c_data_wr <= "00000000";                   --set the register pointer to the Xout Low (x-axis low-byte data) Register
            WHEN 1 =>                                    --1st busy high: command 1 latched
              i2c_rw <= '1';                               --command 2 is a read (addr stays the same)
            WHEN 2 =>                                    --2nd busy high: command 2 latched, okay to issue command 3
              IF(i2c_busy = '0') THEN                      --indicates data read in command 2 is ready
                x_data(7 DOWNTO 0) <= i2c_data_rd;           --retrieve x-axis low-byte data from command 2
              END IF;
            WHEN 3 =>                                    --3rd busy high: command 3 latched, okay to issue command 4
              IF(i2c_busy = '0') THEN                      --indicates data read in command 3 is ready
                x_data(15 DOWNTO 8) <= i2c_data_rd;          --retrieve x-axis high-byte data from command 3
              END IF;
            WHEN 4 =>                                    --4th busy high: command 4 latched, okay to issue command 5
              IF(i2c_busy = '0') THEN                      --indicates data read in command 4 is ready
                y_data(7 DOWNTO 0) <= i2c_data_rd;           --retrieve y-axis low-byte data from command 4
              END IF;
            WHEN 5 =>                                    --5th busy high: command 5 latched, okay to issue command 6
              IF(i2c_busy = '0') THEN                      --indicates data read in command 5 is ready
                y_data(15 DOWNTO 8) <= i2c_data_rd;          --retrieve y-axis high-byte data from command 5
              END IF;
            WHEN 6 =>                                    --6th busy high: command 6 latched, okay to issue command 7
              IF(i2c_busy = '0') THEN                      --indicates data read in command 6 is ready
                z_data(7 DOWNTO 0) <= i2c_data_rd;           --retrieve z-axis low-byte data from command 6
              END IF;
            WHEN 7 =>                                    --7th busy high: command 7 latched
              i2c_ena <= '0';                              --deassert enable to stop transaction after command 7
              IF(i2c_busy = '0') THEN                      --indicates data read in command 7 is ready
                z_data(15 DOWNTO 8) <= i2c_data_rd;          --retrieve z-axis high-byte data from command 7
                busy_cnt := 0;                               --reset busy_cnt for next transaction
                state <= output_result;                      --advance to output the result
              END IF;
            WHEN OTHERS => NULL;
          END CASE;
  
        --output the magnetic field data
        WHEN output_result =>
          x <= x_data(15 DOWNTO 16-resolution);  --write x-axis data to output
          y <= y_data(15 DOWNTO 16-resolution);  --write y-axis data to output
          z <= z_data(15 DOWNTO 16-resolution);  --write z-axis data to output
          state <= pause;                        --pause before retrieving next measurement

        --default to start state
        WHEN OTHERS =>
          state <= start;

      END CASE;
    END IF;
  END PROCESS;  
END behavior;
