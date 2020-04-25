----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:22:00
-- Design Name: 
-- Module Name: image_refresh - Behavioral
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

entity image_refresh is
    port(
        clk     : IN std_logic;
        btn     : IN std_logic;
        refres  : OUT std_logic
    );
end image_refresh;

architecture rtl of image_refresh is

    signal cont : unsigned(23 downto 0);

begin
	process(clk)
    begin
        if (clk'event and clk='1') then
            if (btn = '1') then
                if (cont = X"5F5E10") then --250ms, -- "FFFFFF") then
                    refres <= '1';
                else
                    refres <= '0';
                end if;
                cont <= cont+1;
            else
                cont <= (others => '0');
                refres <= '0';
            end if;
        end if;
    end process;

end rtl;
