----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:25:16
-- Design Name: 
-- Module Name: top_filtering_system - Behavioral
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

library ieee, ov7670;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_filtering_system is
	port(
		clk100mhz       : in    std_logic;
		reset           : in    std_logic;
		btnc            : in    std_logic; -- take photo
		btnr            : in    std_logic; -- image refresh
		-- sw(15): show photo, sw(14): filter image, sw[13:0]: kernels election
		-- sw(13): rgb election
		sw              : in    std_logic_vector(15 downto 0);
		config_finished : out   std_logic;
		vga_hsync       : out   std_logic;
		vga_vsync       : out   std_logic;
		vga_r           : out   std_logic_vector(3 downto 0);
		vga_g           : out   std_logic_vector(3 downto 0);
		vga_b           : out   std_logic_vector(3 downto 0);
		ov7670_pclk     : in    std_logic;
		ov7670_xclk     : out   std_logic;
		ov7670_vsync    : in    std_logic;
		ov7670_href     : in    std_logic;
		ov7670_data     : in    std_logic_vector(7 downto 0);
		ov7670_sioc     : out   std_logic;
		ov7670_siod     : inout std_logic;
		ov7670_pwdn     : out   std_logic;
		ov7670_reset    : out   std_logic
	);
end top_filtering_system;

architecture Behavioral of top_filtering_system is
	------------------------------------------------------------
	---------- Clk generator -----------------------------------
	------------------------------------------------------------
	component clk_generator
		port(
			clk50mhz  : out std_logic;
			clk25mhz  : out std_logic;
			reset     : in  std_logic;
			locked    : out std_logic;
			clk100mhz : in  std_logic
		);
	end component;

	------------------------------------------------------------
	------------------------------------------------------------
	signal wren   : std_logic_vector(0 downto 0);
	signal resend : std_logic;
	signal vsync  : std_logic;
	signal nsync  : std_logic;

	signal wraddress : std_logic_vector(18 downto 0);
	signal wrdata    : std_logic_vector(11 downto 0);

	signal rdaddress    : std_logic_vector(18 downto 0);
	signal rddata       : std_logic_vector(11 downto 0);
	signal rddata_photo : std_logic_vector(11 downto 0);

	signal size_select      : std_logic_vector(1 downto 0);
	signal rd_addr, wr_addr : std_logic_vector(16 downto 0);

	signal clk50mhz : std_logic;
	signal clk25mhz : std_logic;

	signal cont_addr   : std_logic_vector(18 downto 0) := (others => '0');
	signal area_activa : std_logic;
	signal reset_clk   : std_logic;

	signal pixel_x : integer;
	signal pixel_y : integer;

	signal data_r : std_logic_vector(3 downto 0);
	signal data_g : std_logic_vector(3 downto 0);
	signal data_b : std_logic_vector(3 downto 0);

begin
	reset_clk <= not reset;
	------------------------------------------------------------
	---------- Clk generator -----------------------------------
	------------------------------------------------------------
	inst_clk_generator : clk_generator
		port map(
			clk50mhz  => clk50mhz,
			clk25mhz  => clk25mhz,
			reset     => reset_clk,
			locked    => open,
			clk100mhz => clk100mhz
		);
	------------------------------------------------------------
	---------- Photo memory ------------------------------------
	------------------------------------------------------------
	inst_capture_memory : entity work.capture_memory(structure)
		port map(
			--            reset        => reset,
			clk100mhz    => clk100mhz,
			--            clk25mhz     => clk25mhz,
			btn          => btnc,
			ov7670_pclk  => ov7670_pclk,
			wren         => wren,
			wraddress    => wraddress,
			wrdata       => wrdata,
			--            area_activa  => area_activa,
			--            vsync        => vsync,
			rdaddress    => rdaddress,
			rddata_photo => rddata_photo
		);
	------------------------------------------------------------
	---------- VGA ---------------------------------------------
	------------------------------------------------------------
	inst_VGA : entity work.vga(rtl)
		port map(
			clk25mhz    => clk25mhz,
			reset       => reset,
			hsync       => vga_hsync,
			vsync       => vsync,
			area_activa => area_activa,
			pixel_x     => pixel_x,
			pixel_y     => pixel_y
		);
	------------------------------------------------------------
	vga_vsync <= vsync;
	------------------------------------------------------------
	---------- ov7670 Control ----------------------------------
	------------------------------------------------------------
	inst_ov7670_control : entity ov7670.ov7670_control(rtl)
		port map(
			clk50mhz   => clk50mhz,
			clk25mhz   => clk25mhz,
			resend     => resend,
			sw15       => sw(15),
			config_fin => config_finished,
			sioc       => ov7670_sioc,
			siod       => ov7670_siod,
			reset      => ov7670_reset,
			pwdn       => ov7670_pwdn,
			xclk       => ov7670_xclk
		);
	------------------------------------------------------------
	---------- ov7670 Captura ----------------------------------
	------------------------------------------------------------
	inst_ov7670_capture : entity ov7670.ov7670_capture(rtl)
		port map(
			pclk  => ov7670_pclk,
			vsync => ov7670_vsync,
			href  => ov7670_href,
			d     => ov7670_data,
			addr  => wraddress,
			dout  => wrdata,
			we    => wren(0)
		);
	------------------------------------------------------------
	---------- Image filtering ---------------------------------
	------------------------------------------------------------
	inst_image_filtering : entity work.image_filtering(rtl)
		port map(
			reset        => reset,
			clk100mhz    => clk100mhz,
			clk25mhz     => clk25mhz,
			sw           => sw(14 downto 0),
			area_activa  => area_activa,
			pixel_x      => pixel_x,
			pixel_y      => pixel_y,
			rddata_photo => rddata_photo,
			rdaddress    => rdaddress,
			data_r       => data_r,
			data_g       => data_g,
			data_b       => data_b
		);
	------------------------------------------------------------
	---------- Image refresh -----------------------------------
	------------------------------------------------------------
	inst_image_refresh : entity ov7670.image_refresh(rtl)
		port map(
			clk    => clk25mhz,
			btn    => btnr,
			refres => resend
		);
	------------------------------------------------------------
	------------------------------------------------------------
	vga_r     <= data_r when (sw(15) = '0') else "0000";
	vga_g     <= data_g when (sw(15) = '0') else "0000";
	vga_b     <= data_b when (sw(15) = '0') else "0000";
	------------------------------------------------------------
	------------------------------------------------------------
end Behavioral;
