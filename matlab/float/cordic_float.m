% Test for cordic implementation floating point

clear variables;
close all;

input_dir = "input";
output_dir = "output";
if ~exist(input_dir, 'dir')
	mkdir(input_dir)
end
if ~exist(output_dir, 'dir')
	mkdir(output_dir)
end

%-------------Paramenters to set-------------------------------------------
% wordlength --> for fixed point length in bit of the values of x, y and angles
wordlength = 16;

% steps_number --> number of steps for cordic
steps_number = 14;
%--------------------------------------------------------------------------

%-------------Generate input values----------------------------------------
% Generate input as points lying on circles with different radius
theta = (-pi:0.25:pi);
r = (0.1:0.005:0.9);

% Corresponding Cartesian coordintates
x = r' * cos(theta);
y = r' * sin(theta);
%--------------------------------------------------------------------------

%-------------CORDIC_FLOAT-------------------------------------------------
% This is used for the call of arrayfun
steps_number_arr = steps_number.*ones(size(x));
%Compute gain
gain = gain_cordic(steps_number);

% Pre-rotation
[x_val, y_val, phase_offset] = arrayfun(@pre_rotation_float, x, y);
% CORDIC
[radius, phase, x_accumulator, y_accumulator, phase_accumulator] = arrayfun(@cordic_vectoring_float, x_val, y_val, phase_offset, steps_number_arr, 'UniformOutput', false);
%--------------------------------------------------------------------------

%-------------Check results------------------------------------------------
% Output of arrayfun is a cell and must be converted to matrix
phase = cell2mat(phase);
radius = cell2mat(radius);

% Correct the radius dividing by the gain
corrected_radius = radius./gain;

% Compute expected values for phase and radius using arctan for phase and
% sqrt(x^2 + y^2) for radius
[compare_radius, compare_phase] = arrayfun(@to_polar, x, y);

% Compute mean square error for phase and radius
MSE_radius = mean((compare_radius - corrected_radius).^2, "all");
MSE_phase = mean((compare_phase - phase).^2, "all");

% Root squared errors
error_radius = sqrt((compare_radius - corrected_radius).^2);
error_phase = sqrt((compare_phase - phase).^2);
%--------------------------------------------------------------------------
