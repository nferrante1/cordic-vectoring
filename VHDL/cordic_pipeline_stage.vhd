library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_pipeline_stage is generic(stage_number : INTEGER);
	port(
		x_in:		in std_logic_vector(15 downto 0);
		y_in:		in std_logic_vector(15 downto 0);
		x_out:		out std_logic_vector(15 downto 0);
		y_out:		out std_logic_vector(15 downto 0);
		current_angle:	in std_logic_vector(15 downto 0);
		phase_in:	in std_logic_vector(15 downto 0);
		phase_out:	out std_logic_vector(15 downto 0);
		clk:		in std_logic;
		rst:		in std_logic
	);
end cordic_pipeline_stage;

architecture bhv of cordic_pipeline_stage is
begin
	cordic_pipeline_stage_process:	process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				x_out(15 downto 0) <= "0000000000000000";
				y_out(15 downto 0) <= "0000000000000000";
				phase_out(15 downto 0) <= "0000000000000000";
			else 
				if(y_in(15) = '1') then
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
	end process;
end bhv;