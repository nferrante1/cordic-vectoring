% Cordic quantized

% clear variables;
% close all;

input_dir = "input";
output_dir = "output";
if ~exist(input_dir, 'dir')
	mkdir(input_dir)
end
if ~exist(output_dir, 'dir')
	mkdir(output_dir)
end

%-------------Paramenters to set-------------------------------------------
% in_wordlength --> length of input in bits
in_wordlength = 16;

% steps --> number of steps for cordic
steps = 13;
% We choose 13 because the elementary angles, when quantized, are 0 after
% the 13th value (2^-12 --> 1, 2^-13 --> 0). So with 16 bit inputs 13 steps
% of cordic are sufficient
%--------------------------------------------------------------------------

%-------------Generate input values----------------------------------------
% Generate input as points lying on circles with different radius
theta = (-pi:0.25:pi);
r = (0.1:0.005:0.9);

% Corresponding Cartesian coordintates
x = r' * cos(theta);
y = r' * sin(theta);
%--------------------------------------------------------------------------

%-------------Quantize input values----------------------------------------
% Compute LSB value
in_lsb = max(max(x))/2^((in_wordlength-1)-1);
% Quantize inputs
x_q = floor(x./in_lsb);
y_q = floor(y./in_lsb);
%--------------------------------------------------------------------------

%-------------Generate angles values---------------------------------------
%Compute angles
angles_generator = 1./(2.^(0:1:steps-1));
angles = atan(angles_generator); % Generate elementary angles
%--------------------------------------------------------------------------

%-------------Quantize angles values---------------------------------------
% Compute LSB value
phase_lsb = pi / 2^((in_wordlength-1)-1);
% Quantize angles
angles_q = floor(angles./phase_lsb);

% Get quantized values of pi and -pi
pi_q = floor(pi/phase_lsb);
pi_neg_q = floor(-pi/phase_lsb);
%--------------------------------------------------------------------------

% Write angles to file (we need to do this here since this file will be
% read again from function cordic_vectoring_q
a_file = fopen(input_dir + "/angles_q.in", "w");
fprintf(a_file, "%d\n", angles_q);
fclose(a_file);

%-------------CORDIC_QUANTIZED---------------------------------------------
% This is used for the call of arrayfun
steps_number_arr = steps.*ones(size(x_q));
p_lsb_arr = phase_lsb.*ones(size(x_q));
% Compute gain
gain = gain_cordic(steps);

% Pre-rotation
[new_x_q,new_y_q, initial_phase_q] = arrayfun(@pre_rotation_q, x_q, y_q, p_lsb_arr);
% CORDIC
[radius_q, phase_q, x_accumulator , y_accumulator, phase_accumulator] = arrayfun(@cordic_vectoring_q, new_x_q, new_y_q, initial_phase_q, steps_number_arr, 'UniformOutput', false);
%--------------------------------------------------------------------------

%-------------Check results------------------------------------------------
% Output of arrayfun is a cell and must be converted to matrix
phase_q = cell2mat(phase_q);
radius_q = cell2mat(radius_q);

% "weighting" with the value of LSB.
phase_q = phase_q * phase_lsb;
radius_q = radius_q * in_lsb;
% Correct the radius dividing by the gain
corrected_radius_q = radius_q./gain;

% Compute expected values for phase and radius using arctan for phase and
% sqrt(x^2 + y^2) for radius
[compare_radius, compare_phase] = arrayfun(@to_polar, x, y);

% Compute mean square error on phase and radius
MSE_radius_q = mean((compare_radius - corrected_radius_q).^2, "all");
MSE_phase_q = mean((compare_phase - phase_q).^2, "all");

% Root squared errors
error_radius_q = sqrt((compare_radius - corrected_radius_q).^2);
error_phase_q = sqrt((compare_phase - phase_q).^2);

% Max error
max_error_radius_q = max(max(error_radius_q));
max_error_phase_q = max(max(error_phase_q));

% Compute mean square error on phase and radius with the float model
MSE_radius_fq = mean((corrected_radius - corrected_radius_q).^2, "all");
MSE_phase_fq = mean((phase - phase_q).^2, "all");

% Root squared errors (with float model)
error_radius_fq = sqrt((corrected_radius - corrected_radius_q).^2);
error_phase_fq = sqrt((phase - phase_q).^2);
%--------------------------------------------------------------------------

% Save inputs, outputs to file
file = fopen(input_dir + "/x_q.in", "w");
fprintf(file, "%d\n",x_q);
fclose(file);


file = fopen(input_dir + "/y_q.in", "w");
fprintf(file, "%d\n",y_q);
fclose(file);


file = fopen(output_dir + "/radius_q.in", "w");
fprintf(file, "%d\n",radius_q);
fclose(file);

file = fopen(output_dir + "/phase_q.in", "w");
fprintf(file, "%d\n",phase_q);
fclose(file);
