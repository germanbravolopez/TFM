----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:16:21
-- Design Name: 
-- Module Name: ov7670_capture - Behavioral
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

entity ov7670_capture is
    Port ( 
        pclk  : in   STD_LOGIC;
        vsync : in   STD_LOGIC;
        href  : in   STD_LOGIC;
        d     : in   STD_LOGIC_VECTOR (7 downto 0);
        addr  : out  STD_LOGIC_VECTOR (18 downto 0);
        dout  : out  STD_LOGIC_VECTOR (11 downto 0);
        we    : out  STD_LOGIC
    );
end ov7670_capture;

architecture rtl of ov7670_capture is

    signal d_latch       : std_logic_vector(15 downto 0) := (others => '0');
    signal address       : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    signal href_last     : std_logic_vector(6 downto 0)  := (others => '0');
    signal we_reg        : std_logic := '0';
    signal latched_vsync : STD_LOGIC := '0';
    signal latched_href  : STD_LOGIC := '0';
    signal latched_d     : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
begin
    addr <= address;
    we   <= we_reg;
    dout <= d_latch(15 downto 12) & d_latch(10 downto 7) & d_latch(4 downto 1); 
--    dout <= d_latch(15 downto 12) & d_latch(11 downto 8) & d_latch(7 downto 4);
        -- This is a bit tricky href starts a pixel transfer that takes 3 cycles
        --        Input   | state after clock tick   
        --         href   | wr_hold    d_latch              dout            we  address  address_next
        -- cycle -1  x    |    xx      xxxx.xxxx.xxxx.xxxx  xxxx.xxxx.xxxx  x    xxxx     xxxx
        -- cycle 0   1    |    x1      xxxx.xxxx.RRRR.RGGG  xxxx.xxxx.xxxx  x    xxxx     addr
        -- cycle 1   0    |    10      RRRR.RGGG.GGGB.BBBB  xxxx.xxxx.xxxx  x    addr     addr
        -- cycle 2   x    |    0x      GGGB.BBBB.xxxx.xxxx  RRRR.GGGG.BBBB  1    addr     addr+1    
    capture_process: process(pclk)
    begin
       if (pclk'event and pclk='1') then
          if (we_reg = '1') then
             address <= std_logic_vector(unsigned(address)+1);
          end if;
          if (latched_href = '1') then
             d_latch <= d_latch( 7 downto 0) & latched_d;
          end if;
          we_reg  <= '0';
          -- Is a new screen about to start (i.e. we have to restart capturing)
          if (latched_vsync = '1') then 
             address      <= (others => '0');
             href_last    <= (others => '0');
          else
            if (href_last(0)='1') then
                we_reg <= '1';
                href_last <= (others => '0');
            else 
                href_last <= href_last(href_last'high-1 downto 0) & latched_href;
            end if;
          end if;
       end if;
       if (pclk'event and pclk='0') then
          latched_d     <= d;
          latched_href  <= href;
          latched_vsync <= vsync;
       end if;
    end process;
end rtl;
