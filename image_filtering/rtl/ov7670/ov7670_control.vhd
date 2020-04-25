----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:18:14
-- Design Name: 
-- Module Name: ov7670_control - Behavioral
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

entity ov7670_control is
    port(
        clk50mhz   : IN std_logic;
        clk25mhz   : IN std_logic;
        resend     : IN std_logic;    
        sw15       : IN std_logic;
        siod       : INOUT std_logic;      
        config_fin : OUT std_logic;
        sioc       : OUT std_logic;
        reset      : OUT std_logic;
        pwdn       : OUT std_logic;
        xclk       : OUT std_logic
    );
end ov7670_control;

architecture rtl of ov7670_control is

    ---- Register  ------------------------------------
    component ov7670_regs
        port(
            clk50mhz : IN std_logic;
            advance  : IN std_logic;          
            resend   : in STD_LOGIC;
            command  : OUT std_logic_vector(15 downto 0);
            finish   : OUT std_logic
        );
    end component;
    ---------------------------------------------------
    ---- SCCB 2 wires ---------------------------------
    component sccb_sender
        port(
            clk50mhz : IN std_logic;
            send    : IN std_logic;
            taken   : out std_logic;
            id      : IN std_logic_vector(7 downto 0);
            reg     : IN std_logic_vector(7 downto 0);
            value   : IN std_logic_vector(7 downto 0);    
            siod    : INOUT std_logic;      
            sioc    : OUT std_logic
        );
    end component;
    ---------------------------------------------------
    signal command  : std_logic_vector(15 downto 0);
    signal finish   : std_logic := '0';
    signal taken    : std_logic := '0';
    signal send     : std_logic;
    
    constant camera_address : std_logic_vector(7 downto 0) := x"42"; -- 42"; -- Device write ID - see top of page 11 of data sheet

begin
    config_fin <= finish;
    send <= not finish;
    
    --- SCCB ------------------------------------------------
	Inst_sccb_sender: sccb_sender 
	port map(
		clk50mhz   => clk50mhz,
		taken      => taken,
		siod       => siod,
		sioc       => sioc,
		send       => send,
		id         => camera_address,
        reg        => command(15 downto 8),
		value      => command(7 downto 0)
	); 
    ---------------------------------------------------------
	reset <= '1'; 						-- Normal mode
	pwdn  <= sw15; 						-- Power device up: 0 encendido, 1 suspendido
	xclk  <= clk25mhz;
    ---- ov7670 Register -----------------------------------
	Inst_ov7670_regs: ov7670_regs 
	port map(
		clk50mhz => clk50mhz,
		advance  => taken,
		command  => command,
		finish   => finish,
		resend   => resend
	);
    ---------------------------------------------------------


end rtl;
