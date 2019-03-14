library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants_vga_resolution.all;

entity tb_vga_test_sw is
--  Port ( );
end tb_vga_test_sw;

architecture Testbench of tb_vga_test_sw is
  -- Test's component
  component vga_test_sw is
    port ( 
        clk100, reset : in std_logic;
        sw            : in std_logic_vector(2 downto 0);
        vga_resolution: in std_logic;
        hsync, vsync  : out std_logic;
        rgb           : out std_logic_vector (2 downto 0)
    );
  end component;
  
  signal clk100, reset, hsync, vsync, vga_resolution : std_logic;
  signal sw, rgb                     : std_logic_vector(2 downto 0);
  
  constant period : time := 10 ns;
begin
  -- Unit under test
  UUT: vga_test_sw
    port map ( clk100 => clk100, reset => reset, sw => sw, hsync => hsync, 
               vsync => vsync, rgb => rgb, vga_resolution => vga_resolution );
    
    -- Reset
    Reset_proc: process
    begin
        reset <= '1', '0' after 302 ns, '1' after 65 ms, '0' after 65000302 ns;
        wait;
    end process;
    
    -- CLK
    Clk_proc: process
    begin
        clk100 <= '0', '1' after period/2;
        wait for period;
    end process;
    
    -- Input data
    In_proc: process
    begin
        vga_resolution <= '0';
        sw <= "010"; wait for 20ms;
        sw <= "001"; wait for 20ms;
        vga_resolution <= '1'; wait for 40 ms;
        sw <= "101"; wait;
--        sw <= "001"; wait for 10*period;
--        sw <= "010"; wait for 10*period;
--        sw <= "011"; wait for 10*period;
--        sw <= "100"; wait for 10*period;
--        sw <= "101"; wait for 10*period;
--        sw <= "110"; wait for 10*period;
--        sw <= "111"; wait for 10*period;
    end process;

end Testbench;
