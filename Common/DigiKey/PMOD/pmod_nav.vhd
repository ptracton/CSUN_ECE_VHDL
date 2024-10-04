--------------------------------------------------------------------------------
--
--   FileName:         pmod_nav.vhd
--   Dependencies:     spi_master.vhd
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
--   Version 1.0 08/15/2022 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pmod_nav IS
  GENERIC(
    clk_freq                     : INTEGER := 50;              --system clock frequency in MHz
    accelerometer_gyro_data_rate : STD_LOGIC_VECTOR := "110";  --data rate code to configure the accelerometer and gyro
    accelerometer_full_scale     : STD_LOGIC_VECTOR := "00";   --full scale code to configure the accelerometer
    gyro_full_scale              : STD_LOGIC_VECTOR := "00";   --full scale code to configure the gyro
    magnetometer_data_rate       : STD_LOGIC_VECTOR := "111";  --data rate code to configure the magnetometer
    magnetometer_full_scale      : STD_LOGIC_VECTOR := "00";   --full scale code to configure the magnetometer 
    pressure_data_rate           : STD_LOGIC_VECTOR := "100"); --data rate code to configure the pressure sensor
  PORT(
    clk              : IN      STD_LOGIC;                      --system clock
    reset_n          : IN      STD_LOGIC;                      --active low asynchronous reset
    miso             : IN      STD_LOGIC;                      --SPI bus: master in, slave out
    sclk             : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
    ss_n             : BUFFER  STD_LOGIC_VECTOR(2 DOWNTO 0);   --SPI bus: slave select
    mosi             : OUT     STD_LOGIC;                      --SPI bus: master out, slave in
    acceleration_x   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis acceleration data
    acceleration_y   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis acceleration data
    acceleration_z   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --z-axis acceleration data
    angular_rate_x   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis angular rate data
    angular_rate_y   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis angular rate data
    angular_rate_z   : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --z-axis angular rate data
    magnetic_field_x : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis magnetic field data
    magnetic_field_y : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis magnetic field data
    magnetic_field_z : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --z-axis magnetic field data
    pressure         : OUT     STD_LOGIC_VECTOR(23 DOWNTO 0)); --absolute pressure data
END pmod_nav;

ARCHITECTURE behavior OF pmod_nav IS
  TYPE machine IS(start, configure_accelerometer, configure_magnetometer, configure_gyro,     --needed states
                  configure_pressure, pause, read_data_accelerometer, read_data_magnetometer, 
                  read_data_gyro, read_data_pressure, output_result);
  SIGNAL state                : machine := start;               --state machine
  SIGNAL spi_busy_prev        : STD_LOGIC;                      --previous value of the SPI component's busy signal
  SIGNAL spi_busy             : STD_LOGIC;                      --busy signal from SPI component
  SIGNAL spi_ena              : STD_LOGIC;                      --enable for SPI component
  SIGNAL spi_slave_addr       : INTEGER;                        --address of SPI slave select
  SIGNAL spi_cont             : STD_LOGIC;                      --continuous mode signal for SPI component
  SIGNAL spi_tx_data          : STD_LOGIC_VECTOR(7 DOWNTO 0);   --transmit data for SPI component
  SIGNAL spi_rx_data          : STD_LOGIC_VECTOR(7 DOWNTO 0);   --received data from SPI component
  SIGNAL acceleration_x_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal x-axis acceleration data buffer
  SIGNAL acceleration_y_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal y-axis acceleration data buffer
  SIGNAL acceleration_z_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal z-axis acceleration data buffer
  SIGNAL angular_rate_x_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal x-axis angular rate data buffer
  SIGNAL angular_rate_y_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal y-axis angular rate data buffer
  SIGNAL angular_rate_z_int   : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal z-axis angular rate data buffer
  SIGNAL magnetic_field_x_int : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal x-axis magnetic field data buffer
  SIGNAL magnetic_field_y_int : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal y-axis magnetic field data buffer
  SIGNAL magnetic_field_z_int : STD_LOGIC_VECTOR(15 DOWNTO 0);  --internal z-axis magnetic field data buffer
  SIGNAL pressure_int         : STD_LOGIC_VECTOR(23 DOWNTO 0);  --internal absolute pressure data buffer
  
  --declare SPI Master component
  COMPONENT spi_master IS
     GENERIC(
        slaves  : INTEGER := 3;  --number of spi slaves
        d_width : INTEGER := 8); --data bus width
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

  --instantiate the SPI Master component
  spi_master_0:  spi_master
    GENERIC MAP(slaves => 3, d_width => 8)
    PORT MAP(clock => clk, reset_n => reset_n, enable => spi_ena, cpol => '1', cpha => '1',
             cont => spi_cont, clk_div => clk_freq/10, addr => spi_slave_addr, tx_data => spi_tx_data,
             miso => miso, sclk => sclk, ss_n => ss_n, mosi => mosi, busy => spi_busy, rx_data => spi_rx_data);

  PROCESS(clk)
    VARIABLE count : INTEGER := 0; --universal counter
  BEGIN
  
  IF(reset_n = '0') THEN                --reset activated
      count := 0;                           --clear universal counter
      spi_busy_prev <= '0';                 --clear previous value of SPI component's busy signal
      spi_ena <= '0';                       --clear SPI component enable
      spi_cont <= '0';                      --clear SPI component continuous mode signal
      spi_tx_data <= (OTHERS => '0');       --clear SPI component transmit data
      acceleration_x <= (OTHERS => '0');    --clear x-axis acceleration data
      acceleration_y <= (OTHERS => '0');    --clear y-axis acceleration data
      acceleration_z <= (OTHERS => '0');    --clear z-axis acceleration data
      angular_rate_x <= (OTHERS => '0');    --clear x-axis angular rate data
      angular_rate_y <= (OTHERS => '0');    --clear y-axis angular rate data
      angular_rate_z <= (OTHERS => '0');    --clear z-axis angular rate data
      magnetic_field_x <= (OTHERS => '0');  --clear x-axis magnetic field data
      magnetic_field_y <= (OTHERS => '0');  --clear y-axis magnetic field data
      magnetic_field_z <= (OTHERS => '0');  --clear z-axis magnetic field data
      pressure <= (OTHERS => '0');          --clear absolute pressure data		
      state <= start;                       --restart state machine

  ELSIF(clk'EVENT AND clk = '1') THEN   --rising edge of system clock
      CASE state IS                        --state machine

        --give the devices 200ms to power up before communicating
        WHEN start =>
          IF(count < clk_freq*200_000) THEN   --200ms not yet reached
            count := count + 1;                 --increment counter
          ELSE                                --200ms reached
            count := 0;                         --clear universal counter
            state <= configure_accelerometer;   --advance to accelerometer configuration
          END IF;
			 
        --performs SPI transaction to write accelerometer configuration registers  
        WHEN configure_accelerometer =>
          spi_busy_prev <= spi_busy;                               --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN          --spi busy just went low
            count := count + 1;                                      --counts times busy goes from high to low during transaction
          END IF;
          CASE count IS                                            --number of times busy has gone from high to low
            WHEN 0 =>                                                --no busy deassertions
              IF(spi_busy = '0') THEN                                  --transaction not started
                spi_slave_addr <= 0;                                     --set spi slave to the accelerometer/gyro (slave 0)
                spi_cont <= '1';                                         --set to continuous mode
                spi_ena <= '1';                                          --enable SPI transaction
                spi_tx_data <= "00100000";                               --send command to write to CTRL_REG6_XL
              ELSE                                                     --transaction latched in
                spi_tx_data <= "000" & accelerometer_full_scale & "000"; --configuration word for CTRL_REG6_XL
              END IF;
            WHEN 1 =>                                                --first busy deassertion
              spi_cont <= '0';                                         --clear continous mode to end transaction
              spi_ena <= '0';                                          --clear SPI transaction enable
            WHEN 2 =>                                                --second busy deassertion
              count := 0;                                              --clear universal counter
              state <= configure_magnetometer;                         --advance to magnetometer configuration
            WHEN OTHERS => NULL;
          END CASE;
			 
        --performs SPI transaction to write magnetometer configuration registers  
        WHEN configure_magnetometer =>
          spi_busy_prev <= spi_busy;                              --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN         --spi busy just went low
            count := count + 1;                                     --counts times busy goes from high to low during transaction
          END IF;
          CASE count IS                                           --number of times busy has gone from high to low
            WHEN 0 =>                                               --no busy deassertions
              IF(spi_busy = '0') THEN                                 --transaction not started
                spi_slave_addr <= 1;                                    --set spi slave to the magnetometer (slave 1)
                spi_cont <= '1';                                        --set to continuous mode
                spi_ena <= '1';                                         --enable SPI transaction
                spi_tx_data <= "01100000";                              --set write address to CTRL_REG1_M
              ELSE                                                    --transaction latched in
                spi_tx_data <= "010" & magnetometer_data_rate & "00";   --configuration word for CTRL_REG1_M
              END IF;
            WHEN 1 =>                                               --first busy deassertion
              spi_tx_data <= '0' & magnetometer_full_scale & "00000"; --configuration word for CTRL_REG2_M
            WHEN 2 =>                                               --second busy deassertion
              spi_tx_data <= "00000000";                              --configuration word for CTRL_REG3_M
            WHEN 3 =>                                               --third busy deassertion
              spi_tx_data <= "00001000";                              --configuration word for CTRL_REG4_M
              spi_cont <= '0';                                        --clear continous mode to end transaction
              spi_ena <= '0';                                         --clear SPI transaction enable
            WHEN 4 =>                                               --forth busy deassertion
              count := 0;                                             --clear universal counter
              state <= configure_gyro;                                --advance to gyro configuration
            WHEN OTHERS => NULL;
          END CASE;
			 
        --performs SPI transaction to write gyro configuration registers  
        WHEN configure_gyro =>
          spi_busy_prev <= spi_busy;                              --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN         --spi busy just went low
            count := count + 1;                                     --counts times busy goes from high to low during transaction
          END IF;
          CASE count IS                                           --number of times busy has gone from high to low
            WHEN 0 =>                                               --no busy deassertions
              IF(spi_busy = '0') THEN                                 --transaction not started
                spi_slave_addr <= 0;                                    --set spi slave to the accelerometer/gyro (slave 0)
                spi_cont <= '1';                                        --set to continuous mode
                spi_ena <= '1';                                         --enable SPI transaction
                spi_tx_data <= "00010000";                              --send command to write to CTRL_REG1_G
              ELSE                                                    --transaction latched in
                spi_tx_data <= accelerometer_gyro_data_rate & gyro_full_scale & "000"; --configuration word for CTRL_REG1_G
              END IF;
            WHEN 1 =>                                               --first busy deassertion
              spi_cont <= '0';                                        --clear continous mode to end transaction
              spi_ena <= '0';                                         --clear SPI transaction enable
            WHEN 2 =>                                               --second busy deassertion
              count := 0;                                             --clear universal counter
              state <= configure_pressure;                            --advance to pressure sensor configuration
            WHEN OTHERS => NULL;
          END CASE;

        --performs SPI transaction to write pressure sensor configuration registers  
        WHEN configure_pressure =>
          spi_busy_prev <= spi_busy;                          --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN     --spi busy just went low
            count := count + 1;                                 --counts times busy goes from high to low during transaction
          END IF;
          CASE count IS                                       --number of times busy has gone from high to low
            WHEN 0 =>                                           --no busy deassertions
              IF(spi_busy = '0') THEN                             --transaction not started
                spi_slave_addr <= 2;                                --set spi slave to the pressure sensor (slave 2)
                spi_cont <= '1';                                    --set to continuous mode
                spi_ena <= '1';                                     --enable SPI transaction
                spi_tx_data <= "01100000";                          --send command to write to CTRL_REG1
              ELSE                                                --transaction latched in
                spi_tx_data <= '1' & pressure_data_rate & "0000";   --configuration word for CTRL_REG1
              END IF;
            WHEN 1 =>                                           --first busy deassertion
              spi_cont <= '0';                                    --clear continous mode to end transaction
              spi_ena <= '0';                                     --clear SPI transaction enable
            WHEN 2 =>                                           --second busy deassertion
              count := 0;                                         --clear universal counter
              state <= pause;                                     --advance to reading accelerometer data
            WHEN OTHERS => NULL;
          END CASE;
			 
        --pauses 1ms between SPI transactions
        WHEN pause =>
          IF(count < clk_freq*1000) THEN     --less than 1ms
            count := count + 1;                --increment counter
          ELSE                               --1ms has elapsed
            count := 0;                        --clear universal counter
            state <= read_data_accelerometer;  --advance to read accelerometer data
          END IF;

        --performs SPI transactions that read accelerometer data registers  
        WHEN read_data_accelerometer =>
          spi_busy_prev <= spi_busy;                        --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN   --spi busy just went low
            count := count + 1;                               --counts the times busy goes from high to low during transaction
          END IF;          
          CASE count IS                                     --number of times busy has gone from high to low
            WHEN 0 =>                                         --no busy deassertions
              IF(spi_busy = '0') THEN                           --transaction not started
                spi_slave_addr <= 0;                              --set spi slave to the accelerometer/gyro (slave 0)
                spi_cont <= '1';                                  --set to continuous mode
                spi_ena <= '1';                                   --enable SPI transaction
                spi_tx_data <= "10101000";                        --send read command to OUT_X_XL register
              ELSE                                              --transaction latched in
                spi_tx_data <= "00000000";                        --deassert MOSI
              END IF;
            WHEN 2 =>                                         --2nd busy deassertion
              acceleration_x_int(7 DOWNTO 0) <= spi_rx_data;    --latch in first received acceleration data
            WHEN 3 =>                                         --3rd busy deassertion
              acceleration_x_int(15 DOWNTO 8) <= spi_rx_data;   --latch in second received acceleration data
            WHEN 4 =>                                         --4th busy deassertion
              acceleration_y_int(7 DOWNTO 0) <= spi_rx_data;    --latch in third received acceleration data
            WHEN 5 =>                                         --5th busy deassertion
              acceleration_y_int(15 DOWNTO 8) <= spi_rx_data;   --latch in fourth received acceleration data
            WHEN 6 =>                                         --6th busy deassertion
              spi_cont <= '0';                                  --clear continuous mode to end transaction
              spi_ena <= '0';                                   --clear SPI transaction enable
              acceleration_z_int(7 DOWNTO 0) <= spi_rx_data;    --latch in fifth received acceleration data
            WHEN 7 =>                                         --7th busy deassertion
              acceleration_z_int(15 DOWNTO 8) <= spi_rx_data;   --latch in sixth received acceleration data
              count := 0;                                       --clear universal counter
              state <= read_data_magnetometer;                  --advance to reading magnetometer data
            WHEN OTHERS => NULL;
          END CASE;

        --performs SPI transactions that read magnetometer data registers  
        WHEN read_data_magnetometer =>
          spi_busy_prev <= spi_busy;                          --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN     --spi busy just went low
            count := count + 1;                                 --counts the times busy goes from high to low during transaction
          END IF;          
          CASE count IS                                       --number of times busy has gone from high to low
            WHEN 0 =>                                           --no busy deassertions
              IF(spi_busy = '0') THEN                             --transaction not started
                spi_slave_addr <= 1;                                --set spi slave to the magnetometer (slave 1)
                spi_cont <= '1';                                    --set to continuous mode
                spi_ena <= '1';                                     --enable SPI transaction
                spi_tx_data <= "11101000";                          --send read command to OUT_X_L_M register
              ELSE                                                --transaction latched in
                spi_tx_data <= "00000000";                          --deassert MOSI
              END IF;
            WHEN 2 =>                                           --2nd busy deassertion
              magnetic_field_x_int(7 DOWNTO 0) <= spi_rx_data;    --latch in first received magnetic field data
            WHEN 3 =>                                           --3rd busy deassertion
              magnetic_field_x_int(15 DOWNTO 8) <= spi_rx_data;   --latch in second received magnetic field data
            WHEN 4 =>                                           --4th busy deassertion
              magnetic_field_y_int(7 DOWNTO 0) <= spi_rx_data;    --latch in third received magnetic field data
            WHEN 5 =>                                           --5th busy deassertion
              magnetic_field_y_int(15 DOWNTO 8) <= spi_rx_data;   --latch in fourth received magnetic field data
            WHEN 6 =>                                           --6th busy deassertion
              spi_cont <= '0';                                    --clear continuous mode to end transaction
              spi_ena <= '0';                                     --clear SPI transaction enable
              magnetic_field_z_int(7 DOWNTO 0) <= spi_rx_data;    --latch in fifth received magnetic field data
            WHEN 7 =>                                           --7th busy deassertion
              magnetic_field_z_int(15 DOWNTO 8) <= spi_rx_data;   --latch in sixth received magnetic field data
              count := 0;                                         --clear universal counter
              state <= read_data_gyro;                            --advance to reading gyro data
            WHEN OTHERS => NULL;
          END CASE;

        --performs SPI transactions that read gyro data registers  
        WHEN read_data_gyro =>
          spi_busy_prev <= spi_busy;                        --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN   --spi busy just went low
            count := count + 1;                               --counts the times busy goes from high to low during transaction
          END IF;          
          CASE count IS                                     --number of times busy has gone from high to low
            WHEN 0 =>                                         --no busy deassertions
              IF(spi_busy = '0') THEN                           --transaction not started
                spi_slave_addr <= 0;                              --set spi slave to the accelerometer/gyro (slave 0)
                spi_cont <= '1';                                  --set to continuous mode
                spi_ena <= '1';                                   --enable SPI transaction
                spi_tx_data <= "10011000";                        --send read command to OUT_X_G register
              ELSE                                              --transaction latched in
                spi_tx_data <= "00000000";                        --deassert MOSI
              END IF;
            WHEN 2 =>                                         --2nd busy deassertion
              angular_rate_x_int(7 DOWNTO 0) <= spi_rx_data;    --latch in first received angular rate data
            WHEN 3 =>                                         --3rd busy deassertion
              angular_rate_x_int(15 DOWNTO 8) <= spi_rx_data;   --latch in second received angular rate data
            WHEN 4 =>                                         --4th busy deassertion
              angular_rate_y_int(7 DOWNTO 0) <= spi_rx_data;    --latch in third received angular rate data
            WHEN 5 =>                                         --5th busy deassertion
              angular_rate_y_int(15 DOWNTO 8) <= spi_rx_data;   --latch in fourth received angular rate data
            WHEN 6 =>                                         --6th busy deassertion
              spi_cont <= '0';                                  --clear continuous mode to end transaction
              spi_ena <= '0';                                   --clear SPI transaction enable
              angular_rate_z_int(7 DOWNTO 0) <= spi_rx_data;    --latch in fifth received angular rate data
            WHEN 7 =>                                         --7th busy deassertion
              angular_rate_z_int(15 DOWNTO 8) <= spi_rx_data;   --latch in sixth received angular rate data
              count := 0;                                       --clear universal counter
              state <= read_data_pressure;                      --advance to reading absolute pressure data
            WHEN OTHERS => NULL;
          END CASE;
			 
        --performs SPI transactions that read pressure sensor data registers  
        WHEN read_data_pressure =>
          spi_busy_prev <= spi_busy;                        --capture the value of the previous spi busy signal
          IF(spi_busy_prev = '1' AND spi_busy = '0') THEN   --spi busy just went low
            count := count + 1;                               --counts the times busy goes from high to low during transaction
          END IF;          
          CASE count IS                                     --number of times busy has gone from high to low
            WHEN 0 =>                                         --no busy deassertions
              IF(spi_busy = '0') THEN                           --transaction not started
                spi_slave_addr <= 2;                              --set spi slave to the pressure sensor (slave 2)
                spi_cont <= '1';                                  --set to continuous mode
                spi_ena <= '1';                                   --enable SPI transaction
                spi_tx_data <= "11101000";                        --send read command to PRESS_OUT_XL register
              ELSE                                              --transaction latched in
                spi_tx_data <= "00000000";                        --deassert MOSI
              END IF;
            WHEN 2 =>                                         --2nd busy deassertion
              pressure_int(7 DOWNTO 0) <= spi_rx_data;          --latch in first received absolute pressure data
            WHEN 3 =>                                         --3rd busy deassertion
              spi_cont <= '0';                                  --clear continuous mode to end transaction
              spi_ena <= '0';                                   --clear SPI transaction enable
              pressure_int(15 DOWNTO 8) <= spi_rx_data;         --latch in second received absolute pressure data
            WHEN 4 =>                                         --4th busy deassertion
              pressure_int(23 DOWNTO 16) <= spi_rx_data;        --latch in third received absolute pressure data
              count := 0;                                       --clear universal counter
              state <= output_result;                           --proceed to outputting the resulting data
            WHEN OTHERS => NULL;
          END CASE;
  
        --output data
        WHEN output_result =>
            acceleration_x <= acceleration_x_int;     --output x-axis acceleration data
            acceleration_y <= acceleration_y_int;     --output y-axis acceleration data
            acceleration_z <= acceleration_z_int;     --output z-axis acceleration data
            angular_rate_x <= angular_rate_x_int;     --output x-axis angular rate data
            angular_rate_y <= angular_rate_y_int;     --output y-axis angular rate data
            angular_rate_z <= angular_rate_z_int;     --output z-axis angular rate data
            magnetic_field_x <= magnetic_field_x_int; --output x-axis magnetic field data
            magnetic_field_y <= magnetic_field_y_int; --output y-axis magnetic field data
            magnetic_field_z <= magnetic_field_z_int; --output z-axis magnetic field data
            pressure <= pressure_int;                 --output absolute pressure data
            state <= pause;                           --advance to pause state
   
        --default to start state
        WHEN OTHERS => 
          state <= start;

      END CASE;      
    END IF;
  END PROCESS;
END behavior;
