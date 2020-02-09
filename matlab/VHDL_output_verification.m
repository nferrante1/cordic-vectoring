%VHDL output verification

output_dir = "output";

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

%read vhdl output from file
file = fopen("output/r_q.in");
radius_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);

file = fopen("output/p_q.in");
phase_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);

phase_vhdl = phase_vhdl * phase_lsb;
radius_vhdl = radius_vhdl * in_lsb;
corrected_radius_vhdl = radius./gain;

%compute mean error
MSE_radius_vhdl = sqrt(mean((compare_radius - corrected_radius_vhdl).^2, "all"));
MSE_phase_vhdl = sqrt(mean((compare_phase - phase_vhdl).^2, "all"));

%root squared errors
error_radius_vhdl = sqrt((compare_radius - corrected_radius_vhdl).^2);
error_phase_vhdl = sqrt((compare_phase - phase_vhdl).^2);

%difference between errors in matlab and vhdl, for model goodness
%verification
quantized2vhdl_error_radius = error_radius_q - error_radius_vhdl;
quantized2vhdl_error_phase = error_phase_q - error_phase_vhdl;
