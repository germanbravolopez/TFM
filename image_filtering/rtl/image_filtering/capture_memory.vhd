----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:20:55
-- Design Name: 
-- Module Name: capture_memory - Behavioral
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

entity capture_memory is
    Port ( 
--        reset        : in std_logic;
        clk100mhz    : in std_logic;
--        clk25mhz     : in std_logic;
        btn          : in std_logic;
        ov7670_pclk  : in std_logic;
        wren         : in std_logic_vector(0 downto 0);
        wraddress    : in std_logic_vector(18 downto 0);
        wrdata       : in std_logic_vector(11 downto 0);
--        area_activa  : in std_logic;
--        vsync        : in std_logic;
        rdaddress    : in std_logic_vector(18 downto 0);
        rddata_photo : out std_logic_vector(11 downto 0)
    );
end capture_memory;

architecture structure of capture_memory is
    
    component ram_photo
        PORT (
            clka  : IN STD_LOGIC;
            wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina  : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            clkb  : IN STD_LOGIC;
            addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    end component;
    
    signal wren_photo       : std_logic_vector(0 downto 0);
    
begin
        
    inst_ram_photo: ram_photo
        PORT map (
            clka   => ov7670_pclk,
            wea    => wren_photo,
            addra  => wraddress,
            dina   => wrdata,
            clkb   => clk100mhz,
            addrb  => rdaddress,
            doutb  => rddata_photo
        );
    
    wren_photo <= wren when (btn='1') else
                 "0";

end structure;
