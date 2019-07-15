library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.colors.all;

entity pong_graph_animated_test is
    port ( 
        clk100, reset, video_on : in std_logic;
        sw                      : in std_logic_vector(1 downto 0);
        btn                     : in std_logic_vector(1 downto 0);
        pixel_x, pixel_y        : in std_logic_vector(10 downto 0);
        graph_rgb               : out std_logic_vector(11 downto 0)
    );
end pong_graph_animated_test;

architecture Behavioral of pong_graph_animated_test is
  signal refr_tick    : std_logic;
  -- x, y, coordinates (0,0) to (639, 479)
  signal pix_x, pix_y : unsigned(10 downto 0);
  constant MAX_X : integer := 640;
  constant MAX_Y : integer := 480;
  ---------------------------------------------
  -- vertical stripe as a wall
  ---------------------------------------------
  -- wall left, right boundary
  constant WALL_X_L : integer := 32;
  constant WALL_X_R : integer := 35;
  ---------------------------------------------
  -- right paddle bar
  ---------------------------------------------
  constant BAR_Y_SIZE : integer := 72;
  -- bar left, right boundary
  constant BAR_X_L : integer := 600;
  constant BAR_X_R : integer := 603;
  -- bar top, bottom boundary
  constant BAR_Y_T_cte : integer := MAX_Y/2 - BAR_Y_SIZE/2; -- 204
  constant BAR_Y_B_cte : integer := BAR_Y_T_cte + BAR_Y_SIZE - 1;
  signal bar_y_t : unsigned(10 downto 0);-- := to_unsigned(BAR_Y_T_cte,10);
  signal bar_y_b : unsigned(10 downto 0);-- := to_unsigned(BAR_Y_B_cte,10);
  -- reg to track top boundary (x position is fixed)
  signal bar_y_reg, bar_y_next : unsigned(10 downto 0);
  -- bar moving velocity when a button is pressed
  signal BAR_V : integer;-- := 2;
  ---------------------------------------------
  -- square ball                        
  ---------------------------------------------
  constant BALL_SIZE : integer := 8;
  -- ball left, right boundary                                  
  constant BALL_X_L_cte : integer := 580;                           
  constant BALL_X_R_cte : integer := BALL_X_L_cte + BALL_SIZE - 1; 
  signal ball_x_l : unsigned(10 downto 0);-- := to_unsigned(BALL_X_L_cte,10);
  signal ball_x_r : unsigned(10 downto 0);-- := to_unsigned(BALL_X_R_cte,10);                          
  -- ball top, bottom boundary                                  
  constant BALL_Y_T_cte : integer := 238; 
  constant BALL_Y_B_cte : integer := BALL_Y_T_cte + BALL_SIZE - 1; 
  signal ball_y_t : unsigned(10 downto 0);-- := to_unsigned(BALL_Y_T_cte,10);    
  signal ball_y_b : unsigned(10 downto 0);-- := to_unsigned(BALL_Y_B_cte,10);
  -- reg to track left, top boundaries
  signal ball_x_reg, ball_x_next : unsigned(10 downto 0);
  signal ball_y_reg, ball_y_next : unsigned(10 downto 0);   
  -- reg to track ball speed
  signal x_delta_reg, x_delta_next : unsigned (10 downto 0);
  signal y_delta_reg, y_delta_next : unsigned (10 downto 0);  
  -- ball velocity can be positive or negative
  signal BALL_V_P : unsigned(10 downto 0);-- := to_unsigned(1,10); -- signals for change vel 
  signal BALL_V_N : unsigned(10 downto 0);-- := unsigned(to_signed(-1,10));
  ---------------------------------------------
  -- round ball image ROM                          
  ---------------------------------------------
  type rom_type is array (0 to 7) of std_logic_vector(0 to 7);
  -- ROM definition
  constant BALL_ROM: rom_type := 
  (
      "00111100", --   ****
      "01111110", --  ******
      "11111111", -- ********
      "11111111", -- ********
      "11111111", -- ********
      "11111111", -- ********
      "01111110", --  ******
      "00111100"  --   ****
  );
  signal rom_addr, rom_col : unsigned(2 downto 0);
  signal rom_data          : std_logic_vector(7 downto 0);
  signal rom_bit           : std_logic;
  ---------------------------------------------                     
  -- object output signals                                                 
  ---------------------------------------------                     
  signal wall_on, bar_on, sq_ball_on, rd_ball_on : std_logic;                   
  signal wall_rgb, bar_rgb, ball_rgb : std_logic_vector(11 downto 0);
  
begin
    -- registers
    reg_proc: process (clk100, reset)
    begin
        if (reset = '0') then
            bar_y_reg <= to_unsigned(BAR_Y_T_cte,11);
            ball_x_reg <= to_unsigned(BALL_X_L_cte,11);
            ball_y_reg <= to_unsigned(BALL_Y_T_cte,11);
            x_delta_reg <= ("00000000100");
            y_delta_reg <= ("00000000100");
        elsif (clk100'event and clk100 = '1') then
            bar_y_reg <= bar_y_next;
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
        end if;
    end process;
    
    pix_x <= unsigned(pixel_x);
    pix_y <= unsigned(pixel_y);
    -- refr_tick : 1 - clock tick asserted at start of v-sync
    --      i.e., when the screen is refreshed (60 Hz)
    refr_tick <= '1' when (sw(0) = '1') and (pix_y = 481) and (pix_x = 0) else
                 '0';              
    
    ---------------------------------------------
    -- left vertical stripe (wall)                      
    ---------------------------------------------
    wall_on <= 
        '1' when (WALL_X_L <= pix_x) and (pix_x <= WALL_X_R) else
        '0';
    wall_rgb <= blue; -- blue
    
    ---------------------------------------------
    -- right vertical stripe                               
    ---------------------------------------------
    -- boundary
    bar_y_t <= bar_y_reg;
    bar_y_b <= bar_y_t + BAR_Y_SIZE - 1;
    -- pixel within bar
    bar_on <=                                                   
        '1' when (BAR_X_L <= pix_x) and (pix_x <= BAR_X_R) and 
                 (bar_y_t <= pix_y) and (pix_y <= bar_y_b) else
        '0';                                                     
    bar_rgb <= green; -- green    
    -- new bar y-position
    bar_mov_proc: process (bar_y_reg, bar_y_b, bar_y_t, refr_tick, btn, sw,
                           BAR_V, BALL_V_N, BALL_V_P)
    begin
        bar_y_next <= bar_y_reg; -- no move
        if (refr_tick = '1') then
            if (btn(1) = '1') and (bar_y_b < (MAX_Y - 1 - BAR_V)) then
                bar_y_next <= bar_y_reg + BAR_V; -- move down
            elsif (btn(0) = '1') and (bar_y_t > BAR_V) then
                bar_y_next <= bar_y_reg - BAR_V; -- move up
            end if;
        end if;
    end process;                               
    
    ---------------------------------------------
    -- square ball                               
    ---------------------------------------------
    -- boundary
    ball_x_l <= ball_x_reg;
    ball_y_t <= ball_y_reg;
    ball_x_r <= ball_x_l + BALL_SIZE - 1;
    ball_y_b <= ball_y_t + BALL_SIZE - 1;
    -- pixel within square ball
    sq_ball_on <=                                                
        '1' when (ball_x_l <= pix_x) and (pix_x <= ball_x_r) and 
                 (ball_y_t <= pix_y) and (pix_y <= ball_y_b) else
        '0';                                                            
    -- map current pixel location to ROM addr/col
    rom_addr <= pix_y(2 downto 0) - ball_y_t(2 downto 0);
    rom_col  <= pix_x(2 downto 0) - ball_x_l(2 downto 0);
    rom_data <= BALL_ROM(to_integer(rom_addr));
    rom_bit  <= rom_data(to_integer(rom_col));
    rd_ball_on <=                                                
        '1' when (sq_ball_on = '1') and (rom_bit = '1') else
        '0';
    -- ball rgb output
    ball_rgb <= red; -- red 
    
    -- velocity selector
    BALL_V_P <= to_unsigned(1,11) when (sw(1) = '0') else
                to_unsigned(2,11);
    BALL_V_N <= unsigned(to_signed(-1,11)) when (sw(1) = '0') else
                unsigned(to_signed(-2,11));
    BAR_V    <= 2 when (sw(1) = '0') else
                4;
    
    -- new ball position
    ball_x_next <= ball_x_reg + x_delta_reg when (refr_tick = '1') else
                   ball_x_reg;                                
    ball_y_next <= ball_y_reg + y_delta_reg when (refr_tick = '1') else
                   ball_y_reg;    
    -- new ball velocity
    ball_vel_proc: process (x_delta_reg, y_delta_reg, ball_x_l, ball_x_r, 
                            ball_y_t, ball_y_b, bar_y_t, bar_y_b, sw, 
                            BALL_V_P, BALL_V_N, BAR_V)
    begin
        x_delta_next <= x_delta_reg;
        y_delta_next <= y_delta_reg;
        if (ball_y_t < 1) then -- reach top
            y_delta_next <= BALL_V_P;
        elsif (ball_y_b > (MAX_Y - 1)) then -- reach bottom
            y_delta_next <= BALL_V_N;
        elsif (ball_x_l <= WALL_X_R) then -- reach wall
            x_delta_next <= BALL_V_P;     -- bounce back
        elsif (BAR_X_L <= ball_x_r) and (ball_x_r <= BAR_X_R) then 
        -- reach x of right bar    
            if (bar_y_t <= ball_y_b) and (ball_y_t <= bar_y_b) then
                x_delta_next <= BALL_V_N; --hit, bounce back
            end if;
        end if;
    end process;
    
    ---------------------------------------------
    -- rgb multiplexing circuit                               
    ---------------------------------------------
    rgb_proc: process (video_on, wall_on, bar_on, rd_ball_on,
                       wall_rgb, bar_rgb, ball_rgb)
    begin
        if (video_on = '0') then
            graph_rgb <= black; -- blank
        else 
            if (wall_on = '1') then
                graph_rgb <= wall_rgb;
            elsif (bar_on = '1') then
                graph_rgb <= bar_rgb;
            elsif (rd_ball_on = '1') then
                graph_rgb <= ball_rgb;
            else
                graph_rgb <= yellow; -- yellow background
            end if;
        end if;
    end process;

end Behavioral;
