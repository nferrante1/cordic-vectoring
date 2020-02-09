%Test for cordic implementation floating point
%Clean the workspace
clear variables
close all

input_dir = "input";
output_dir = "output";

if ~exist(input_dir, 'dir')
    mkdir(input_dir)
end
if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

%Paramenter to set:
%wordlength --> for fixed point length in bit of the values of x, y and angles
wordlength = 16;
%steps_number --> for angles generation
steps_number = 14;

%Generate input as points lying on circles with different radius
theta = (0:5:355);
r = (0.1:0.1:2.0);

x = r' * cos(theta);
y = r' * sin(theta);

%Compute gain
gain = gain_cordic(steps_number);


%Run cordic
%With floating point numbers
steps_number_arr = steps_number.*ones(size(x)); %This is used for the call of arrayfun

[x_val, y_val, phase_offset] = arrayfun(@pre_rotation_float, x, y);
[radius, phase, x_accumulator, y_accumulator, phase_accumulator] = arrayfun(@cordic_vectoring_float,x_val, y_val, phase_offset, steps_number_arr,'UniformOutput',false);

%Output of arrayfun is a cell and must be converted to matrix
phase = cell2mat(phase);
radius = cell2mat(radius);

%Correct the radius dividing by the gain
corrected_radius = radius./gain;

%Compute expected values for phase and radius using arctan for phase 
%and sqrt(x^2 + y^2) for radius
[compare_radius, compare_phase] = arrayfun(@to_polar ,x, y);

%compute root mean square error for phase and radius
MSE_radius = sqrt(mean((compare_radius - corrected_radius).^2, "all"));
MSE_phase = sqrt(mean((compare_phase - phase).^2, "all"));

%root squared errors
error_radius = sqrt((compare_radius - corrected_radius).^2);
error_phase = sqrt((compare_phase - phase).^2);
