library ieee;
use ieee.std_logic_1164.all;

package constants_lcse_test is 

-- Revisar
    constant BLOCKS_WIDE    : integer := 30; -- 30 cuadros en la horizontal
    constant BLOCKS_HIGH    : integer := 22; -- 22 cuadros en la vertical

-- Cambiar colores si tenemos 12 bits....
    constant black   : std_logic_vector(5 downto 0) := "000000";
    constant blue    : std_logic_vector(5 downto 0) := "000011";
    constant green   : std_logic_vector(5 downto 0) := "001100";
    constant cyan    : std_logic_vector(5 downto 0) := "001111";
    constant red     : std_logic_vector(5 downto 0) := "110000";
    constant magenta : std_logic_vector(5 downto 0) := "110011";
    constant yellow  : std_logic_vector(5 downto 0) := "111100";
    constant white   : std_logic_vector(5 downto 0) := "111111";
    constant orange  : std_logic_vector(5 downto 0) := "110100";
    constant gray    : std_logic_vector(5 downto 0) := "010101";

    constant VD : std_logic_vector(9 downto 0):= "0111100000"; -- 480
    constant HD : std_logic_vector(9 downto 0):= "1010000000"; -- 640

    constant hsync_li  : std_logic_vector(9 downto 0):= "1010001111"; -- 655
    constant hsync_ls  : std_logic_vector(9 downto 0):= "1011101111"; -- 751
    constant hsync_max : std_logic_vector(9 downto 0):= "1100011111"; -- 799

    constant vsync_li  : std_logic_vector(9 downto 0):= "0111101001"; -- 489
    constant vsync_ls  : std_logic_vector(9 downto 0):= "0111101011"; -- 491
    constant vsync_max : std_logic_vector(9 downto 0):= "1000001100"; -- 524

end constants_lcse_test;