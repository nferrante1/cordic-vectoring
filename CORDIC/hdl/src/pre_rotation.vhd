library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pre_rotation is generic (in_wordlength : INTEGER; out_wordlength : INTEGER);
	port(
		x_in: 		in std_logic_vector(in_wordlength -1 downto 0); 
		y_in: 		in std_logic_vector(in_wordlength -1 downto 0);
		x_out: 		out std_logic_vector(out_wordlength-1 downto 0);	
		y_out: 		out std_logic_vector(out_wordlength-1 downto 0);	
		phase_offset:	out std_logic_vector(out_wordlength-1 downto 0); 
		rst: 		in std_logic;	--reset signal active high
		clk: 		in std_logic	--clock
	);
end pre_rotation;

architecture bhv of pre_rotation is
signal x_signed : signed(out_wordlength -1 downto 0);
signal y_signed: signed(out_wordlength -1 downto 0);

begin
	pre_rotation_logic: process(clk)
	begin
	if(rising_edge(clk)) then
		if(rst = '1') then --Synchronous reset
			x_out <= (others => '0');
			y_out  <= (others => '0');
			phase_offset <= (others => '0');
			x_signed <= (others => '0');
			y_signed <= (others => '0');
		else
			x_signed <= resize(signed(x_in), x_signed'length);
			y_signed <= resize(signed(y_in), y_signed'length);
			if(x_signed < to_signed(0, x_signed'length)) then 	
					
				x_out <= std_logic_vector(-x_signed);
				y_out <= std_logic_vector(-y_signed);

				if( y_signed < to_signed(0, y_signed'length)) then
					phase_offset(out_wordlength-1 downto 0) <= std_logic_vector(to_signed(-16384, out_wordlength));
				 	-- is the quantized representation of -pi
				else
					phase_offset(out_wordlength-1 downto 0) <= std_logic_vector(to_signed(16384, out_wordlength));
						-- is the quantized representation of pi
				end if; --y if
			else
				phase_offset(out_wordlength-1 downto 0) <= (others => '0');
				x_out <= std_logic_vector(x_signed);
				y_out <= std_logic_vector(y_signed);
				
	 	
			end if; --x if
		end if; --rst if
	end if; --clock if
end process;
end;