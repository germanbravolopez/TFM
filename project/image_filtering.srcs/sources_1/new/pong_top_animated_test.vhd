----------------------------------------------------------------------------------
-- Company: Polytechnic University of Madrid
-- Engineer: Germán Bravo López
-- 
-- Create Date: 02.03.2019 16:38
-- Design Name: Top for the pong animated test
-- Module Name: pong_top_animated_test - Behavioral
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

entity pong_top_animated_test is
    port ( 
        reset, clk100  : in std_logic;
        vga_resolution : in std_logic;
        sw             : in std_logic_vector(1 downto 0);
        btn            : in std_logic_vector(1 downto 0);
        hsync, vsync   : out std_logic;
        led            : out std_logic_vector(2 downto 0);
        rgb            : out std_logic_vector(2 downto 0)
    );
end pong_top_animated_test;

architecture Behavioral of pong_top_animated_test is

  component vga_sync
    port ( 
        clk100, reset    : in std_logic;
        vga_resolution   : in std_logic;
        hsync, vsync     : out std_logic;
        video_on, p_tick : out std_logic;
        pixel_x, pixel_y : out std_logic_vector(10 downto 0) 
    );
  end component;
  
  component pong_graph_animated_test
    port ( 
        clk100, reset, video_on : in std_logic;
        sw                      : in std_logic_vector(1 downto 0);
        btn                     : in std_logic_vector(1 downto 0);
        pixel_x, pixel_y        : in std_logic_vector(10 downto 0);
        graph_rgb               : out std_logic_vector(2 downto 0)
    );
  end component;
  
  signal pixel_x, pixel_y     : std_logic_vector(10 downto 0);
  signal video_on, pixel_tick : std_logic;
  signal rgb_reg, rgb_next    : std_logic_vector(2 downto 0);
  
begin
    -- instantiate VGA sync
    vga_sync_unit: vga_sync                                            
        port map (clk100 => clk100, reset => reset, hsync => hsync, vsync => vsync,
                  video_on => video_on, p_tick => pixel_tick, pixel_x => pixel_x,           
                  pixel_y => pixel_y, vga_resolution => vga_resolution); 
    -- instantiate graphic generator 
    pong_graph_animated_unit: pong_graph_animated_test                                            
                      port map (clk100 => clk100, reset => reset, btn => btn, sw => sw,
                                video_on => video_on, pixel_x => pixel_x, pixel_y => pixel_y,
                                graph_rgb => rgb_next); 
    -- rgb buffer
    rgb_buff: process (clk100)
    begin
        if (clk100'event and clk100 = '1') then
            if (pixel_tick = '1') then
                rgb_reg <= rgb_next;
            end if;
        end if;
    end process;
    rgb <= rgb_reg;
    
    led(0) <= sw(0); -- start
    led(1) <= sw(1); -- velocity selection (levels of difficulty)
    led(2) <= btn(0) or btn (1); -- buttons for moving the right bar
    
end Behavioral;
