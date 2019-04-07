library ieee;
use ieee.std_logic_1164.all;

entity tb_pong_top_animated_test is
--  Port ( );
end tb_pong_top_animated_test;

architecture Testbench of tb_pong_top_animated_test is
  -- Test's component
  component pong_top_animated_test is
    port ( 
        reset, clk100 : in std_logic;                   
        sw            : in std_logic;                   
        btn           : in std_logic_vector(1 downto 0);
        hsync, vsync  : out std_logic;                  
        led           : out std_logic_vector(1 downto 0);                  
        rgb           : out std_logic_vector(2 downto 0)
    );
  end component;
  
  signal clk100, reset, hsync, vsync, sw : std_logic;
  signal btn, led : std_logic_vector(1 downto 0);
  signal rgb : std_logic_vector(2 downto 0);
  
  constant period : time := 10 ns;
begin
  -- Unit under test
  UUT: pong_top_animated_test
    port map ( clk100 => clk100, reset => reset, hsync => hsync, vsync => vsync, rgb => rgb, 
               sw => sw, btn => btn, led => led);
    
    -- Reset
    Reset_proc: process
    begin
        reset <= '1', '0' after 302 ns;
        wait;
    end process;
    
    -- CLK
    Clk_proc: process
    begin
        clk100 <= '0', '1' after period/2;
        wait for period;
    end process;
    
    -- Input data
    Input_proc: process
    begin
        sw <= '0', '1' after 1000 ns;
        wait;
    end process;

end Testbench;
