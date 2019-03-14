----------------------------------------------------------------------------------
-- Company: Polytechnic University of Madrid
-- Engineer: Germán Bravo López
-- 
-- Create Date: 20.02.2019 01:31:28
-- Design Name: VGA synchronization circuit
-- Module Name: vga_sync - Behavioral
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

use work.constants_vga_resolution.all;

entity vga_sync is
    port ( 
        clk100, reset    : in std_logic;
        vga_resolution   : in std_logic;
        hsync, vsync     : out std_logic;
        video_on, p_tick : out std_logic;
        pixel_x, pixel_y : out std_logic_vector(10 downto 0) 
    );
end vga_sync;

architecture Behavioral of vga_sync is
  
  -- mod-2 counter
  signal mod2_reg, mod2_next : std_logic;
  -- mod-4 counter
  signal mod4_reg, mod4_next : unsigned(1 downto 0);
  
  -- sync counters
  signal v_count_reg, v_count_next : unsigned(10 downto 0);
  signal h_count_reg, h_count_next : unsigned(10 downto 0);
  
  -- output buffer
  signal v_sync_reg, v_sync_next : std_logic;
  signal h_sync_reg, h_sync_next : std_logic;
  
  -- status signal
  signal h_end, v_end, pixel_tick : std_logic;
  
begin
    -- mod-2 circuit to generate 50 MHz enable tick for the pixel rate
    mod2_next <= not mod2_reg when (vga_resolution = '1') else
                 '0' when (vga_resolution = '0') else
                 mod2_reg;
    -- mod-4 circuit to generate 25 MHz enable tick for the pixel rate
    Counter_4: process (mod4_reg, vga_resolution)
    begin
        if (mod4_reg = "11" or vga_resolution = '1') then
            mod4_next <= (others => '0');
        elsif (vga_resolution = '0') then
            mod4_next <= mod4_reg + 1;  
        else 
            mod4_next <= mod4_reg;
        end if;
    end process;
    
    -- mod horizontal sync counter
    Counter_800_1040: process (h_count_reg, h_end, pixel_tick)
    begin
        if (pixel_tick = '1') then
            if (h_end = '1') then
                h_count_next <= (others => '0');
            else
                h_count_next <= h_count_reg + 1;
            end if;
        else 
            h_count_next <= h_count_reg;
        end if;
    end process;
    
    -- mod vertical sync counter
    Counter_525_666: process (v_count_reg, h_end, v_end, pixel_tick)
    begin
        if (pixel_tick = '1' and h_end = '1') then
            if (v_end = '1') then
                v_count_next <= (others => '0');
            else
                v_count_next <= v_count_reg + 1;
            end if;
        else 
            v_count_next <= v_count_reg;
        end if;
    end process;

    -- registers
    Reg_proc: process (clk100, reset)
    begin
        if (reset = '0') then
            mod2_reg <= '0';
            mod4_reg <= (others => '0');
            v_count_reg <= (others => '0');
            h_count_reg <= (others => '0');
            v_sync_reg <= '0';
            h_sync_reg <= '0';
        elsif (clk100'event and clk100 = '1') then
            mod2_reg <= mod2_next;
            mod4_reg <= mod4_next;
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
        end if;
    end process;

    -- pixel tick generation
    pixel_tick <= '1' when (vga_resolution = '0' and mod4_reg = "11") else
                  '1' when (vga_resolution = '1' and mod2_reg = '1') else
                  '0';    
    -- status
    h_end <= -- end of horizontal counter
        '1' when ((h_count_reg = (HD+HF+HR+HB-1)) and vga_resolution = '0') else -- 799
        '1' when ((h_count_reg = (HD_1+HF_1+HR_1+HB_1-1)) and vga_resolution = '1') else -- 1039
        '0';
    v_end <= -- end of vertical counter
        '1' when ((v_count_reg = (VD+VF+VR+VB-1)) and vga_resolution = '0') else -- 524
        '1' when ((v_count_reg = (VD_1+VF_1+VR_1+VB_1-1)) and vga_resolution = '1') else -- 665
        '0';                                         

    -- horizontal and vertical sync buffered to avoid glitches
    h_sync_next <= 
        '1' when ((h_count_reg >= (HD+HF)) and (h_count_reg <= (HD+HF+HR-1)) and (vga_resolution = '0')) else -- 656_751
        '1' when ((h_count_reg >= (HD_1+HF_1)) and (h_count_reg <= (HD_1+HF_1+HR_1-1)) and (vga_resolution = '1')) else -- 864_983
        '0';
    v_sync_next <=                                       
        '1' when ((v_count_reg >= (VD+VF)) and (v_count_reg <= (VD+VF+VR-1)) and (vga_resolution = '0')) else -- 490_491
        '1' when ((v_count_reg >= (VD_1+VF_1)) and (v_count_reg <= (VD_1+VF_1+VR_1-1)) and (vga_resolution = '1')) else -- 622_627
        '0';      
        
    -- video on/off
    video_on <= 
        '1' when ((h_count_reg < HD and v_count_reg < VD) and vga_resolution = '0') else
        '1' when ((h_count_reg < HD_1 and v_count_reg < VD_1) and vga_resolution = '1') else
        '0';
        
    -- output signal
    hsync <= h_sync_reg;
    vsync <= v_sync_reg;
    pixel_x <= std_logic_vector(h_count_reg);
    pixel_y <= std_logic_vector(v_count_reg);
    p_tick <= pixel_tick;
    
end Behavioral;
