library ieee;
use ieee.std_logic_1164.all;

package bloques is

-- LEDS
  constant CUR_BLK_LD0_C : integer := 574;
  constant CUR_BLK_LD1_C : integer := 577;
  constant CUR_BLK_LD2_C : integer := 580;
  constant CUR_BLK_LD3_C : integer := 583;
  constant CUR_BLK_LD4_C : integer := 586;
  constant CUR_BLK_LD5_C : integer := 589;
  constant CUR_BLK_LD6_C : integer := 592;
  constant CUR_BLK_LD7_C : integer := 595;

-- Posición de la letra A, dirección y valor del Actuador
  constant CUR_BLK_ActLetra_C : integer := 62;
  constant CUR_BLK_ActAddr_C  : integer := 66;
  constant CUR_BLK_ActValue_C : integer := 70;

-- Posición de la letra T, y valor del MSB y LSB de Temperatura
  constant CUR_BLK_TempLetra_C : integer := 76;
  constant CUR_BLK_TempMSB_C   : integer := 80;
  constant CUR_BLK_TempLSB_C   : integer := 84;

-- A Block

  constant CUR_A_BLK1 : integer := CUR_BLK_ActLetra_C;
  constant CUR_A_BLK2 : integer := CUR_BLK_ActLetra_C + 1;
  constant CUR_A_BLK3 : integer := CUR_BLK_ActLetra_C + 2;

  constant CUR_A_BLK4 : integer := CUR_BLK_ActLetra_C + 30;
  constant CUR_A_BLK5 : integer := CUR_BLK_ActLetra_C + 60;
  constant CUR_A_BLK6 : integer := CUR_BLK_ActLetra_C + 90;
  constant CUR_A_BLK7 : integer := CUR_BLK_ActLetra_C + 120;

  constant CUR_A_BLK8 : integer := CUR_BLK_ActLetra_C + 1 + 60;

  constant CUR_A_BLK9  : integer := CUR_BLK_ActLetra_C + 2 + 30;
  constant CUR_A_BLK10 : integer := CUR_BLK_ActLetra_C + 2 + 60;
  constant CUR_A_BLK11 : integer := CUR_BLK_ActLetra_C + 2 + 90;
  constant CUR_A_BLK12 : integer := CUR_BLK_ActLetra_C + 2 + 120;

-- T Block

  constant CUR_T_BLK1 : integer := CUR_BLK_TempLetra_C;
  constant CUR_T_BLK2 : integer := CUR_BLK_TempLetra_C + 1;
  constant CUR_T_BLK3 : integer := CUR_BLK_TempLetra_C + 2;
  constant CUR_T_BLK4 : integer := CUR_BLK_TempLetra_C + 1 + 30;
  constant CUR_T_BLK5 : integer := CUR_BLK_TempLetra_C + 1 + 60;
  constant CUR_T_BLK6 : integer := CUR_BLK_TempLetra_C + 1 + 90;
  constant CUR_T_BLK7 : integer := CUR_BLK_TempLetra_C + 1 + 120;

end bloques;
