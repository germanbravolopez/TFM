----------------------------------------------------------------------------------
-- Company: Polytechnic University of Madrid
-- Engineer: Germán Bravo López
-- 
-- Create Date: 27.02.2019 19:04:23
-- Design Name: Graphs of the pong test
-- Module Name: pong_graph_test - Behavioral
-- Project Name: image_filtering
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pong_graph_test is
    port ( 
        video_on         : in std_logic;
        pixel_x, pixel_y : in std_logic_vector(9 downto 0);
        graph_rgb        : out std_logic_vector(2 downto 0)
    );
end pong_graph_test;

architecture Behavioral of pong_graph_test is
  -- x, y, coordinates (0,0) to (639, 479)
  signal pix_x, pix_y : unsigned(9 downto 0);
  constant MAX_X : integer := 640;
  constant MAX_Y : integer := 480;
  ---------------------------------------------
  -- vertical stripe as a wall
  ---------------------------------------------
  -- wall left, right boundary
  constant WALL_X_L : integer := 32;
  constant WALL_X_R : integer := 35;
  ---------------------------------------------
  -- right vertical bar
  ---------------------------------------------
  constant BAR_Y_SIZE : integer := 72;
  -- bar left, right boundary
  constant BAR_X_L : integer := 600;
  constant BAR_X_R : integer := 603;
  -- bar top, bottom boundary
  constant BAR_Y_T : integer := MAX_Y/2 - BAR_Y_SIZE/2; -- 204
  constant BAR_Y_B : integer := BAR_Y_T + BAR_Y_SIZE - 1;
  ---------------------------------------------
  -- square ball                        
  ---------------------------------------------
  constant BALL_SIZE : integer := 8;
  -- ball left, right boundary                                  
  constant BALL_X_L_cte : integer := 580;                           
  constant BALL_X_R_cte : integer := BALL_X_L_cte + BALL_SIZE - 1; 
  signal ball_x_l : unsigned(9 downto 0) := to_unsigned(BALL_X_L_cte,10);
  signal ball_x_r : unsigned(9 downto 0) := to_unsigned(BALL_X_R_cte,10);                          
  -- ball top, bottom boundary                                  
  constant BALL_Y_T_cte : integer := 238; 
  constant BALL_Y_B_cte : integer := BALL_Y_T_cte + BALL_SIZE - 1; 
  signal ball_y_t : unsigned(9 downto 0) := to_unsigned(BALL_Y_T_cte,10);    
  signal ball_y_b : unsigned(9 downto 0) := to_unsigned(BALL_Y_B_cte,10);     
  ---------------------------------------------
  -- square ball                               
  ---------------------------------------------
  signal wall_on, bar_on, sq_ball_on : std_logic;
  signal wall_rgb, bar_rgb, ball_rgb : std_logic_vector(2 downto 0);
  ---------------------------------------------
  -- round ball image ROM                          
  ---------------------------------------------
  type rom_type is array (0 to 7) of std_logic_vector(0 to 7);
  -- ROM definition
  constant BALL_ROM: rom_type := 
  (
      "00111100", --   ****
      "01111110", --  ******
      "11111111", -- ********
      "11111111", -- ********
      "11111111", -- ********
      "11111111", -- ********
      "01111110", --  ******
      "00111100"  --   ****
  );
  signal rom_addr, rom_col : unsigned(2 downto 0);
  signal rom_data          : std_logic_vector(7 downto 0);
  signal rom_bit           : std_logic;
  -- new signal to indicate whether the scan coordinates are within 
  -- the round ball region
  signal rd_ball_on : std_logic;

begin

    pix_x <= unsigned(pixel_x);
    pix_y <= unsigned(pixel_y);
    ---------------------------------------------
    -- left vertical stripe (wall)                      
    ---------------------------------------------
    wall_on <= 
        '1' when (WALL_X_L <= pix_x) and (pix_x <= WALL_X_R) else
        '0';
    wall_rgb <= "001"; -- blue
    
    ---------------------------------------------
    -- right vertical stripe                               
    ---------------------------------------------
    bar_on <=                                                   
        '1' when (BAR_X_L <= pix_x) and (pix_x <= BAR_X_R) and 
                 (BAR_Y_T <= pix_y) and (pix_y <= BAR_Y_B) else
        '0';                                                     
    bar_rgb <= "010"; -- green                                   
    ---------------------------------------------
    -- square ball                               
    ---------------------------------------------
    -- pixel within square ball
    sq_ball_on <=                                                  
        '1' when (ball_x_l <= pix_x) and (pix_x <= ball_x_r) and 
                 (ball_y_t <= pix_y) and (pix_y <= ball_y_b) else
        '0';        
    -- map current pixel location to ROM addr/col
    rom_addr <= pix_y(2 downto 0) - ball_y_t(2 downto 0);
    rom_col  <= pix_x(2 downto 0) - ball_x_l(2 downto 0);
    rom_data <= BALL_ROM(to_integer(rom_addr));
    rom_bit  <= rom_data(to_integer(rom_col));
    rd_ball_on <=                                                
        '1' when (sq_ball_on = '1') and (rom_bit = '1') else
        '0';
    -- ball rgb output
    ball_rgb <= "100"; -- red                                 
    ---------------------------------------------
    -- rgb multiplexing circuit                               
    ---------------------------------------------
    rgb_proc: process (video_on, wall_on, bar_on, rd_ball_on,
                       wall_rgb, bar_rgb, ball_rgb)
    begin
        if (video_on = '0') then
            graph_rgb <= "000"; -- blank
        else 
            if (wall_on = '1') then
                graph_rgb <= wall_rgb;
            elsif (bar_on = '1') then
                graph_rgb <= bar_rgb;
            elsif (rd_ball_on = '1') then
                graph_rgb <= ball_rgb;
            else
                graph_rgb <= "110"; -- yellow background
            end if;
        end if;
    end process;

end Behavioral;
