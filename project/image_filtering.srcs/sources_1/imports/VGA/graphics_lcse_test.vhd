library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.constants_lcse_test.all;
use work.variables_lcse_test.all;

entity graphics_lcse_test is
  port(
    video_on    : in std_logic;
    pixel_x     : in std_logic_vector(9 downto 0);
    pixel_y     : in std_logic_vector(9 downto 0);

    temperatura : in std_logic_vector(7 downto 0);
    actuadores  : in std_logic_vector(7 downto 0);
    leds        : in std_logic_vector(7 downto 0);

    rgb : out std_logic_vector(5 downto 0)
    );
end graphics_lcse_test;

architecture arq of graphics_lcse_test is

  signal C_BLOCK : integer;
  signal CUR_BLK : integer;

  signal CUR_TempMSB_BLK  : integer;
  signal CUR_tempLSB_BLK  : integer;
  signal CUR_ActAddr_BLK  : integer;
  signal CUR_ActValue_BLK : integer;

  signal cur_pos_x : std_logic_vector(9 downto 0);
  signal cur_pos_y : std_logic_vector(9 downto 0);

  signal temperatura_MSB : std_logic_vector(3 downto 0);
  signal temperatura_LSB : std_logic_vector(3 downto 0);

  signal actuador_addr  : std_logic_vector(3 downto 0);
  signal actuador_value : std_logic_vector(3 downto 0);


  shared variable CUR_BLK1_Number  : integer := 999;
  shared variable CUR_BLK2_Number  : integer := 999;
  shared variable CUR_BLK3_Number  : integer := 999;
  shared variable CUR_BLK4_Number  : integer := 999;
  shared variable CUR_BLK5_Number  : integer := 999;
  shared variable CUR_BLK6_Number  : integer := 999;
  shared variable CUR_BLK7_Number  : integer := 999;
  shared variable CUR_BLK8_Number  : integer := 999;
  shared variable CUR_BLK9_Number  : integer := 999;
  shared variable CUR_BLK10_Number : integer := 999;
  shared variable CUR_BLK11_Number : integer := 999;
  shared variable CUR_BLK12_Number : integer := 999;
  shared variable CUR_BLK13_Number : integer := 999;

  shared variable CUR_TLSB_BLK1_Number  : integer := 999;
  shared variable CUR_TLSB_BLK2_Number  : integer := 999;
  shared variable CUR_TLSB_BLK3_Number  : integer := 999;
  shared variable CUR_TLSB_BLK4_Number  : integer := 999;
  shared variable CUR_TLSB_BLK5_Number  : integer := 999;
  shared variable CUR_TLSB_BLK6_Number  : integer := 999;
  shared variable CUR_TLSB_BLK7_Number  : integer := 999;
  shared variable CUR_TLSB_BLK8_Number  : integer := 999;
  shared variable CUR_TLSB_BLK9_Number  : integer := 999;
  shared variable CUR_TLSB_BLK10_Number : integer := 999;
  shared variable CUR_TLSB_BLK11_Number : integer := 999;
  shared variable CUR_TLSB_BLK12_Number : integer := 999;
  shared variable CUR_TLSB_BLK13_Number : integer := 999;

  shared variable CUR_AD_BLK1_Number  : integer := 999;
  shared variable CUR_AD_BLK2_Number  : integer := 999;
  shared variable CUR_AD_BLK3_Number  : integer := 999;
  shared variable CUR_AD_BLK4_Number  : integer := 999;
  shared variable CUR_AD_BLK5_Number  : integer := 999;
  shared variable CUR_AD_BLK6_Number  : integer := 999;
  shared variable CUR_AD_BLK7_Number  : integer := 999;
  shared variable CUR_AD_BLK8_Number  : integer := 999;
  shared variable CUR_AD_BLK9_Number  : integer := 999;
  shared variable CUR_AD_BLK10_Number : integer := 999;
  shared variable CUR_AD_BLK11_Number : integer := 999;
  shared variable CUR_AD_BLK12_Number : integer := 999;
  shared variable CUR_AD_BLK13_Number : integer := 999;

  shared variable CUR_AV_BLK1_Number  : integer := 999;
  shared variable CUR_AV_BLK2_Number  : integer := 999;
  shared variable CUR_AV_BLK3_Number  : integer := 999;
  shared variable CUR_AV_BLK4_Number  : integer := 999;
  shared variable CUR_AV_BLK5_Number  : integer := 999;
  shared variable CUR_AV_BLK6_Number  : integer := 999;
  shared variable CUR_AV_BLK7_Number  : integer := 999;
  shared variable CUR_AV_BLK8_Number  : integer := 999;
  shared variable CUR_AV_BLK9_Number  : integer := 999;
  shared variable CUR_AV_BLK10_Number : integer := 999;
  shared variable CUR_AV_BLK11_Number : integer := 999;
  shared variable CUR_AV_BLK12_Number : integer := 999;
  shared variable CUR_AV_BLK13_Number : integer := 999;



begin

  process(video_on, pixel_x, pixel_y, leds, C_BLOCK)

    variable C_BLOCK_Y_i : integer;
    variable C_BLOCK_X_i : integer;


  begin

    if (video_on = '1') then

      -- Marco blanco
      if (((pixel_x > 18) and (pixel_x < 621) and (pixel_y = 19)) or ((pixel_x > 18) and (pixel_x < 621) and (pixel_y = 460))
          or ((pixel_y > 18) and (pixel_y < 461) and (pixel_x = 19)) or ((pixel_y > 18) and (pixel_y < 461) and (pixel_x = 620))) then
        rgb <= white;

      elsif ((pixel_y > 19) and (pixel_x > 19) and (pixel_y < 460) and (pixel_x < 620)) then  -- Area interior

        rgb <= black;

        -- Sacar la posición del bloque mediante los píxeles de x e y
        C_BLOCK_Y_i := (((to_integer(unsigned(pixel_y)))- 20)/20);
        C_BLOCK_X_i := (((to_integer(unsigned(pixel_x)))- 20)/20);

        -- Posición del bloque
        C_BLOCK <= (C_BLOCK_Y_i * BLOCKS_WIDE) + C_BLOCK_X_i;

        -- Leds
        if (C_BLOCK = CUR_BLK_LD0_C or C_BLOCK = CUR_BLK_LD1_C or C_BLOCK = CUR_BLK_LD2_C or C_BLOCK = CUR_BLK_LD3_C or
            C_BLOCK = CUR_BLK_LD4_C or C_BLOCK = CUR_BLK_LD5_C or C_BLOCK = CUR_BLK_LD6_C or C_BLOCK = CUR_BLK_LD7_C) then

          if (C_BLOCK = CUR_BLK_LD0_C and leds(0) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD1_C and leds(1) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD2_C and leds(2) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD3_C and leds(3) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD4_C and leds(4) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD5_C and leds(5) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD6_C and leds(6) = '1') then
            rgb <= green;
          elsif (C_BLOCK = CUR_BLK_LD7_C and leds(7) = '1') then
            rgb <= green;
          else
            rgb <= white;
          end if;

          -- Letra T
        elsif (C_BLOCK = CUR_T_BLK1 or C_BLOCK = CUR_T_BLK2 or C_BLOCK = CUR_T_BLK3 or C_BLOCK = CUR_T_BLK4 or
               C_BLOCK = CUR_T_BLK5 or C_BLOCK = CUR_T_BLK6 or C_BLOCK = CUR_T_BLK7) then
          rgb <= red;

          -- Letra A
        elsif (C_BLOCK = CUR_A_BLK1 or C_BLOCK = CUR_A_BLK2 or C_BLOCK = CUR_A_BLK3 or C_BLOCK = CUR_A_BLK4 or
               C_BLOCK = CUR_A_BLK5 or C_BLOCK = CUR_A_BLK6 or C_BLOCK = CUR_A_BLK7 or C_BLOCK = CUR_A_BLK8 or
               C_BLOCK = CUR_A_BLK9 or C_BLOCK = CUR_A_BLK10 or C_BLOCK = CUR_A_BLK11 or C_BLOCK = CUR_A_BLK12) then
          rgb <= yellow;

          -- TempMSB
        elsif (C_BLOCK = CUR_BLK1_Number or C_BLOCK = CUR_BLK2_Number or C_BLOCK = CUR_BLK3_Number or C_BLOCK = CUR_BLK4_Number or
               C_BLOCK = CUR_BLK5_Number or C_BLOCK = CUR_BLK6_Number or C_BLOCK = CUR_BLK7_Number or C_BLOCK = CUR_BLK8_Number or
               C_BLOCK = CUR_BLK9_Number or C_BLOCK = CUR_BLK10_Number or C_BLOCK = CUR_BLK11_Number or C_BLOCK = CUR_BLK12_Number or
               C_BLOCK = CUR_BLK13_Number) then
          rgb <= white;

          -- TempLSB
        elsif (C_BLOCK = CUR_TLSB_BLK1_Number or C_BLOCK = CUR_TLSB_BLK2_Number or C_BLOCK = CUR_TLSB_BLK3_Number or C_BLOCK = CUR_TLSB_BLK4_Number or
               C_BLOCK = CUR_TLSB_BLK5_Number or C_BLOCK = CUR_TLSB_BLK6_Number or C_BLOCK = CUR_TLSB_BLK7_Number or C_BLOCK = CUR_TLSB_BLK8_Number or
               C_BLOCK = CUR_TLSB_BLK9_Number or C_BLOCK = CUR_TLSB_BLK10_Number or C_BLOCK = CUR_TLSB_BLK11_Number or C_BLOCK = CUR_TLSB_BLK12_Number or
               C_BLOCK = CUR_TLSB_BLK13_Number) then
          rgb <= white;

          -- ActAddr
        elsif (C_BLOCK = CUR_AD_BLK1_Number or C_BLOCK = CUR_AD_BLK2_Number or C_BLOCK = CUR_AD_BLK3_Number or C_BLOCK = CUR_AD_BLK4_Number or
               C_BLOCK = CUR_AD_BLK5_Number or C_BLOCK = CUR_AD_BLK6_Number or C_BLOCK = CUR_AD_BLK7_Number or C_BLOCK = CUR_AD_BLK8_Number or
               C_BLOCK = CUR_AD_BLK9_Number or C_BLOCK = CUR_AD_BLK10_Number or C_BLOCK = CUR_AD_BLK11_Number or C_BLOCK = CUR_AD_BLK12_Number or
               C_BLOCK = CUR_AD_BLK13_Number) then
          rgb <= white;

          -- Actvalue
        elsif (C_BLOCK = CUR_AV_BLK1_Number or C_BLOCK = CUR_AV_BLK2_Number or C_BLOCK = CUR_AV_BLK3_Number or C_BLOCK = CUR_AV_BLK4_Number or
               C_BLOCK = CUR_AV_BLK5_Number or C_BLOCK = CUR_AV_BLK6_Number or C_BLOCK = CUR_AV_BLK7_Number or C_BLOCK = CUR_AV_BLK8_Number or
               C_BLOCK = CUR_AV_BLK9_Number or C_BLOCK = CUR_AV_BLK10_Number or C_BLOCK = CUR_AV_BLK11_Number or C_BLOCK = CUR_AV_BLK12_Number or
               C_BLOCK = CUR_AV_BLK13_Number) then
          rgb <= white;

        else rgb <= black;
        end if;
      else rgb <= gray;                 -- Exterior zona
      end if;
    else rgb <= black;                  -- Exterior zona visible
    end if;
  end process;

  temperatura_MSB <= temperatura(7 downto 4);
  temperatura_LSB <= temperatura(3 downto 0);

  process(pixel_x , pixel_y, temperatura_MSB, CUR_TempMSB_BLK)

  begin

    CUR_TempMSB_BLK <= CUR_BLK_TempMSB_C;

    case to_integer(unsigned(temperatura_MSB)) is

      -- 0 Block
      when 0 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 90;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK6_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK8_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK12_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK13_Number := 999;

        -- 1 Block
      when 1 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 1 + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 1 + 90;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 1 + 120;

        ---
        CUR_BLK6_Number  := 999;
        CUR_BLK7_Number  := 999;
        CUR_BLK8_Number  := 999;
        CUR_BLK9_Number  := 999;
        CUR_BLK10_Number := 999;
        CUR_BLK11_Number := 999;
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 2 Block
      when 2 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 90;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK5_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK8_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 3 Block
      when 3 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK4_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK7_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK8_Number  := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 4 Block
      when 4 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;

        CUR_BLK4_Number := CUR_TempMSB_BLK + 1 + 60;

        CUR_BLK5_Number := CUR_TempMSB_BLK + 2;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK8_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK9_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK10_Number := 999;
        CUR_BLK11_Number := 999;
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 5 Block
      when 5 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK5_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK8_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 6 Block
      when 6 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 90;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK6_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK8_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK12_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK13_Number := 999;

        -- 7 Block
      when 7 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;

        CUR_BLK2_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 1 + 60;

        CUR_BLK4_Number := CUR_TempMSB_BLK + 2;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK8_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK9_Number  := 999;
        CUR_BLK10_Number := 999;
        CUR_BLK11_Number := 999;
        CUR_BLK12_Number := 999;
        CUR_BLK13_Number := 999;

        -- 8 Block
      when 8 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 90;
        CUR_BLK5_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK6_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK8_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK12_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK13_Number := CUR_TempMSB_BLK + 2 + 120;

        -- 9 Block
      when 9 =>
        CUR_BLK1_Number := CUR_TempMSB_BLK;
        CUR_BLK2_Number := CUR_TempMSB_BLK + 30;
        CUR_BLK3_Number := CUR_TempMSB_BLK + 60;
        CUR_BLK4_Number := CUR_TempMSB_BLK + 120;

        CUR_BLK5_Number := CUR_TempMSB_BLK + 1;
        CUR_BLK6_Number := CUR_TempMSB_BLK + 1 + 60;
        CUR_BLK7_Number := CUR_TempMSB_BLK + 1 + 120;

        CUR_BLK8_Number  := CUR_TempMSB_BLK + 2;
        CUR_BLK9_Number  := CUR_TempMSB_BLK + 2 + 30;
        CUR_BLK10_Number := CUR_TempMSB_BLK + 2 + 60;
        CUR_BLK11_Number := CUR_TempMSB_BLK + 2 + 90;
        CUR_BLK12_Number := CUR_TempMSB_BLK + 2 + 120;

        ---
        CUR_BLK13_Number := 999;

      when others =>
        CUR_BLK1_Number := 999;
        CUR_BLK2_Number := 999;
        CUR_BLK3_Number := 999;
        CUR_BLK4_Number := 999;

        CUR_BLK5_Number := 999;
        CUR_BLK6_Number := 999;
        CUR_BLK7_Number := 999;

        CUR_BLK8_Number  := 999;
        CUR_BLK9_Number  := 999;
        CUR_BLK10_Number := 999;
        CUR_BLK11_Number := 999;
        CUR_BLK12_Number := 999;

    end case;
  end process;


  process(pixel_x , pixel_y, temperatura_LSB, CUR_TempLSB_BLK)

  begin

    CUR_TempLSB_BLK <= CUR_BLK_TempLSB_C;

    case to_integer(unsigned(temperatura_LSB)) is

      -- 0 Block
      when 0 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 90;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK8_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK12_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK13_Number := 999;

        -- 1 Block
      when 1 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 1 + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 1 + 90;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 1 + 120;

        ---
        CUR_TLSB_BLK6_Number  := 999;
        CUR_TLSB_BLK7_Number  := 999;
        CUR_TLSB_BLK8_Number  := 999;
        CUR_TLSB_BLK9_Number  := 999;
        CUR_TLSB_BLK10_Number := 999;
        CUR_TLSB_BLK11_Number := 999;
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 2 Block
      when 2 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 90;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK8_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 3 Block
      when 3 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK7_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK8_Number  := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 4 Block
      when 4 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;

        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 1 + 60;

        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK8_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK9_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK10_Number := 999;
        CUR_TLSB_BLK11_Number := 999;
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 5 Block
      when 5 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK8_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 6 Block
      when 6 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 90;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK8_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK12_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK13_Number := 999;

        -- 7 Block
      when 7 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;

        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 1 + 60;

        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK8_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK9_Number  := 999;
        CUR_TLSB_BLK10_Number := 999;
        CUR_TLSB_BLK11_Number := 999;
        CUR_TLSB_BLK12_Number := 999;
        CUR_TLSB_BLK13_Number := 999;

        -- 8 Block
      when 8 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 90;
        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK8_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK12_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK13_Number := CUR_TempLSB_BLK + 2 + 120;

        -- 9 Block
      when 9 =>
        CUR_TLSB_BLK1_Number := CUR_TempLSB_BLK;
        CUR_TLSB_BLK2_Number := CUR_TempLSB_BLK + 30;
        CUR_TLSB_BLK3_Number := CUR_TempLSB_BLK + 60;
        CUR_TLSB_BLK4_Number := CUR_TempLSB_BLK + 120;

        CUR_TLSB_BLK5_Number := CUR_TempLSB_BLK + 1;
        CUR_TLSB_BLK6_Number := CUR_TempLSB_BLK + 1 + 60;
        CUR_TLSB_BLK7_Number := CUR_TempLSB_BLK + 1 + 120;

        CUR_TLSB_BLK8_Number  := CUR_TempLSB_BLK + 2;
        CUR_TLSB_BLK9_Number  := CUR_TempLSB_BLK + 2 + 30;
        CUR_TLSB_BLK10_Number := CUR_TempLSB_BLK + 2 + 60;
        CUR_TLSB_BLK11_Number := CUR_TempLSB_BLK + 2 + 90;
        CUR_TLSB_BLK12_Number := CUR_TempLSB_BLK + 2 + 120;

        ---
        CUR_TLSB_BLK13_Number := 999;

      when others =>
        CUR_TLSB_BLK1_Number := 999;
        CUR_TLSB_BLK2_Number := 999;
        CUR_TLSB_BLK3_Number := 999;
        CUR_TLSB_BLK4_Number := 999;

        CUR_TLSB_BLK5_Number := 999;
        CUR_TLSB_BLK6_Number := 999;
        CUR_TLSB_BLK7_Number := 999;

        CUR_TLSB_BLK8_Number  := 999;
        CUR_TLSB_BLK9_Number  := 999;
        CUR_TLSB_BLK10_Number := 999;
        CUR_TLSB_BLK11_Number := 999;
        CUR_TLSB_BLK12_Number := 999;

    end case;
  end process;


--- ACTUADORES

  actuador_addr  <= actuadores(7 downto 4);
  actuador_value <= actuadores(3 downto 0);

  process(pixel_x , pixel_y, actuador_addr, CUR_ActAddr_BLK)

  begin

    CUR_ActAddr_BLK <= CUR_BLK_ActAddr_C;

    case to_integer(unsigned(actuador_addr)) is

      -- 0 Block
      when 0 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 90;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK8_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK12_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK13_Number := 999;

        -- 1 Block
      when 1 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 1 + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 1 + 90;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 1 + 120;

        ---
        CUR_AD_BLK6_Number  := 999;
        CUR_AD_BLK7_Number  := 999;
        CUR_AD_BLK8_Number  := 999;
        CUR_AD_BLK9_Number  := 999;
        CUR_AD_BLK10_Number := 999;
        CUR_AD_BLK11_Number := 999;
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 2 Block
      when 2 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 90;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK8_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 3 Block
      when 3 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK7_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK8_Number  := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 4 Block
      when 4 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;

        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 1 + 60;

        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK8_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK9_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK10_Number := 999;
        CUR_AD_BLK11_Number := 999;
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 5 Block
      when 5 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK8_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 6 Block
      when 6 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 90;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK8_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK12_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK13_Number := 999;

        -- 7 Block
      when 7 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;

        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 1 + 60;

        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK8_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK9_Number  := 999;
        CUR_AD_BLK10_Number := 999;
        CUR_AD_BLK11_Number := 999;
        CUR_AD_BLK12_Number := 999;
        CUR_AD_BLK13_Number := 999;

        -- 8 Block
      when 8 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 90;
        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK8_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK12_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK13_Number := CUR_ActAddr_BLK + 2 + 120;

        -- 9 Block
      when 9 =>
        CUR_AD_BLK1_Number := CUR_ActAddr_BLK;
        CUR_AD_BLK2_Number := CUR_ActAddr_BLK + 30;
        CUR_AD_BLK3_Number := CUR_ActAddr_BLK + 60;
        CUR_AD_BLK4_Number := CUR_ActAddr_BLK + 120;

        CUR_AD_BLK5_Number := CUR_ActAddr_BLK + 1;
        CUR_AD_BLK6_Number := CUR_ActAddr_BLK + 1 + 60;
        CUR_AD_BLK7_Number := CUR_ActAddr_BLK + 1 + 120;

        CUR_AD_BLK8_Number  := CUR_ActAddr_BLK + 2;
        CUR_AD_BLK9_Number  := CUR_ActAddr_BLK + 2 + 30;
        CUR_AD_BLK10_Number := CUR_ActAddr_BLK + 2 + 60;
        CUR_AD_BLK11_Number := CUR_ActAddr_BLK + 2 + 90;
        CUR_AD_BLK12_Number := CUR_ActAddr_BLK + 2 + 120;

        ---
        CUR_AD_BLK13_Number := 999;

      when others =>
        CUR_AD_BLK1_Number := 999;
        CUR_AD_BLK2_Number := 999;
        CUR_AD_BLK3_Number := 999;
        CUR_AD_BLK4_Number := 999;

        CUR_AD_BLK5_Number := 999;
        CUR_AD_BLK6_Number := 999;
        CUR_AD_BLK7_Number := 999;

        CUR_AD_BLK8_Number  := 999;
        CUR_AD_BLK9_Number  := 999;
        CUR_AD_BLK10_Number := 999;
        CUR_AD_BLK11_Number := 999;
        CUR_AD_BLK12_Number := 999;

    end case;
  end process;

  process(pixel_x , pixel_y, actuador_value, CUR_ActValue_BLK)

  begin

    CUR_ActValue_BLK <= CUR_BLK_ActValue_C;

    case to_integer(unsigned(actuador_value)) is

      -- 0 Block
      when 0 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 90;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK8_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK12_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK13_Number := 999;

        -- 1 Block
      when 1 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 1 + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 1 + 90;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 1 + 120;

        ---
        CUR_AV_BLK6_Number  := 999;
        CUR_AV_BLK7_Number  := 999;
        CUR_AV_BLK8_Number  := 999;
        CUR_AV_BLK9_Number  := 999;
        CUR_AV_BLK10_Number := 999;
        CUR_AV_BLK11_Number := 999;
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 2 Block
      when 2 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 90;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK8_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 3 Block
      when 3 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK7_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK8_Number  := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 4 Block
      when 4 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;

        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 1 + 60;

        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 2;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK8_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK9_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK10_Number := 999;
        CUR_AV_BLK11_Number := 999;
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 5 Block
      when 5 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK8_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 6 Block
      when 6 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 90;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK8_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK12_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK13_Number := 999;

        -- 7 Block
      when 7 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;

        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 1 + 60;

        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 2;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK8_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK9_Number  := 999;
        CUR_AV_BLK10_Number := 999;
        CUR_AV_BLK11_Number := 999;
        CUR_AV_BLK12_Number := 999;
        CUR_AV_BLK13_Number := 999;

        -- 8 Block
      when 8 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 90;
        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK8_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK12_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK13_Number := CUR_ActValue_BLK + 2 + 120;

        -- 9 Block
      when 9 =>
        CUR_AV_BLK1_Number := CUR_ActValue_BLK;
        CUR_AV_BLK2_Number := CUR_ActValue_BLK + 30;
        CUR_AV_BLK3_Number := CUR_ActValue_BLK + 60;
        CUR_AV_BLK4_Number := CUR_ActValue_BLK + 120;

        CUR_AV_BLK5_Number := CUR_ActValue_BLK + 1;
        CUR_AV_BLK6_Number := CUR_ActValue_BLK + 1 + 60;
        CUR_AV_BLK7_Number := CUR_ActValue_BLK + 1 + 120;

        CUR_AV_BLK8_Number  := CUR_ActValue_BLK + 2;
        CUR_AV_BLK9_Number  := CUR_ActValue_BLK + 2 + 30;
        CUR_AV_BLK10_Number := CUR_ActValue_BLK + 2 + 60;
        CUR_AV_BLK11_Number := CUR_ActValue_BLK + 2 + 90;
        CUR_AV_BLK12_Number := CUR_ActValue_BLK + 2 + 120;

        ---
        CUR_AV_BLK13_Number := 999;

      when others =>
        CUR_AV_BLK1_Number := 999;
        CUR_AV_BLK2_Number := 999;
        CUR_AV_BLK3_Number := 999;
        CUR_AV_BLK4_Number := 999;

        CUR_AV_BLK5_Number := 999;
        CUR_AV_BLK6_Number := 999;
        CUR_AV_BLK7_Number := 999;

        CUR_AV_BLK8_Number  := 999;
        CUR_AV_BLK9_Number  := 999;
        CUR_AV_BLK10_Number := 999;
        CUR_AV_BLK11_Number := 999;
        CUR_AV_BLK12_Number := 999;

    end case;
  end process;
end arq;
