library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic is generic(stages: INTEGER:= 13; in_wordlength : INTEGER:=16; out_wordlength : INTEGER:=20);
	port(
		x_in:	in std_logic_vector(in_wordlength-1 downto 0);
		y_in:	in std_logic_vector(in_wordlength-1 downto 0);
		radius:	out std_logic_vector(out_wordlength-1 downto 0);
		phase:	out std_logic_vector(out_wordlength-1 downto 0);
		clk:	in std_logic;
		rst:	in std_logic
	);	
end cordic;

architecture bhv of cordic is

component cordic_pipeline_stage is generic(stage_number : INTEGER; wordlength : INTEGER);
	port(
		x_in:		in std_logic_vector(wordlength - 1 downto 0);
		y_in:		in std_logic_vector(wordlength - 1 downto 0);
		x_out:		out std_logic_vector(wordlength - 1 downto 0);
		y_out:		out std_logic_vector(wordlength - 1 downto 0);
		current_angle:	in std_logic_vector(wordlength - 1 downto 0);
		phase_in:	in std_logic_vector(wordlength - 1 downto 0);
		phase_out:	out std_logic_vector(wordlength - 1 downto 0);
		clk:		in std_logic;
		rst:		in std_logic
	);
end component cordic_pipeline_stage;

component pre_rotation is generic (in_wordlength : INTEGER; out_wordlength : INTEGER);
	port(
		x_in: 		in std_logic_vector(in_wordlength -1 downto 0); 
		y_in: 		in std_logic_vector(in_wordlength -1 downto 0);
		x_out: 		out std_logic_vector(out_wordlength-1 downto 0);	
		y_out: 		out std_logic_vector(out_wordlength-1 downto 0);	
		phase_offset:	out std_logic_vector(out_wordlength-1 downto 0); 
		rst: 		in std_logic;	--reset signal active high
		clk: 		in std_logic	--clock
	);
end component pre_rotation;

type angles_t is array(0 to stages-1) of integer;
constant angles : angles_t := (
				4096,
				2418,
				1277,
				648,
				325,
				162,
				81,
				40,
				20,
				10,
				5,
				2,
				1
				);

--Input for pre_rotation
--signal x_MSB : std_logic;
--signal y_MSB : std_logic;

--Output of pre-rotation
--signal x_MSB_new : std_logic;
--signal y_MSB_new : std_logic;
signal phase_offset_s : std_logic_vector(out_wordlength - 1 downto 0);
signal y_end	: std_logic_vector(out_wordlength - 1 downto 0);
signal phase_s	: std_logic_vector(out_wordlength - 1 downto 0);
--Sign Extended input for first pipeline stage
signal x_ext : 	std_logic_vector(out_wordlength - 1 downto 0);
signal y_ext : 	std_logic_vector(out_wordlength - 1 downto 0);


--Array of std_logic_vector, these are the input/output for each pipeline stage 
type vector_t is array(0 to stages-1) of std_logic_vector(out_wordlength - 1 downto 0);	
signal x_pipeline:		vector_t;
signal y_pipeline:		vector_t;
signal phase_pipeline:		vector_t;


begin
----Sign extension
--		EXT_X:	x_ext(out_wordlength - 1 downto in_wordlength -1)<= (others => x_MSB_new);
--			x_ext(in_wordlength - 2 downto 0) <= x_in(in_wordlength - 2 downto 0);
--		EXT_Y:	y_ext(out_wordlength - 1 downto in_wordlength -1)<= (others => y_MSB_new);
--			y_ext(in_wordlength - 2 downto 0) <= y_in(in_wordlength - 2 downto 0);

--Mapping of input/output signals for pre-rotation	
	PRE_ROT: pre_rotation 
		generic map(in_wordlength, out_wordlength)
		 port map(
				x_in => x_in,
				y_in => y_in,
				x_out => x_ext,
				y_out => y_ext,
				phase_offset => phase_offset_s,
				rst => rst,
				clk => clk
				);	

		STAGE_1: cordic_pipeline_stage 
			generic map(stage_number => 0, wordlength => out_wordlength) 
			port map(
				x_in => x_ext,
				y_in => y_ext,
				x_out => x_pipeline(0),
				y_out => y_pipeline(0),
				current_angle => std_logic_vector(to_signed(angles(0),out_wordlength)),
				phase_in => phase_offset_s,
				phase_out => phase_pipeline(0),
				clk => clk,
				rst => rst
				);
	
--Generation of pipeline stages
	GEN: for i in 1 to (stages-1) generate
		
		STAGE: cordic_pipeline_stage 
			generic map(stage_number => i, wordlength => out_wordlength) 
			port map(
				x_in => x_pipeline(i-1),
				y_in => y_pipeline(i-1),
				x_out => x_pipeline(i),
				y_out => y_pipeline(i),
				current_angle => std_logic_vector(to_signed(angles(i),out_wordlength)),
				phase_in => phase_pipeline(i-1),
				phase_out => phase_pipeline(i),
				clk => clk,
				rst => rst
				);
	end generate GEN;
	
	STAGE_last: cordic_pipeline_stage 
			generic map(stage_number => stages-1, wordlength => out_wordlength) 
			port map(
				x_in => x_pipeline(stages-1),
				y_in => y_pipeline(stages-1),
				x_out => radius,
				y_out => y_end,
				current_angle => std_logic_vector(to_signed(angles(stages-1),out_wordlength)),
				phase_in => phase_pipeline(stages-1),
				phase_out => phase,
				clk => clk,
				rst => rst
				);
	
end bhv;