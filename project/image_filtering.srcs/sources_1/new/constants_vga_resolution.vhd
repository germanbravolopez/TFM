library ieee;
use ieee.std_logic_1164.all;

package constants_vga_resolution is
    -- VGA 640x480 sync parameters -> 25MHz pixel rate
    constant HD : integer := 640; -- horizontal display area
    constant HF : integer := 16;  -- horizontal front porch (right b.)
    constant HB : integer := 48;  -- horizontal back porch (left b.)
    constant HR : integer := 96;  -- horizontal retrace
    constant VD : integer := 480; -- vertical display area
    constant VF : integer := 10;  -- vertical front porch (bottom b.)
    constant VB : integer := 33;  -- vertical back porch (top b.)
    constant VR : integer := 2;   -- vertical retrace
    
    -- VGA_1 800x600 sync parameters -> 50MHz pixel rate
    constant HD_1 : integer := 800; -- horizontal display area
    constant HF_1 : integer := 56;  -- horizontal front porch (right b.)
    constant HB_1 : integer := 64;  -- horizontal back porch (left b.)
    constant HR_1 : integer := 120;  -- horizontal retrace
    constant VD_1 : integer := 600; -- vertical display area
    constant VF_1 : integer := 37;  -- vertical front porch (bottom b.)
    constant VB_1 : integer := 23;  -- vertical back porch (top b.)
    constant VR_1 : integer := 6;   -- vertical retrace
    
end constants_vga_resolution;
