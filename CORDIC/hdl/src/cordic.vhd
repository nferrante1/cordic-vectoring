library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This is the main module, which contains pre_rotation and all the pipeline_stage modules
-- Generic parameters are:
	-- stages: number of stages for the pipeline, in other words is the number of iterations of the algorithm
	-- in_wordlength: needed for input dimensioning
	-- out_worldlength: needed for output dimensioning and pipeline_stages in/out dimensioning

--CORDIC entity-----------------------------------------------------------------------------
entity cordic is generic(stages: INTEGER := 13; in_wordlength: INTEGER := 16; out_wordlength: INTEGER := 20);
	port(
		-- Input x,y
		x_in:	in std_logic_vector(in_wordlength-1 downto 0);
		y_in:	in std_logic_vector(in_wordlength-1 downto 0);
		-- Output radius, phase
		radius:	out std_logic_vector(out_wordlength-1 downto 0);
		phase:	out std_logic_vector(out_wordlength-1 downto 0);
		-- Clock and reset signals
		clk:	in std_logic; -- Clock
		rst:	in std_logic -- Reset signal (active-high)
	);
end cordic;
--------------------------------------------------------------------------------------------

--CORDIC architecture-----------------------------------------------------------------------
architecture bhv of cordic is
--Needed components-------------------------------------------------------------------------
	component cordic_pipeline_stage is generic(stage_number: INTEGER; wordlength: INTEGER);
		port(
			x_in:		in std_logic_vector(wordlength - 1 downto 0);
			y_in:		in std_logic_vector(wordlength - 1 downto 0);
			x_out:		out std_logic_vector(wordlength - 1 downto 0);
			y_out:		out std_logic_vector(wordlength - 1 downto 0);
			current_angle:	in std_logic_vector(wordlength - 1 downto 0);
			phase_in:	in std_logic_vector(wordlength - 1 downto 0);
			phase_out:	out std_logic_vector(wordlength - 1 downto 0);
			clk:		in std_logic; -- Clock
			rst:		in std_logic -- Reset signal active high
		);
	end component cordic_pipeline_stage;

	component pre_rotation is generic (in_wordlength: INTEGER; out_wordlength: INTEGER);
		port(
			x_in: 		in std_logic_vector(in_wordlength -1 downto 0);
			y_in: 		in std_logic_vector(in_wordlength -1 downto 0);
			x_out: 		out std_logic_vector(out_wordlength-1 downto 0);
			y_out: 		out std_logic_vector(out_wordlength-1 downto 0);
			phase_offset:	out std_logic_vector(out_wordlength-1 downto 0);
			rst: 		in std_logic;	-- Reset signal active high
			clk: 		in std_logic	-- Clock
		);
	end component pre_rotation;
--------------------------------------------------------------------------------------------

--Angles------------------------------------------------------------------------------------
-- This type is needed for driving the elementary angles signals towards the pipeline stages
	type angles_t is array(0 to stages-1) of INTEGER;
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
--------------------------------------------------------------------------------------------

--Signals-----------------------------------------------------------------------------------
	-- Needed to drive output values of a module towards other modules
	-- Phase offset: out for pre_rotation; in for first pipeline_stage
	signal phase_offset_s	: std_logic_vector(out_wordlength-1 downto 0);

	signal y_end		: std_logic_vector(out_wordlength-1 downto 0); -- Final y (will be thrown away)
	signal phase_s		: std_logic_vector(out_wordlength-1 downto 0); -- Final phase

	-- Sign extended input for first pipeline stage
	signal x_ext		: std_logic_vector(out_wordlength-1 downto 0);
	signal y_ext		: std_logic_vector(out_wordlength-1 downto 0);

	-- Array of std_logic_vector, these are the input/output for each pipeline stage
	type vector_t is array(0 to stages-1) of std_logic_vector(out_wordlength-1 downto 0);
	signal x_pipeline	: vector_t;
	signal y_pipeline	: vector_t;
	signal phase_pipeline	: vector_t;
--------------------------------------------------------------------------------------------

	begin

--Port mappings-----------------------------------------------------------------------------
--Mapping for pre-rotation
		PRE_ROT: pre_rotation generic map(in_wordlength, out_wordlength)
			port map(
				x_in => x_in,
				y_in => y_in,
				x_out => x_ext,
				y_out => y_ext,
				phase_offset => phase_offset_s,
				rst => rst,
				clk => clk
			);
-- Mapping for first pipeline stage
		STAGE_0: cordic_pipeline_stage generic map(stage_number => 0, wordlength => out_wordlength)
			port map(
				x_in => x_ext,
				y_in => y_ext,
				x_out => x_pipeline(0),
				y_out => y_pipeline(0),
				current_angle => std_logic_vector(to_signed(angles(0), out_wordlength)),
				phase_in => phase_offset_s,
				phase_out => phase_pipeline(0),
				clk => clk,
				rst => rst
			);

-- Mapping of others pipeline stages
		GEN: for i in 1 to (stages-1) generate -- Generate pipeline stages
			STAGE: cordic_pipeline_stage generic map(stage_number => i, wordlength => out_wordlength)
				port map(
					x_in => x_pipeline(i-1),
					y_in => y_pipeline(i-1),
					x_out => x_pipeline(i),
					y_out => y_pipeline(i),
					current_angle => std_logic_vector(to_signed(angles(i), out_wordlength)),
					phase_in => phase_pipeline(i-1),
					phase_out => phase_pipeline(i),
					clk => clk,
					rst => rst
				);
		end generate GEN;
--------------------------------------------------------------------------------------------

--Output------------------------------------------------------------------------------------
		-- RADIUS
		radius<=x_pipeline(stages-1);
		-- The output radius of these cordic implementation is affected by the gain.
		-- If we want to remove this gain we can simply add a multiplier and multiply
		-- the last x_pipeline value by a fixed factor inv_gain:

		-- radius <= std_logic_vector(signed(x_pipeline(stages-1))*signed(inv_gain));

		-- The choice of not using such multiplication has been done because a multiplier
		-- has an high area occupancy and power consumption, and CORDIC is generally used in
		-- constrained devices.

		-- PHASE
		phase<=phase_pipeline(stages-1);
end bhv; -- cordic
--------------------------------------------------------------------------------------------
