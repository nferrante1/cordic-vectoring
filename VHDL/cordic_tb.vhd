library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity cordic_tb is
end cordic_tb;

architecture bhv of cordic_tb is
	constant stages 	:integer := 14;
	constant in_file_x 	:string  := "input/x_bin.in";
	constant in_file_y 	:string  := "input/y_bin.in";
	
	constant wordlength 	:integer := 16;
	constant t_clk 		:time    := 10 ns;
	signal data_counter	:integer := 0;
	signal clk      	:std_logic := '0';
	signal rst      	:std_logic := '1';

	signal x_in 		:std_logic_vector(wordlength-2 downto 0);
	signal y_in     	:std_logic_vector(wordlength-2 downto 0);
	signal r_out 		:std_logic_vector(wordlength-1 downto 0);
	signal p_out		:std_logic_vector(wordlength-1 downto 0);

	signal eof       	:std_logic := '1';

	file fptr_x	 	: text;
	file fptr_y	 	: text;


component cordic is generic(stages: INTEGER :=14);
	port(
		x_in:	in std_logic_vector(14 downto 0);
		y_in:	in std_logic_vector(14 downto 0);
		radius:	out std_logic_vector(15 downto 0);
		phase:	out std_logic_vector(15 downto 0);
		clk:		in std_logic;
		rst:		in std_logic
	);	
end component cordic;

begin
--instantiate device under test
dut: cordic generic map(stages) port map(x_in, y_in, r_out, p_out, clk, rst);

--start clock
CLOCK_GEN:	clk <= (not(clk) and eof) after t_clk/2;
--start with a reset

get_data_proc: process(clk, rst)
		--Variables necessary for file IO
	   	variable fstatus_x	:file_open_status;
	   	variable file_line_x	:line;
		variable fstatus_y	:file_open_status;
	   	variable file_line_y	:line;
	   	variable x_data	:std_logic_vector(wordlength-2 downto 0);
	   	variable y_data	:std_logic_vector(wordlength-2 downto 0);
      		
		begin
		--Variable initialization
   			x_data 	:= (others => '0');   			
   			y_data	:= (others => '0');
   			--Open files for x and y
			file_open(fstatus_x, fptr_x, in_file_x, read_mode);
			file_open(fstatus_y, fptr_y, in_file_y, read_mode);

			REMOVE_RESET:	rst <= '0' after 15*t_clk;

			if(rst = '1') then --do reset things
				x_in   	<= (others => '0');
				y_in    <= (others =>'0');
				eof   	<= '1';
		
			elsif(rising_edge(clk)) then
				
				--retrieve data from file and send it into input signals
				if ((not endfile(fptr_x )) or (not endfile(fptr_y ))) then --there is still data to read
					readline(fptr_x, file_line_x);
   			   		read(file_line_x, x_data);
   			   		x_in      <= std_logic_vector(x_data);
   			   		readline(fptr_y, file_line_y);
   			   		read(file_line_y, y_data);
   			   		y_in      <= y_data;
					data_counter<= data_counter +1;
				else  --all data has been read
					eof       <= '0';
   					file_close(fptr_x);
					file_close(fptr_y);
				end if;
			end if;
	end process;
end bhv;
