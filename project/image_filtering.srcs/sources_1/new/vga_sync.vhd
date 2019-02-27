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

entity vga_sync is
    port ( 
        clk100, reset    : in std_logic;
        hsync, vsync     : out std_logic;
        video_on, p_tick : out std_logic;
        pixel_x, pixel_y : out std_logic_vector(9 downto 0) 
    );
end vga_sync;

architecture Behavioral of vga_sync is
  -- VGA 640x480 sync parameters
  constant HD : integer := 640; -- horizontal display area
  constant HF : integer := 16;  -- horizontal front porch (right b.)
  constant HB : integer := 48;  -- horizontal back porch (left b.)
  constant HR : integer := 96;  -- horizontal retrace
  constant VD : integer := 480; -- vertical display area
  constant VF : integer := 10;  -- vertical front porch (bottom b.)
  constant VB : integer := 33;  -- vertical back porch (top b.)
  constant VR : integer := 2;   -- vertical retrace
  -- mod-4 counter
  signal mod4_reg, mod4_next : unsigned(1 downto 0);
  -- sync counters
  signal v_count_reg, v_count_next : unsigned(9 downto 0);
  signal h_count_reg, h_count_next : unsigned(9 downto 0);
  -- output buffer
  signal v_sync_reg, v_sync_next : std_logic;
  signal h_sync_reg, h_sync_next : std_logic;
  -- status signal
  signal h_end, v_end, pixel_tick : std_logic;
begin
    -- registers
    Reg_proc: process (clk100, reset)
    begin
        if (reset = '0') then
            mod4_reg <= (others => '0');
            v_count_reg <= (others => '0');
            h_count_reg <= (others => '0');
            v_sync_reg <= '0';
            h_sync_reg <= '0';
        elsif (clk100'event and clk100 = '1') then
            mod4_reg <= mod4_next;
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
        end if;
    end process;
    -- mod-4 circuit to generate 25 MHz enable tick for the pixel rate
    Counter_4: process (mod4_reg)
    begin
        if (mod4_reg = "11") then
            mod4_next <= (others => '0');
        else
            mod4_next <= mod4_reg + 1;
        end if;
    end process;
    -- 25 MHz pixel tick
    pixel_tick <= '1' when (mod4_reg = "11") else '0';
    -- status
    h_end <= -- end of horizontal counter
        '1' when (h_count_reg = (HD+HF+HR+HB)) else -- 799
        '0';
    v_end <= -- end of vertical counter
        '1' when (v_count_reg = (VD+VF+VR+VB)) else -- 524
        '0';
    -- mod-800 horizontal sync counter
    Counter_800: process (h_count_reg, h_end, pixel_tick)
    begin
        if (pixel_tick = '1') then -- 25 MHz tick
            if (h_end = '1') then
                h_count_next <= (others => '0');
            else
                h_count_next <= h_count_reg + 1;
            end if;
        else 
            h_count_next <= h_count_reg;
        end if;
    end process;
    -- mod-525 vertical sync counter
    Counter_525: process (v_count_reg, h_end, v_end, pixel_tick)
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
    -- horizontal and vertical sync buffered to avoid glitches
    h_sync_next <= 
        '1' when (h_count_reg >= (HD+HF))          -- 656
            and (h_count_reg <= (HD+HF+HR-1)) else -- 751
        '0';
    v_sync_next <=                                       
        '1' when (v_count_reg >= (VD+VF))          -- 490
            and (h_count_reg <= (VD+VF+VR-1)) else -- 491
        '0';      
    -- video on/off
    video_on <= 
        '1' when (h_count_reg < HD and v_count_reg < VD) else
        '0';
    -- output signal
    hsync <= h_sync_reg;
    vsync <= v_sync_reg;
    pixel_x <= std_logic_vector(h_count_reg);
    pixel_y <= std_logic_vector(v_count_reg);
    p_tick <= pixel_tick;
end Behavioral;
