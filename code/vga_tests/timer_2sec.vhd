library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity timer_2sec is
    port (   
        clk100, reset              : in std_logic;
        timer_start, timer_tick : in std_logic; 
        timer_up                : out std_logic
    );
end timer_2sec;

architecture arch of timer_2sec is
  signal timer_reg, timer_next : unsigned(6 downto 0); 
begin
    -- registers
    process (clk100, reset) 
    begin
        if (reset='0') then
            timer_reg <= (others=>'1');
        elsif (clk100'event and clk100='1') then 
            timer_reg <= timer_next;
        end if; 
    end process;
    -- next-state logic
    process (timer_start, timer_reg, timer_tick) 
    begin
        if (timer_start='1') then 
            timer_next  <= (others=>'1');
        elsif (timer_tick='1' and timer_reg/=0) then
            timer_next <= timer_reg - 1;
        else
            timer_next <= timer_reg;
        end if; 
    end process;
    -- output logic
    timer_up <= '1' when timer_reg=0 else   
                '0'; 
end arch;