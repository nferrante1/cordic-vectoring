%Test for cordic implementation floating point
%Clean the workspace
clear all
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
%frac_len--> for fractional length of fixed point numbers
frac_len = 13;

%Generate input as points lying on circles with different radius
theta = (0:5:355);
r = (0.1:0.1:2.0);

x = r' * cos(theta);
y = r' * sin(theta);

%Compute angles
angles_generator = 1./(2.^(0:1:steps_number-1));
angles_float = atan(angles_generator); %Generate elementary angles

% Write angles
angle_file = fopen(input_dir + "/angles_float.in", "w");
fprintf(angle_file, "%.32f\n",angles_float(:,:));
fclose(angle_file);

%Write floating point to file
x_file = fopen(input_dir + "/x_float.in", "w");
y_file = fopen(input_dir + "/y_float.in", "w");

fprintf(x_file, "%.10f\n",x(:,:));
fprintf(y_file, "%.10f\n",y(:,:));

fclose(x_file);
fclose(y_file);

%Read input files
float_file = fopen(input_dir + "/x_float.in", "r");
[x_in, num_in] = fscanf(float_file, "%f");
fclose(float_file);

float_file = fopen(input_dir + "/y_float.in", "r");
[y_in, num_in] = fscanf(float_file, "%f");
fclose(float_file);

%Compute gain
gain = gain_cordic(steps_number);


%Run cordic
%With floating point numbers
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
% 
% X = [x_in, x_val];
% Y = [y_in, y_val];
% R = [compare_radius, corrected_radius, radius];
% P = [rad2deg(compare_phase), rad2deg(corrected_phase)];
% A = [X,Y,R,P];