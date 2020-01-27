
%generate_input
%Clean workspace
clear all
close all

%Paramenter to set:
%wordlength --> for fixed point length in bit of the values of x, y and angles
wordlength = 16;
%steps_number --> for angles generation
steps_number = 13;

%Generate input as points lying on circles with different radius
theta = (0:5:355);
r = (0.05:0.05:1.0);

x = r' * cos(theta);
y = r' * sin(theta);

%Write floating point to file
x_file = fopen("input/x_float.in", "w");
y_file = fopen("input/y_float.in", "w");

fprintf(x_file, "%.32f\n",x(:,:));
fprintf(y_file, "%.32f\n",y(:,:));

fclose(x_file);
fclose(y_file);
%Compute fixed point equivalent

x_f = floor(x.*2^wordlength); 
y_f = floor(y.*2^wordlength);

%Write fixed point to file (integer equivalent)
x_file = fopen("input/x_fixed_int.in", "w");
y_file = fopen("input/y_fixed_int.in", "w");

fprintf(x_file, "%d\n",x_f(:,:));
fprintf(y_file, "%d\n",y_f(:,:));

fclose(x_file);
fclose(y_file);

%Compute fractional fixed point equivalent
x_f_eq = x_f./2^wordlength;
y_f_eq = y_f./2^wordlength;

%Write fixed point to file (fractional notation)
x_file = fopen("input/x_fixed_frac.in", "w");
y_file = fopen("input/y_fixed_frac.in", "w");

fprintf(x_file, "%f\n",x_f_eq(:,:));
fprintf(y_file, "%f\n",y_f_eq(:,:));

fclose(x_file);
fclose(y_file);

%Compute angles
angles_generator = 1./(2.^(0:1:steps_number-1));
angles_float = atan(angles_generator); %Generate elementary angles
angles_fixed_int = floor(angles_float.*2^wordlength);
angles_fixed = angles_fixed_int./2^wordlength;

%Write angles to file
fixed_file = fopen("input/angles_fixed_frac.in", "w");
float_file = fopen("input/angles_float.in", "w");
fixed_int_file = fopen("input/angles_fixed_int.in", "w");

fprintf(fixed_file, "%f\n",angles_fixed(:,:));
fprintf(float_file, "%.32f\n",angles_float(:,:));
fprintf(fixed_int_file, "%d\n", angles_fixed_int(:));

fclose(fixed_file);
fclose(float_file);
fclose(fixed_int_file);

