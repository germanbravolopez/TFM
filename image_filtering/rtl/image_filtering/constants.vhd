----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 21:58:55
-- Design Name: 
-- Module Name: constants - Behavioral
-- Project Name: 
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

package masks is
    --------------------------------------
    --   mask_11    mask_12   mask_13   --
    --   mask_21    mask_22   mask_23   --
    --   mask_31    mask_32   mask_33   --
    --------------------------------------
    --------------------------------------------------
    -- Deteccion de bordes: Laplaciano en punto aislado
    --------------------------------------------------
    constant mask0_11 : integer := -1; 
    constant mask0_12 : integer := -1;  
    constant mask0_13 : integer := -1; 
    
    constant mask0_21 : integer := -1; 
    constant mask0_22 : integer :=  8;  
    constant mask0_23 : integer := -1; 
    
    constant mask0_31 : integer := -1; 
    constant mask0_32 : integer := -1; 
    constant mask0_33 : integer := -1; 
   
    constant weight_sum0 : integer := 1;
    --------------------------------------------------
    -- Detección de bordes: Laplaciano
    --------------------------------------------------
    constant mask1_11 : integer := 0; 
    constant mask1_12 : integer := 1; 
    constant mask1_13 : integer := 0;
   
    constant mask1_21 : integer :=  1;
    constant mask1_22 : integer := -4;
    constant mask1_23 : integer :=  1;
    
    constant mask1_31 : integer := 0;
    constant mask1_32 : integer := 1;
    constant mask1_33 : integer := 0;
    
    constant weight_sum1 : integer := 1;
    --------------------------------------------------
    -- Detección de bordes: Sobel horizontal
    --------------------------------------------------
    constant mask2_11 : integer := -1; 
    constant mask2_12 : integer := -2; 
    constant mask2_13 : integer := -1;
    
    constant mask2_21 : integer := 0;
    constant mask2_22 : integer := 0;
    constant mask2_23 : integer := 0;
    
    constant mask2_31 : integer := 1;
    constant mask2_32 : integer := 2;
    constant mask2_33 : integer := 1;
    
    constant weight_sum2 : integer := 1;
    --------------------------------------------------
    -- Detección de bordes: Sobel vertical
    --------------------------------------------------
    constant mask3_11 : integer := -1; 
    constant mask3_12 : integer :=  0; 
    constant mask3_13 : integer :=  1;
    
    constant mask3_21 : integer := -2;
    constant mask3_22 : integer :=  0;
    constant mask3_23 : integer :=  2;
    
    constant mask3_31 : integer := -1;
    constant mask3_32 : integer :=  0;
    constant mask3_33 : integer :=  1;
    
    constant weight_sum3 : integer := 1;
    --------------------------------------------------
    -- Filtro paso alto: Sharpen, enfoque, nitidez
    --------------------------------------------------
    constant mask4_11 : integer :=  0; 
    constant mask4_12 : integer := -1; 
    constant mask4_13 : integer :=  0;
   
    constant mask4_21 : integer := -1;
    constant mask4_22 : integer :=  5;
    constant mask4_23 : integer := -1;
    
    constant mask4_31 : integer :=  0;
    constant mask4_32 : integer := -1;
    constant mask4_33 : integer :=  0;
    
    constant weight_sum4 : integer := 1;
    --------------------------------------------------
    -- Filtro paso bajo: Gaussiano, suavizado
    --------------------------------------------------
    constant mask5_11 : integer := 1; 
    constant mask5_12 : integer := 2; 
    constant mask5_13 : integer := 1;
  
    constant mask5_21 : integer := 2;
    constant mask5_22 : integer := 4;
    constant mask5_23 : integer := 2;
    
    constant mask5_31 : integer := 1;
    constant mask5_32 : integer := 2;
    constant mask5_33 : integer := 1;
    
    constant weight_sum5 : integer := 16;
    --------------------------------------------------
    -- Filtro Norte
    --------------------------------------------------
    constant mask6_11 : integer := 1; 
    constant mask6_12 : integer := 1; 
    constant mask6_13 : integer := 1;
  
    constant mask6_21 : integer :=  1;
    constant mask6_22 : integer := -2;
    constant mask6_23 : integer :=  1;
    
    constant mask6_31 : integer := -1;
    constant mask6_32 : integer := -1;
    constant mask6_33 : integer := -1;
    
    constant weight_sum6 : integer := 1;
    --------------------------------------------------
    -- Filtro Este
    --------------------------------------------------
    constant mask7_11 : integer := -1; 
    constant mask7_12 : integer :=  1; 
    constant mask7_13 : integer :=  1;
  
    constant mask7_21 : integer := -1;
    constant mask7_22 : integer := -2;
    constant mask7_23 : integer :=  1;
    
    constant mask7_31 : integer := -1;
    constant mask7_32 : integer :=  1;
    constant mask7_33 : integer :=  1;
    
    constant weight_sum7 : integer := 1;
    
end masks;

package vga_resolution is
    -- VGA 640x480 sync parameters -> 25 MHz pixel rate
    constant HD : integer := 640; -- horizontal display area
    constant HF : integer := 16;  -- horizontal front porch (right b.)
    constant HB : integer := 48;  -- horizontal back porch (left b.)
    constant HR : integer := 96;  -- horizontal retrace
    constant HM : integer := HD+HF+HB+HR - 1;
    
    constant VD : integer := 480; -- vertical display area
    constant VF : integer := 10;  -- vertical front porch (bottom b.)
    constant VB : integer := 33;  -- vertical back porch (top b.)
    constant VR : integer := 2;   -- vertical retrace
    constant VM : integer := VD+VF+VB+VR - 1;
    
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