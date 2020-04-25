----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:09:29
-- Design Name: 
-- Module Name: vga - Behavioral
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
use ieee.numeric_std.all;

use work.vga_resolution.all;

entity vga is
    Port ( 
   	    clk25mhz    : IN std_logic;  
        reset       : IN std_logic;
        hsync       : OUT std_logic;
        vsync       : OUT std_logic;
        area_activa : OUT std_logic;
        
        pixel_x     : out integer;
        pixel_y     : out integer
    );	
end vga;

architecture rtl of vga is

    signal h_cont : integer := 0;		
    signal v_cont : integer := 0;

begin

	proc_area_act: process(clk25mhz, reset)
		begin
		    if (reset='0') then
		        h_cont <= 0;
		        v_cont <= 0;
		        area_activa <= '0';
			elsif (clk25mhz'event and clk25mhz='1') then
                if (h_cont = HM) then
                    h_cont <= 0;
                    if (v_cont = VM) then
                        v_cont <= 0;
                        area_activa <= '1';
                    else
                        if (v_cont < (VD-1)) then
                            area_activa <= '1';
                        end if;
                        v_cont <= v_cont+1;
                    end if;
                else
                    if (h_cont = (HD-1)) then
                        area_activa <= '0';
                    end if;
                    h_cont <= h_cont + 1;
                end if;
			end if;
		end process;
		
    pixel_x <= h_cont;
    pixel_y <= v_cont;

	h_sync: process(clk25mhz, reset)
		begin
		    if (reset='0') then
		        hsync <= '0';
			elsif (clk25mhz'event and clk25mhz='1') then
				if (h_cont >= (HD+HF) and h_cont <= (HD+HF+HR-1)) then   -- 656 and 751
					hsync <= '0';
				else
					hsync <= '1';
				end if;
			end if;
		end process;

	v_sync: process(clk25mhz, reset)
		begin
		    if (reset='0') then
		        vsync <= '0';
			elsif (clk25mhz'event and clk25mhz='1') then
				if (v_cont >= (VD+VF) and v_cont <= (VD+VF+VR-1)) then  -- 490 and 491
					vsync <= '0';
				else
					vsync <= '1';
				end if;
			end if;
		end process;
end rtl;