library ieee;
use ieee.std_logic_1164.all;

entity tb_pong_top_test is
--  Port ( );
end tb_pong_top_test;

architecture Testbench of tb_pong_top_test is
  -- Test's component
  component pong_top_test is
    port ( 
        reset, clk100 : in std_logic;
        hsync, vsync  : out std_logic;
        rgb           : out std_logic_vector(2 downto 0)
    );
  end component;
  
  signal clk100, reset, hsync, vsync : std_logic;
  signal rgb                         : std_logic_vector(2 downto 0);
  
  constant period : time := 10 ns;
begin
  -- Unit under test
  UUT: pong_top_test
    port map ( clk100 => clk100, reset => reset, hsync => hsync, 
               vsync => vsync, rgb => rgb );
    
    -- Reset
    Reset_proc: process
    begin
        reset <= '0', '1' after 302 ns;
        wait;
    end process;
    
    -- CLK
    Clk_proc: process
    begin
        clk100 <= '0', '1' after period/2;
        wait for period;
    end process;

end Testbench;
