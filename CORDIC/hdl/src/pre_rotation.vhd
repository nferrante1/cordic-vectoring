library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This module perform the pre-rotation needed to allow
-- CORDIC to converge even if input values are in 2nd or 3rd
-- quadrant, thanks to a rotation of these points into 1st
-- or 4th quadrant.

--PRE-ROTATION entity---------------------------------------
entity pre_rotation is generic (in_wordlength: INTEGER; out_wordlength: INTEGER);
	port(
		-- Input: x, y
		x_in: 		in std_logic_vector(in_wordlength-1 downto 0);
		y_in: 		in std_logic_vector(in_wordlength-1 downto 0);
		-- Output: rotated x, y and phase offset that could be 0, pi or -pi (quantized)
		x_out: 		out std_logic_vector(out_wordlength-1 downto 0);
		y_out: 		out std_logic_vector(out_wordlength-1 downto 0);
		phase_offset:	out std_logic_vector(out_wordlength-1 downto 0);
		-- Reset and clock signals
		rst: 		in std_logic; -- Reset signal (active-high)
		clk: 		in std_logic -- Clock
	);
end pre_rotation;
------------------------------------------------------------

--PRE-ROTATION architecture---------------------------------
architecture bhv of pre_rotation is
-- Sign extension signals
signal x_signed	: signed(out_wordlength-1 downto 0);
signal y_signed	: signed(out_wordlength-1 downto 0);

begin
	pre_rotation_logic: process(clk)
	begin
		if (rising_edge(clk)) then
			if(rst = '1') then
				-- Synchronous reset set all output signals to zero
				x_out <= (others => '0');
				y_out  <= (others => '0');
				phase_offset <= (others => '0');
				x_signed <= (others => '0');
				y_signed <= (others => '0');
			else
				-- Use signed signals for easier manipulation
				-- Signed extension
				x_signed <= resize(signed(x_in), x_signed'length);
				y_signed <= resize(signed(y_in), y_signed'length);

				if (x_signed < to_signed(0, x_signed'length)) then
					-- 2nd or 3rd quadrant, need to rotate inputs
					x_out <= std_logic_vector(-x_signed);
					y_out <= std_logic_vector(-y_signed);

					if( y_signed < to_signed(0, y_signed'length)) then
						-- We're in 3rd quadrant
						phase_offset(out_wordlength-1 downto 0) <= std_logic_vector(to_signed(-32767, out_wordlength));
						-- -32767 is the quantized representation of -pi

					else -- We're in 2rd quadrant
						phase_offset(out_wordlength-1 downto 0) <= std_logic_vector(to_signed(32767, out_wordlength));
						-- 32767 is the quantized representation of pi
					end if;
				else -- No need to rotate
					phase_offset(out_wordlength-1 downto 0) <= (others => '0');
					x_out <= std_logic_vector(x_signed);
					y_out <= std_logic_vector(y_signed);
				end if;
			end if;
		end if;
	end process; -- pre_rotation_logic
end bhv; -- pre_rotation
------------------------------------------------------------
