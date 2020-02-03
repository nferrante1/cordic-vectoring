library IEEE;
use IEEE.std_logic_1164.all;
--This module implements the first stage of cartesian to polar conversion algorithm
--The two MSB of x and y are provided as input
--The output will be new MSB for x and y



entity pre_rotation is 
	port(
		x_in: 		in std_logic; 	--MSB of x 
		y_in: 		in std_logic; 	--MSB of y
		x_out: 		out std_logic;	--rotated MSB of x
		y_out: 		out std_logic;	--rotated MSB of y
		phase_offset:	out std_logic_vector(15 downto 0); 
		rst: 		in std_logic;	--reset signal active high
		clk: 		in std_logic	--clock
	);
end pre_rotation;

architecture bhv of pre_rotation is
	
begin
	pre_rotation_logic: process(clk)
	begin
	if(rising_edge(clk)) then
		if(rst = '1') then --Synchronous reset
			x_out <= '0';
			y_out  <= '0';
			phase_offset(15 downto 0) <= "0000000000000000";
		elsif(x_in = '1') then 	--With x MSB we can identify if the rotation is needed or not
					-- We don't need to examine y's MSB to determine new MSB
			x_out <= '0'; 
			
			if( y_in = '1' ) then
				y_out <= '0';
				phase_offset(15 downto 0) <= "0110010010001000";
				 	-- is the binary representation of pi on 16 bits fixed point numbers with 13 bits of fractional part
			else
				y_out <= '1';
				phase_offset(15 downto 0) <= "1001101101111000"; 
						-- is the binary representation of -pi on 16 bits fixed point numbers with 13 bits of fractional part
			end if; --y if
		else
			phase_offset(15 downto 0) <= "0000000000000000";
					 	-- is the binary representation of 0 on 16 bits fixed point numbers with 13 bits of fractional part
		end if; --x if
	end if; --clock if
end process;
end;