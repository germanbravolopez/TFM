----------------------------------------------------------------------------------
-- Company: Polytechnic University of Madrid
-- Engineer: Germ�n Bravo L�pez
-- 
-- Create Date: 20.02.2019 02:22:18
-- Design Name: VGA synchronization testing circuit with 3 switches
-- Module Name: vga_test_sw - Behavioral
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

use work.vga_resolution.all;

entity vga_test_sw is
    port ( 
        clk100, reset  : in std_logic;
        vga_resolution : in std_logic;
        sw             : in std_logic_vector(2 downto 0);
        hsync, vsync   : out std_logic;
        led            : out std_logic;
        rgb            : out std_logic_vector (2 downto 0)
    );
end vga_test_sw;

architecture Behavioral of vga_test_sw is
  
  component vga_sync
    port ( 
        clk100, reset    : in std_logic;
        vga_resolution   : in std_logic;
        hsync, vsync     : out std_logic;
        video_on, p_tick : out std_logic;
        pixel_x, pixel_y : out std_logic_vector(10 downto 0) 
    );
  end component;
  
  signal rgb_reg  : std_logic_vector(2 downto 0);
  signal video_on : std_logic;
  
begin
    -- instantiate VGA sync circuit
    vga_sync_unit: vga_sync
        port map (clk100 => clk100, reset => reset, hsync => hsync, vsync => vsync, 
                  video_on => video_on, p_tick => open, pixel_x => open, 
                  pixel_y => open, vga_resolution => vga_resolution);
    -- rgb buffer
    RGB_proc: process (clk100, reset, sw)
    begin
        if (reset = '0') then
            rgb_reg <= (others => '0');
        else 
            rgb_reg <= sw;
        end if;
    end process;
    rgb <= rgb_reg when (video_on = '1') else "000";
    
    led <= '1' when (sw(0) = '1') else '0';
end Behavioral;
