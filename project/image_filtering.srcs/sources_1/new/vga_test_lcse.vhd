----------------------------------------------------------------------------------
-- Company: Polytechnic University of Madrid
-- Engineer: Germán Bravo López
-- 
-- Create Date: 20.02.2019 02:22:18
-- Design Name: VGA synchronization testing circuit with LCSE project
-- Module Name: vga_test_lcse - Behavioral
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

entity vga_test_lcse is
    port ( 
        clk100, reset : in std_logic;
        hsync, vsync  : out std_logic;
        rgb           : out std_logic_vector (5 downto 0)
    );
end vga_test_lcse;

architecture Behavioral of vga_test_lcse is
  signal video_on         : std_logic;
  signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
  signal temperatura, actuadores, leds : std_logic_vector(7 downto 0);
begin
    -- instantiate VGA sync circuit
    vga_sync_unit: entity work.vga_sync
        port map (clk100 => clk100, reset => reset, hsync => hsync, vsync => vsync, 
                  video_on => video_on, p_tick => open, pixel_x => pixel_x, 
                  pixel_y => pixel_y);
    -- instantiate VGA graphics lcse
    graphics_unit: entity work.graphics_lcse_test
        port map (video_on => video_on, pixel_x => pixel_x, pixel_y => pixel_y,
                  rgb => rgb, temperatura => temperatura, actuadores => actuadores,
                  leds => leds);
                  
    -- Temperatura, actuadores y leds
    value: process(reset)
    begin
        if (reset = '0') then
            temperatura <= "00011000"; -- 18 grados
            actuadores  <= "01011001";
            leds        <= "00100101";
        end if;
    end process;
    
end Behavioral;
