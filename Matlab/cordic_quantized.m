%cordic quantized
close all;
clear variables;

%-------------Paramenter to set:-------------------------------------------
%in_wordlength --> length of input in bits
in_wordlength = 16;

%steps --> number of steps for cordic
steps = 13; 
%we choose 13 becouse the elementary angles, when quantized, are 0 after
%the 13th value (2^-12 --> 1, 2^-13 --> 0). So with 16 bit inputs 13 steps
%of cordic are sufficient

%--------------------------------------------------------------------------

%-------------generate input values----------------------------------------
%Generate input as points lying on circles with different radius
theta = (-pi:0.25:pi);
r = (0.1:0.005:0.9);

x = r' * cos(theta);
y = r' * sin(theta);

%-------------quantize input values----------------------------------------
in_lsb = max(max(x))/2^((in_wordlength-1)-1); %compute lsb value 
x_q = floor(x./in_lsb);
y_q = floor(y./in_lsb);

%-------------generate angles values---------------------------------------
%Compute angles
angles_generator = 1./(2.^(0:1:steps-1));
angles = atan(angles_generator); %Generate elementary angles



%-------------quantize angles values---------------------------------------
phase_lsb = pi / 2^((in_wordlength-1)-1);
angles_q = floor(angles./phase_lsb);

pi_q = floor(pi/phase_lsb);
pi_neg_q = floor(-pi/phase_lsb);
a_file = fopen("input/angles_q.in", "w");
fprintf(a_file, "%d\n",angles_q);
fclose(a_file);

%-------------CORDIC_QUANTIZED---------------------------------------------

%This is used for the call of arrayfun
steps_number_arr = steps.*ones(size(x_q));
p_lsb_arr = phase_lsb.*ones(size(x_q));
%Compute gain
gain = gain_cordic(steps);

[new_x_q,new_y_q, initial_phase_q] = arrayfun(@pre_rotation_q,x_q,y_q,p_lsb_arr);
[radius_q, phase_q, x_accumulator , y_accumulator, phase_accumulator] = arrayfun(@cordic_vectoring_q,new_x_q,new_y_q,initial_phase_q,steps_number_arr,'UniformOutput',false);

phase_q = cell2mat(phase_q);
radius_q = cell2mat(radius_q);

phase = phase_q * phase_lsb;
radius = radius_q * in_lsb;

corrected_radius = radius./gain;


[compare_radius, compare_phase] = arrayfun(@to_polar ,x, y);

%compute root mean square error on phase and radius
MSE_radius = sqrt(mean((compare_radius - corrected_radius).^2));
MSE_phase = sqrt(mean((compare_phase - phase).^2));

%root squared errors
error_radius = sqrt((compare_radius - corrected_radius).^2);
error_phase = sqrt((compare_phase - phase).^2);


%---Save input, output to file
file = fopen("input/x_q.in", "w");
fprintf(file, "%d\n",x_q);
fclose(file);


file = fopen("input/y_q.in", "w");
fprintf(file, "%d\n",y_q);
fclose(file);


file = fopen("output/radius_q.in", "w");
fprintf(file, "%d\n",radius_q);
fclose(file);

file = fopen("output/phase_q.in", "w");
fprintf(file, "%d\n",phase_q);
fclose(file);


