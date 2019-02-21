
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity vgacontroller is
  port(
    clk100   : in  std_logic;
    rst_n    : in  std_logic;
    video_on : out std_logic;
    hsync    : out std_logic;
    vsync    : out std_logic;
    px_x     : out std_logic_vector(9 downto 0);
    px_y     : out std_logic_vector(9 downto 0)
    );
end vgacontroller;

architecture arq of vgacontroller is

  signal contador_reloj : integer range 0 to 4;

  signal contador_vsync : std_logic_vector(9 downto 0);
  signal contador_hsync : std_logic_vector(9 downto 0);
  signal enable         : std_logic;

  constant factor : integer := 3;

begin

  reloj25 : process(clk100, rst_n)
  begin

    if (rst_n = '0') then
      enable         <= '0';
      contador_reloj <= 0;

    elsif (rising_edge(clk100)) then
      if (contador_reloj >= factor) then
        enable         <= '1';
        contador_reloj <= 0;
      else
        enable         <= '0';
        contador_reloj <= (contador_reloj + 1);

      end if;
    end if;
  end process reloj25;

  hsync_px_x : process(clk100, rst_n, enable)

  begin
    if (rst_n = '0') then
      hsync          <= '1';
      contador_hsync <= "0000000000";

    elsif (rising_edge(clk100) and (enable = '1')) then
      if (contador_hsync = hsync_max) then
        hsync          <= '1';
        contador_hsync <= "0000000000";

      elsif ((contador_hsync > hsync_li) and (contador_hsync < hsync_ls)) then
        hsync          <= '0';
        contador_hsync <= std_logic_vector(unsigned(contador_hsync) + "0000000001");

      else
        hsync          <= '1';
        contador_hsync <= std_logic_vector(unsigned(contador_hsync) + "0000000001");
      end if;
    end if;
  end process hsync_px_x;

  vsync_px_y : process(clk100, rst_n, contador_hsync, enable)

  begin
    if (rst_n = '0') then
      vsync          <= '1';
      contador_vsync <= "0000000000";

    elsif (rising_edge(clk100) and (enable = '1') and (contador_hsync >= hsync_max)) then

      if (contador_vsync = vsync_max) then
        vsync          <= '1';
        contador_vsync <= "0000000000";

      elsif ((contador_vsync > vsync_li) and (contador_vsync < vsync_ls)) then
        vsync          <= '0';
        contador_vsync <= std_logic_vector(unsigned(contador_vsync) + "0000000001");

      else
        vsync          <= '1';
        contador_vsync <= std_logic_vector(unsigned(contador_vsync) + "0000000001");
      end if;
    end if;
  end process vsync_px_y;

  px_x <= contador_hsync;

  px_y <= contador_vsync;

  video_on <= '1' when (contador_vsync < VD and contador_hsync < HD) else '0';

end arq;
