% VHDL output verification
% This script must be run after quantized/cordic_quantized.m
% since it takes some variables from the workspace created
% by that script

output_dir = "output";
if ~exist(output_dir, 'dir')
	mkdir(output_dir)
end

% Read vhdl output from file
% Radius
file = fopen("output/r_q.in");
radius_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);
% Phase
file = fopen("output/p_q.in");
phase_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);

% "weighting" with the value of LSB
phase_vhdl = phase_vhdl * phase_lsb;
radius_vhdl = radius_vhdl * in_lsb;
% Correct the radius dividing by the gain
corrected_radius_vhdl = radius_vhdl./gain;

% Compute mean square error
MSE_radius_vhdl = mean((compare_radius - corrected_radius_vhdl).^2, "all");
MSE_phase_vhdl = mean((compare_phase - phase_vhdl).^2, "all");

% Root squared errors
error_radius_vhdl = sqrt((compare_radius - corrected_radius_vhdl).^2);
error_phase_vhdl = sqrt((compare_phase - phase_vhdl).^2);

% Difference between errors in matlab and VHDL, for VHDL
% model goodness verification
quantized2vhdl_error_radius = error_radius_q - error_radius_vhdl;
quantized2vhdl_error_phase = error_phase_q - error_phase_vhdl;

% Should be both zero
has_implementation_error_radius = max(max(abs(quantized2vhdl_error_radius)));
has_implementation_error_phase = max(max(abs(quantized2vhdl_error_phase)));
