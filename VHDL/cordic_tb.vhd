library IEEE;
use IEEE.std_logic_1164.all;

entity cordic_tb is
end cordic_tb;

architecture bhv of cordic_tb is
	constant stages 	:integer := 14;
	constant in_file 	:string  := "input/input_bin.in";
	constant wordlength 	:integer := 16;
	constant t_clk 		:time    := 10 ns;

	signal clk      	:std_logic := '0';
	signal rst      	:std_logic := '0';

	signal x_in 		:std_logic_vector(wordlength-1 downto 0);
	signal y_in     	:std_logic_vector(wordlength-1 downto 0);
	signal r_out 		:std_logic_vector(wordlength-1 downto 0);
	signal p_out		:std_logic_vector(wordlength-1 downto 0);

	signal eof       	:std_logic := '0';

	file fptr	 	: text;
begin
ClockGenerator: process
begin
   clk <= '0' after t_clk, '1' after 2*C_CLK;
   wait for 2*t_clk;
end process;
rst <= '1', '0' after 100 ns;
GetData_proc: process
   variable fstatus	:file_open_status;
   variable file_line	:line;
   variable x_data	:std_logic_vector(wordlength-1 downto 0);
   variable y_data	:std_logic_vector(wordlength-1 downto 0);
      
begin
   x_in   	<= (others => '0');
   x_data 	:= (others => '0');
   y_in     	<= (others =>'0');
   y_data	:= (others => '0');
   eof       	<= '0';
   wait until rst = '0';
   file_open(fstatus, fptr, C_FILE_NAME, read_mode);
   while (not endfile(fptr)) loop
      wait until clk = '1';
      readline(fptr, file_line);
      read(file_line, x_data);
      x_in      <= std_logic_vector(x_data);
      read(file_line, var_data2);
      data2      <= var_data2;
      read(file_line, var_data3);
      data3      <= var_data3;
   end loop;
   wait until rising_edge(clk);
   eof       <= '1';
   file_close(fptr);
   wait;
end process;
end cordic_tb;
