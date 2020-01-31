%Test for cordic implementation floating point
%Clean the workspace
clear all
close all

%Parameters to set: 
%steps_number --> for angles generation
steps_number = 13;

%Read input files
float_file = fopen("input/x_float.in", "r");
[x_in, num_in] = fscanf(float_file, "%f");
fclose(float_file);

float_file = fopen("input/y_float.in", "r");
[y_in, num_in] = fscanf(float_file, "%f");
fclose(float_file);

%Compute gain
gain = gain_cordic(steps_number);


%Run cordic
%With floating point numbers
global current_graph;
current_graph = 0;
steps_number_arr = steps_number.*ones(num_in, 1); %This is used for the call of arrayfun
[x_val, y_val, phase_offset] = arrayfun(@pre_rotation_float, x_in, y_in);
[radius, phase] = arrayfun(@cordic_vectoring_float,x_val, y_val, steps_number_arr);

corrected_radius = radius./gain;
corrected_phase = phase - phase_offset;

[compare_radius, compare_phase] = arrayfun(@to_polar ,x_in, y_in);

%compute root mean square error on phase and radius
MSE_radius = sqrt(mean((compare_radius - corrected_radius).^2));
MSE_phase = sqrt(mean((compare_phase - corrected_phase).^2));

%root squared errors
error_radius = sqrt((compare_radius - corrected_radius).^2);
error_phase = sqrt((compare_phase - corrected_phase).^2);

X = [x_in, x_val];
Y = [y_in, y_val];
R = [compare_radius, corrected_radius, radius];
P = [rad2deg(compare_phase), rad2deg(corrected_phase)];
A = [X,Y,R,P];