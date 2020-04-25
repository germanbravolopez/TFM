library ieee;
use ieee.std_logic_1164.all;

package colors is
-- (color)*15/255
    constant black   : std_logic_vector(11 downto 0) := "000000000000";
    constant white   : std_logic_vector(11 downto 0) := "111111111111";
    constant red     : std_logic_vector(11 downto 0) := "111100000000";
    constant green   : std_logic_vector(11 downto 0) := "000011110000";
    constant blue    : std_logic_vector(11 downto 0) := "000000001111";
    constant yellow  : std_logic_vector(11 downto 0) := "111111110000";
    constant cyan    : std_logic_vector(11 downto 0) := "000011111111";
    constant magenta : std_logic_vector(11 downto 0) := "111100001111";
    constant gray    : std_logic_vector(11 downto 0) := "100110011001";
    
    constant orange  : std_logic_vector(11 downto 0) := "111001000001";
    constant marron  : std_logic_vector(11 downto 0) := "011000110010";
    
end colors;

package vga_resolution is
    -- VGA 640x480 sync parameters -> 25 MHz pixel rate
    constant HD : integer := 640; -- horizontal display area
    constant HF : integer := 16;  -- horizontal front porch (right b.)
    constant HB : integer := 48;  -- horizontal back porch (left b.)
    constant HR : integer := 96;  -- horizontal retrace
    constant VD : integer := 480; -- vertical display area
    constant VF : integer := 10;  -- vertical front porch (bottom b.)
    constant VB : integer := 33;  -- vertical back porch (top b.)
    constant VR : integer := 2;   -- vertical retrace
    
    -- VGA_1 800x600 sync parameters -> 50 MHz pixel rate
    constant HD_1 : integer := 800; -- horizontal display area
    constant HF_1 : integer := 56;  -- horizontal front porch (right b.)
    constant HB_1 : integer := 64;  -- horizontal back porch (left b.)
    constant HR_1 : integer := 120;  -- horizontal retrace
    constant VD_1 : integer := 600; -- vertical display area
    constant VF_1 : integer := 37;  -- vertical front porch (bottom b.)
    constant VB_1 : integer := 23;  -- vertical back porch (top b.)
    constant VR_1 : integer := 6;   -- vertical retrace
    
    -- VGA_1 1920x1200 sync parameters -> 193.16 MHz pixel rate
--    constant HD_1 : integer := 1920; -- horizontal display area
--    constant HF_1 : integer := 128;  -- horizontal front porch (right b.)
--    constant HB_1 : integer := 336;  -- horizontal back porch (left b.)
--    constant HR_1 : integer := 208;  -- horizontal retrace
--    constant VD_1 : integer := 1200; -- vertical display area
--    constant VF_1 : integer := 1;  -- vertical front porch (bottom b.)
--    constant VB_1 : integer := 38;  -- vertical back porch (top b.)
--    constant VR_1 : integer := 3;   -- vertical retrace

    -- VGA_1 1024x768 sync parameters -> 65 MHz pixel rate
--    constant HD_1 : integer := 1024; -- horizontal display area
--    constant HF_1 : integer := 24;  -- horizontal front porch (right b.)
--    constant HB_1 : integer := 160;  -- horizontal back porch (left b.)
--    constant HR_1 : integer := 136;  -- horizontal retrace
--    constant VD_1 : integer := 768; -- vertical display area
--    constant VF_1 : integer := 3;  -- vertical front porch (bottom b.)
--    constant VB_1 : integer := 29;  -- vertical back porch (top b.)
--    constant VR_1 : integer := 6;   -- vertical retrace
    
end vga_resolution;

--package body constants_vga_resolution is
--end constants_vga_resolution;