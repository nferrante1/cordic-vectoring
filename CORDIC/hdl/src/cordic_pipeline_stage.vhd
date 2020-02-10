library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This module is a stage of the pipeline that computes
-- CORDIC algorithm
-- Generic parameters are:
	-- stage_number: the position in the pipeline of the
		-- stage. It's needed to assign the correct
		-- number of bits to shift
	-- wordlength: is needed for in/out signals dimensioning

--cordic_pipeline_stage entity------------------------------
entity cordic_pipeline_stage is generic(stage_number: INTEGER; wordlength: INTEGER);
	port(
		x_in:		in std_logic_vector(wordlength-1 downto 0);
		y_in:		in std_logic_vector(wordlength-1 downto 0);
		x_out:		out std_logic_vector(wordlength-1 downto 0);
		y_out:		out std_logic_vector(wordlength-1 downto 0);
		current_angle:	in std_logic_vector(wordlength-1 downto 0);
		phase_in:	in std_logic_vector(wordlength-1 downto 0);
		phase_out:	out std_logic_vector(wordlength-1 downto 0);
		clk:		in std_logic;
		rst:		in std_logic
	);
end cordic_pipeline_stage;
------------------------------------------------------------

--cordic_pipeline_stage architecture------------------------
architecture bhv of cordic_pipeline_stage is
begin

	cordic_pipeline_stage_process:	process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then -- Synchronous reset
				-- Set all output signals to zero
				x_out <= (others => '0');
				y_out <= (others => '0');
				phase_out <= (others => '0');
			else -- Compute CORDIC core algorithm
				if(y_in(wordlength-1) = '1') then
					x_out <= std_logic_vector(signed(x_in) - (shift_right(signed(y_in), stage_number)));
					y_out <= std_logic_vector(signed(y_in) + (shift_right(signed(x_in), stage_number)));
					phase_out <= std_logic_vector(signed(phase_in) - signed(current_angle));
				else
					x_out <= std_logic_vector(signed(x_in) + (shift_right(signed(y_in), stage_number)));
					y_out <= std_logic_vector(signed(y_in) - (shift_right(signed(x_in), stage_number)));
					phase_out <= std_logic_vector(signed(phase_in) + signed(current_angle));
				end if;
			end if;
		end if;
	end process; -- cordic_pipeline_stage_process
end bhv; -- cordic_pipeline_stage
------------------------------------------------------------
