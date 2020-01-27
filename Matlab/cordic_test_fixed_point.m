%Test for cordic implementation floating point
%Clean the workspace
clear all;
fclose('all');
%Generate new input files;
generate_input;

%set fixed point math properties
G = globalfimath('RoundMode','Floor','OverflowMode','Wrap');

%Parameters to set: 
%steps_number --> for angles generation
steps_number = 13;
frac_part = steps_number;
%wordlength --> for fixed point length in bit of the values of x, y and angles
wordlength = 16;

file = fopen("input/x_float.in", "r");
x_in = fscanf(file, "%f");
fclose(file);

file = fopen("input/y_float.in", "r");
[y_in, num_in] = fscanf(file, "%f");
fclose(file);

%transform in signed integers in fixed point notation
x_in = fi(x_in, 1,wordlength,frac_part);
y_in = fi(y_in, 1,wordlength,frac_part);
nt(1:1440,1) = numerictype(x_in);
%Compute gain

gain = fi(1/gain_cordic(steps_number),1,wordlength,frac_part);

steps_number = steps_number.*ones(num_in, 1);

%fixed point notation properties
nt(1:1440,1) = numerictype(x_in);

%Run cordic
%With fixed point numbers with

[x_fixed, y_fixed, fixed_phase_offset] = arrayfun(@pre_rotation_fixed, x_in, y_in, nt );
[fixed_radius, fixed_phase] = arrayfun(@cordic_vectoring_fixed,x_fixed, y_fixed, steps_number, nt);

%Apply gain correction and phase correction
corrected_radius = mpy(G, fixed_radius(:), gain); %Fixed point multiplication
corrected_phase = fixed_phase - fixed_phase_offset;

%Compute phase with traditional method to have a reference value
[compare_radius, compare_phase] = arrayfun(@to_polar ,x_in, y_in);

%compute root mean square error on phase and radius 
 MSE_radius = sqrt(mean((compare_radius - corrected_radius).^2));
 MSE_phase = sqrt(mean((compare_phase - corrected_phase).^2));
 
 error_radius = sqrt((compare_radius - corrected_radius).^2);
 error_phase = sqrt((compare_phase - corrected_phase).^2);
 error_phase = mod(error_phase, fi(2*pi,1,wordlength,frac_part));