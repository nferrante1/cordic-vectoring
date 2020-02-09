%VHDL output verification

output_dir = "output";

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

%read output from file
file = fopen("output/r_q.in");
radius_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);

file = fopen("output/p_q.in");
phase_vhdl = fscanf(file, "%d", size(x_q));
fclose(file);

qp_error = phase_q - phase_vhdl;
qr_error = radius_q - radius_vhdl;

phase_vhdl = phase_vhdl * phase_lsb;
radius_vhdl = radius_vhdl * in_lsb;
corrected_radius_vhdl = radius./gain;

%compute error
MSE_radius_vhdl = sqrt(mean((compare_radius - corrected_radius_vhdl).^2));
MSE_phase_vhdl = sqrt(mean((compare_phase - phase_vhdl).^2));

%root squared errors
error_radius_vhdl = sqrt((compare_radius - corrected_radius_vhdl).^2);
error_phase_vhdl = sqrt((compare_phase - phase_vhdl).^2);
