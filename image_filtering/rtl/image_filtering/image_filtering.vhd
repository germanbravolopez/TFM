----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2019 22:23:52
-- Design Name: 
-- Module Name: image_filtering - Behavioral
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
use ieee.fixed_pkg.all;

use work.colors.all;
use work.masks.all;

entity image_filtering is
	port(
		reset        : in  std_logic;
		clk100mhz    : in  std_logic;
		clk25mhz     : in  std_logic;
		sw           : in  std_logic_vector(14 downto 0);
		area_activa  : in  std_logic;
		pixel_x      : in  integer;
		pixel_y      : in  integer;
		rddata_photo : in  std_logic_vector(11 downto 0);
		rdaddress    : out std_logic_vector(18 downto 0);
		data_r       : out std_logic_vector(3 downto 0);
		data_g       : out std_logic_vector(3 downto 0);
		data_b       : out std_logic_vector(3 downto 0)
	);
end image_filtering;

architecture rtl of image_filtering is
	------------------------------------------------------------
	signal mask11, mask12, mask13,      -- mascara11, mascara12, mascara13      1   -2   1
	mask21, mask22, mask23,             -- mascara21, mascara22, mascara23      1   -2   1 
	mask31, mask32, mask33              -- mascara31, mascara32, mascara33      1   -2   1
	: integer;
	signal weight_sum                                                                                                                                                                                                                        : integer;

	signal px13_tmp, px23_tmp, px33_tmp : std_logic_vector(11 downto 0);

	signal px11, px12, px13 : std_logic_vector(11 downto 0);
	signal px21, px22, px23 : std_logic_vector(11 downto 0);
	signal px31, px32, px33 : std_logic_vector(11 downto 0);

	signal px11_n, px12_n, px13_n : std_logic_vector(11 downto 0) := (others => '0');
	signal px21_n, px22_n, px23_n : std_logic_vector(11 downto 0) := (others => '0');
	signal px31_n, px32_n, px33_n : std_logic_vector(11 downto 0) := (others => '0');

	-- Señales internas DFG
	signal mult_11_r_n, mult_12_r_n, mult_13_r_n, mult_21_r_n, mult_22_r_n, mult_23_r_n, mult_31_r_n, mult_32_r_n, mult_33_r_n : integer;
	signal sum1_r_n, sum2_r_n, sum3_r_n, sum4_r_n, sum5_r_n, sum6_r_n, sum7_r_n                                                : integer;

	signal mult_11_g_n, mult_12_g_n, mult_13_g_n, mult_21_g_n, mult_22_g_n, mult_23_g_n, mult_31_g_n, mult_32_g_n, mult_33_g_n : integer;
	signal sum1_g_n, sum2_g_n, sum3_g_n, sum4_g_n, sum5_g_n, sum6_g_n, sum7_g_n                                                : integer;

	signal mult_11_b_n, mult_12_b_n, mult_13_b_n, mult_21_b_n, mult_22_b_n, mult_23_b_n, mult_31_b_n, mult_32_b_n, mult_33_b_n : integer;
	signal sum1_b_n, sum2_b_n, sum3_b_n, sum4_b_n, sum5_b_n, sum6_b_n, sum7_b_n                                                : integer;

	signal mult_11_r, mult_12_r, mult_13_r, mult_21_r, mult_22_r, mult_23_r, mult_31_r, mult_32_r, mult_33_r : integer;
	signal sum1_r, sum2_r, sum3_r, sum4_r, sum5_r, sum6_r, sum7_r                                            : integer;

	signal mult_11_g, mult_12_g, mult_13_g, mult_21_g, mult_22_g, mult_23_g, mult_31_g, mult_32_g, mult_33_g : integer;
	signal sum1_g, sum2_g, sum3_g, sum4_g, sum5_g, sum6_g, sum7_g                                            : integer;

	signal mult_11_b, mult_12_b, mult_13_b, mult_21_b, mult_22_b, mult_23_b, mult_31_b, mult_32_b, mult_33_b : integer;
	signal sum1_b, sum2_b, sum3_b, sum4_b, sum5_b, sum6_b, sum7_b                                            : integer;

	-- Salidas del DFG    
	signal out_integer_r, out_integer_g, out_integer_b : integer;
	signal output_r, output_g, output_b                : std_logic_vector(3 downto 0);

	signal out_integer_r_n, out_integer_g_n, out_integer_b_n : integer;
	signal output_r_n, output_g_n, output_b_n                : std_logic_vector(3 downto 0);

	-- Estados
	type type_state is (idle, first_line, middle_im, last_line);
	signal state, state_n : type_state;

	signal cnt     : integer := 0;
	signal div_fix : ufixed(1 downto -4);
	signal div_int : integer;
	------------------------------------------------------------
begin
	mask_election_proc : process(sw)
	begin
		case (sw(12 downto 0)) is
			when "0000000000001" =>
				mask11 <= mask0_11;
				mask12 <= mask0_12;
				mask13 <= mask0_13;
				mask21 <= mask0_21;
				mask22 <= mask0_22;
				mask23 <= mask0_23;
				mask31 <= mask0_31;
				mask32 <= mask0_32;
				mask33 <= mask0_33;

				weight_sum <= weight_sum0;
			when "0000000000010" =>
				mask11 <= mask1_11;
				mask12 <= mask1_12;
				mask13 <= mask1_13;
				mask21 <= mask1_21;
				mask22 <= mask1_22;
				mask23 <= mask1_23;
				mask31 <= mask1_31;
				mask32 <= mask1_32;
				mask33 <= mask1_33;

				weight_sum <= weight_sum1;
			when "0000000000100" =>
				mask11 <= mask2_11;
				mask12 <= mask2_12;
				mask13 <= mask2_13;
				mask21 <= mask2_21;
				mask22 <= mask2_22;
				mask23 <= mask2_23;
				mask31 <= mask2_31;
				mask32 <= mask2_32;
				mask33 <= mask2_33;

				weight_sum <= weight_sum2;
			when "0000000001000" =>
				mask11 <= mask3_11;
				mask12 <= mask3_12;
				mask13 <= mask3_13;
				mask21 <= mask3_21;
				mask22 <= mask3_22;
				mask23 <= mask3_23;
				mask31 <= mask3_31;
				mask32 <= mask3_32;
				mask33 <= mask3_33;

				weight_sum <= weight_sum3;
			when "0000000010000" =>
				mask11 <= mask4_11;
				mask12 <= mask4_12;
				mask13 <= mask4_13;
				mask21 <= mask4_21;
				mask22 <= mask4_22;
				mask23 <= mask4_23;
				mask31 <= mask4_31;
				mask32 <= mask4_32;
				mask33 <= mask4_33;

				weight_sum <= weight_sum4;
			when "0000000100000" =>
				mask11 <= mask5_11;
				mask12 <= mask5_12;
				mask13 <= mask5_13;
				mask21 <= mask5_21;
				mask22 <= mask5_22;
				mask23 <= mask5_23;
				mask31 <= mask5_31;
				mask32 <= mask5_32;
				mask33 <= mask5_33;

				weight_sum <= weight_sum5;
			when "0000001000000" =>
				mask11 <= mask6_11;
				mask12 <= mask6_12;
				mask13 <= mask6_13;
				mask21 <= mask6_21;
				mask22 <= mask6_22;
				mask23 <= mask6_23;
				mask31 <= mask6_31;
				mask32 <= mask6_32;
				mask33 <= mask6_33;

				weight_sum <= weight_sum6;
			when "0000010000000" =>
				mask11 <= mask7_11;
				mask12 <= mask7_12;
				mask13 <= mask7_13;
				mask21 <= mask7_21;
				mask22 <= mask7_22;
				mask23 <= mask7_23;
				mask31 <= mask7_31;
				mask32 <= mask7_32;
				mask33 <= mask7_33;

				weight_sum <= weight_sum7;
			when others =>
				mask11 <= 0;
				mask12 <= 0;
				mask13 <= 0;
				mask21 <= 0;
				mask22 <= 0;
				mask23 <= 0;
				mask31 <= 0;
				mask32 <= 0;
				mask33 <= 0;

				weight_sum <= 1;
		end case;
	end process;

	fifo_proc : process(reset, clk100mhz)
	begin
		if (reset = '0') then
			rdaddress <= (others => '0');
			cnt       <= 0;
			px13_tmp  <= (others => '0');
			px23_tmp  <= (others => '0');
			px33_tmp  <= (others => '0');
		elsif (clk100mhz'event and clk100mhz = '1') then
			rdaddress <= (others => '0');
			if (area_activa = '1') then
				if (cnt = 0 or cnt = 1) then
					rdaddress <= std_logic_vector(to_unsigned(((640 * (pixel_y - 1)) + pixel_x), 19));
					cnt       <= cnt + 1;
				elsif (cnt = 2) then
					rdaddress <= std_logic_vector(to_unsigned(((640 * (pixel_y)) + pixel_x), 19));
					cnt       <= cnt + 1;
				elsif (cnt = 3) then
					rdaddress <= std_logic_vector(to_unsigned(((640 * (pixel_y + 1)) + pixel_x), 19));
					cnt       <= 0;
				end if;

				if (cnt = 0) then
					px13_tmp <= rddata_photo;
				elsif (cnt = 1) then
					px23_tmp <= rddata_photo;
				elsif (cnt = 2) then
					px33_tmp <= rddata_photo;
				end if;
			else
				cnt <= 0;
			end if;
		end if;
	end process;

	registers_proc : process(reset, clk25mhz)
	begin
		if (reset = '0') then
			state <= idle;
			px11  <= (others => '0');
			px12  <= (others => '0');
			px13  <= (others => '0');
			px21  <= (others => '0');
			px22  <= (others => '0');
			px23  <= (others => '0');
			px31  <= (others => '0');
			px32  <= (others => '0');
			px33  <= (others => '0');

			mult_11_r <= 0;
			mult_12_r <= 0;
			mult_13_r <= 0;
			mult_21_r <= 0;
			mult_22_r <= 0;
			mult_23_r <= 0;
			mult_31_r <= 0;
			mult_32_r <= 0;
			mult_33_r <= 0;
			sum1_r    <= 0;
			sum2_r    <= 0;
			sum3_r    <= 0;
			sum4_r    <= 0;
			sum5_r    <= 0;
			sum6_r    <= 0;
			sum7_r    <= 0;

			mult_11_g <= 0;
			mult_12_g <= 0;
			mult_13_g <= 0;
			mult_21_g <= 0;
			mult_22_g <= 0;
			mult_23_g <= 0;
			mult_31_g <= 0;
			mult_32_g <= 0;
			mult_33_g <= 0;
			sum1_g    <= 0;
			sum2_g    <= 0;
			sum3_g    <= 0;
			sum4_g    <= 0;
			sum5_g    <= 0;
			sum6_g    <= 0;
			sum7_g    <= 0;

			mult_11_b <= 0;
			mult_12_b <= 0;
			mult_13_b <= 0;
			mult_21_b <= 0;
			mult_22_b <= 0;
			mult_23_b <= 0;
			mult_31_b <= 0;
			mult_32_b <= 0;
			mult_33_b <= 0;
			sum1_b    <= 0;
			sum2_b    <= 0;
			sum3_b    <= 0;
			sum4_b    <= 0;
			sum5_b    <= 0;
			sum6_b    <= 0;
			sum7_b    <= 0;

			out_integer_r <= 0;
			output_r      <= (others => '0');
			out_integer_g <= 0;
			output_g      <= (others => '0');
			out_integer_b <= 0;
			output_b      <= (others => '0');

		elsif (clk25mhz'event and clk25mhz = '1') then
			div_fix   <= to_ufixed(0.0625, 1, -4);
			div_int   <= (1 / weight_sum);
			-- RGB separado            
			mult_11_r <= mult_11_r_n;
			mult_12_r <= mult_12_r_n;
			mult_13_r <= mult_13_r_n;
			mult_21_r <= mult_21_r_n;
			mult_22_r <= mult_22_r_n;
			mult_23_r <= mult_23_r_n;
			mult_31_r <= mult_31_r_n;
			mult_32_r <= mult_32_r_n;
			mult_33_r <= mult_33_r_n;

			sum1_r <= sum1_r_n;
			sum2_r <= sum2_r_n;
			sum3_r <= sum3_r_n;
			sum4_r <= sum4_r_n;
			sum5_r <= sum5_r_n;
			sum6_r <= sum6_r_n;
			sum7_r <= sum7_r_n;

			mult_11_g <= mult_11_g_n;
			mult_12_g <= mult_12_g_n;
			mult_13_g <= mult_13_g_n;
			mult_21_g <= mult_21_g_n;
			mult_22_g <= mult_22_g_n;
			mult_23_g <= mult_23_g_n;
			mult_31_g <= mult_31_g_n;
			mult_32_g <= mult_32_g_n;
			mult_33_g <= mult_33_g_n;
			sum1_g    <= sum1_g_n;
			sum2_g    <= sum2_g_n;
			sum3_g    <= sum3_g_n;
			sum4_g    <= sum4_g_n;
			sum5_g    <= sum5_g_n;
			sum6_g    <= sum6_g_n;
			sum7_g    <= sum7_g_n;

			mult_11_b <= mult_11_b_n;
			mult_12_b <= mult_12_b_n;
			mult_13_b <= mult_13_b_n;
			mult_21_b <= mult_21_b_n;
			mult_22_b <= mult_22_b_n;
			mult_23_b <= mult_23_b_n;
			mult_31_b <= mult_31_b_n;
			mult_32_b <= mult_32_b_n;
			mult_33_b <= mult_33_b_n;
			sum1_b    <= sum1_b_n;
			sum2_b    <= sum2_b_n;
			sum3_b    <= sum3_b_n;
			sum4_b    <= sum4_b_n;
			sum5_b    <= sum5_b_n;
			sum6_b    <= sum6_b_n;
			sum7_b    <= sum7_b_n;

			out_integer_r <= out_integer_r_n;
			output_r      <= output_r_n;
			out_integer_g <= out_integer_g_n;
			output_g      <= output_g_n;
			out_integer_b <= out_integer_b_n;
			output_b      <= output_b_n;

			if (area_activa = '1') then
				state <= state_n;
				px11  <= px11_n;
				px12  <= px12_n;
				px13  <= px13_tmp;
				px21  <= px21_n;
				px22  <= px22_n;
				px23  <= px23_tmp;
				px31  <= px31_n;
				px32  <= px32_n;
				px33  <= px33_tmp;
			else
				state <= state_n;
				px11  <= px11_n;
				px12  <= px12_n;
				px13  <= px13_n;
				px21  <= px21_n;
				px22  <= px22_n;
				px23  <= px23_n;
				px31  <= px31_n;
				px32  <= px32_n;
				px33  <= px33_n;
			end if;
		end if;
	end process;

	corner_proc : process(pixel_x, pixel_y, state, px11, px12, px13, px21, px22, px23, px31, px32, px33, mask11, mask12, mask13, mask21, mask22, mask23, mask31, mask32, mask33, div_fix, div_int, sw, mult_11_r, mult_12_r, mult_13_r, mult_21_r, mult_22_r, mult_23_r, mult_31_r, mult_32_r, sum1_r, mult_33_r, sum2_r, sum3_r, sum4_r, sum5_r, sum6_r, sum7_r, out_integer_r, mult_11_g, mult_12_g, mult_13_g, mult_21_g, mult_22_g, mult_23_g, mult_31_g, mult_32_g, sum1_g, mult_33_g, sum2_g, sum3_g, sum4_g, sum5_g, sum6_g, sum7_g, out_integer_g, mult_11_b, mult_12_b, mult_13_b, mult_21_b, mult_22_b, mult_23_b, mult_31_b, mult_32_b, sum1_b, mult_33_b, sum2_b, sum3_b, sum4_b, sum5_b, sum6_b, sum7_b, out_integer_b)
	begin
		state_n <= state;

		px11_n <= px11;
		px12_n <= px12;
		px13_n <= px13;
		px21_n <= px21;
		px22_n <= px22;
		px23_n <= px23;
		px31_n <= px31;
		px32_n <= px32;
		px33_n <= px33;

		mult_11_r_n <= 0;
		mult_12_r_n <= 0;
		mult_13_r_n <= 0;
		mult_21_r_n <= 0;
		mult_22_r_n <= 0;
		mult_23_r_n <= 0;
		mult_31_r_n <= 0;
		mult_32_r_n <= 0;
		mult_33_r_n <= 0;
		sum1_r_n    <= 0;
		sum2_r_n    <= 0;
		sum3_r_n    <= 0;
		sum4_r_n    <= 0;
		sum5_r_n    <= 0;
		sum6_r_n    <= 0;
		sum7_r_n    <= 0;

		mult_11_g_n <= 0;
		mult_12_g_n <= 0;
		mult_13_g_n <= 0;
		mult_21_g_n <= 0;
		mult_22_g_n <= 0;
		mult_23_g_n <= 0;
		mult_31_g_n <= 0;
		mult_32_g_n <= 0;
		mult_33_g_n <= 0;
		sum1_g_n    <= 0;
		sum2_g_n    <= 0;
		sum3_g_n    <= 0;
		sum4_g_n    <= 0;
		sum5_g_n    <= 0;
		sum6_g_n    <= 0;
		sum7_g_n    <= 0;

		mult_11_b_n <= 0;
		mult_12_b_n <= 0;
		mult_13_b_n <= 0;
		mult_21_b_n <= 0;
		mult_22_b_n <= 0;
		mult_23_b_n <= 0;
		mult_31_b_n <= 0;
		mult_32_b_n <= 0;
		mult_33_b_n <= 0;
		sum1_b_n    <= 0;
		sum2_b_n    <= 0;
		sum3_b_n    <= 0;
		sum4_b_n    <= 0;
		sum5_b_n    <= 0;
		sum6_b_n    <= 0;
		sum7_b_n    <= 0;

		out_integer_r_n <= 0;
		output_r_n      <= (others => '0');
		out_integer_g_n <= 0;
		output_g_n      <= (others => '0');
		out_integer_b_n <= 0;
		output_b_n      <= (others => '0');

		case (state) is
			when idle =>
				if (pixel_y = 0) then
					state_n <= first_line;
				end if;

			when first_line =>
				output_r_n <= red(11 downto 8);
				output_g_n <= red(7 downto 4);
				output_b_n <= red(3 downto 0);
				if (pixel_x = 641) then
					state_n <= middle_im;
				end if;

			when middle_im =>
				if (pixel_x = 799) then
					output_r_n <= blue(11 downto 8);
					output_g_n <= blue(7 downto 4);
					output_b_n <= blue(3 downto 0);

				elsif (pixel_x = 0) then -- 1a col
					px11_n <= px12;
					px12_n <= px13;
					px21_n <= px22;
					px22_n <= px23;
					px31_n <= px32;
					px32_n <= px33;

				elsif (0 < pixel_x and pixel_x < 638) then -- inter col
					px11_n      <= px12;
					px12_n      <= px13;
					px21_n      <= px22;
					px22_n      <= px23;
					px31_n      <= px32;
					px32_n      <= px33;
					-- ¿divs?
					-- parte msb: R
					mult_11_r_n <= to_integer(unsigned(px11(11 downto 8))) * mask11;
					mult_12_r_n <= to_integer(unsigned(px12(11 downto 8))) * mask12;
					mult_13_r_n <= to_integer(unsigned(px13(11 downto 8))) * mask13;
					mult_21_r_n <= to_integer(unsigned(px21(11 downto 8))) * mask21;
					mult_22_r_n <= to_integer(unsigned(px22(11 downto 8))) * mask22;
					mult_23_r_n <= to_integer(unsigned(px23(11 downto 8))) * mask23;
					mult_31_r_n <= to_integer(unsigned(px31(11 downto 8))) * mask31;
					mult_32_r_n <= to_integer(unsigned(px32(11 downto 8))) * mask32;
					mult_33_r_n <= to_integer(unsigned(px33(11 downto 8))) * mask33;

					sum1_r_n <= mult_11_r + mult_12_r;
					sum2_r_n <= mult_13_r + mult_21_r;
					sum3_r_n <= mult_22_r + mult_23_r;
					sum4_r_n <= mult_31_r + mult_32_r + mult_33_r;

					sum5_r_n <= sum1_r + sum2_r;
					sum6_r_n <= sum3_r + sum4_r;
					sum7_r_n <= sum5_r + sum6_r;

					if (sw(12 downto 0) = "0000000100000") then
						out_integer_r_n <= to_integer(to_ufixed(sum7_r, 16, -4) * div_fix);
					else
						out_integer_r_n <= (sum7_r * div_int);
					end if;
					if (out_integer_r >= 15) then
						output_r_n <= x"f";
					elsif (out_integer_r <= 0) then
						output_r_n <= x"0";
					else
						output_r_n <= std_logic_vector(to_unsigned(out_integer_r, 4));
					end if;

					-- parte midd: G
					mult_11_g_n <= to_integer(unsigned(px11(7 downto 4))) * mask11;
					mult_12_g_n <= to_integer(unsigned(px12(7 downto 4))) * mask12;
					mult_13_g_n <= to_integer(unsigned(px13(7 downto 4))) * mask13;
					mult_21_g_n <= to_integer(unsigned(px21(7 downto 4))) * mask21;
					mult_22_g_n <= to_integer(unsigned(px22(7 downto 4))) * mask22;
					mult_23_g_n <= to_integer(unsigned(px23(7 downto 4))) * mask23;
					mult_31_g_n <= to_integer(unsigned(px31(7 downto 4))) * mask31;
					mult_32_g_n <= to_integer(unsigned(px32(7 downto 4))) * mask32;
					mult_33_g_n <= to_integer(unsigned(px33(7 downto 4))) * mask33;

					sum1_g_n <= mult_11_g + mult_12_g;
					sum2_g_n <= mult_13_g + mult_21_g;
					sum3_g_n <= mult_22_g + mult_23_g;
					sum4_g_n <= mult_31_g + mult_32_g + mult_33_g;

					sum5_g_n <= sum1_g + sum2_g;
					sum6_g_n <= sum3_g + sum4_g;
					sum7_g_n <= sum5_g + sum6_g;

					if (sw(12 downto 0) = "0000000100000") then
						out_integer_g_n <= to_integer(to_ufixed(sum7_g, 16, -4) * div_fix);
					else
						out_integer_g_n <= (sum7_g * div_int);
					end if;
					if (out_integer_g >= 15) then
						output_g_n <= x"f";
					elsif (out_integer_g <= 0) then
						output_g_n <= x"0";
					else
						output_g_n <= std_logic_vector(to_unsigned(out_integer_g, 4));
					end if;

					-- parte lsb:  B
					mult_11_b_n <= to_integer(unsigned(px11(3 downto 0))) * mask11;
					mult_12_b_n <= to_integer(unsigned(px12(3 downto 0))) * mask12;
					mult_13_b_n <= to_integer(unsigned(px13(3 downto 0))) * mask13;
					mult_21_b_n <= to_integer(unsigned(px21(3 downto 0))) * mask21;
					mult_22_b_n <= to_integer(unsigned(px22(3 downto 0))) * mask22;
					mult_23_b_n <= to_integer(unsigned(px23(3 downto 0))) * mask23;
					mult_31_b_n <= to_integer(unsigned(px31(3 downto 0))) * mask31;
					mult_32_b_n <= to_integer(unsigned(px32(3 downto 0))) * mask32;
					mult_33_b_n <= to_integer(unsigned(px33(3 downto 0))) * mask33;

					sum1_b_n <= mult_11_b + mult_12_b;
					sum2_b_n <= mult_13_b + mult_21_b;
					sum3_b_n <= mult_22_b + mult_23_b;
					sum4_b_n <= mult_31_b + mult_32_b + mult_33_b;

					sum5_b_n <= sum1_b + sum2_b;
					sum6_b_n <= sum3_b + sum4_b;
					sum7_b_n <= sum5_b + sum6_b;

					if (sw(12 downto 0) = "0000000100000") then
						out_integer_b_n <= to_integer(to_ufixed(sum7_b, 16, -4) * div_fix);
					else
						out_integer_b_n <= (sum7_b * div_int);
					end if;
					if (out_integer_b >= 15) then
						output_b_n <= x"f";
					elsif (out_integer_b <= 0) then
						output_b_n <= x"0";
					else
						output_b_n <= std_logic_vector(to_unsigned(out_integer_b, 4));
					end if;

				elsif (pixel_x = 638) then
					-- leer ultima columna del display visible
					output_r_n <= white(11 downto 8);
					output_g_n <= white(7 downto 4);
					output_b_n <= white(3 downto 0);

					px11_n <= px12;
					px12_n <= px13;
					px21_n <= px22;
					px22_n <= px23;
					px31_n <= px32;
					px32_n <= px33;
				end if;

				if (pixel_y = 479) then
					state_n <= last_line;
				end if;

			when last_line =>
				output_r_n <= green(11 downto 8);
				output_g_n <= green(7 downto 4);
				output_b_n <= green(3 downto 0);
				if (pixel_x = 639) then
					state_n <= idle;
				end if;
		end case;
	end process;

	data_r <= "0000" when (area_activa = '0')
	          else output_r when (sw(14) = '1')
	          else px23_tmp(11 downto 8);

	data_g <= "0000" when (area_activa = '0')
	          else output_g when (sw(14) = '1')
	          else px23_tmp(7 downto 4);

	data_b <= "0000" when (area_activa = '0')
	          else output_b when (sw(14) = '1')
	          else px23_tmp(3 downto 0);

end rtl;
