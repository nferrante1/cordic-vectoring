
%generate_input
%Clean workspace
clear all
close all

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

%Write floating point to file
x_file = fopen("input/x_float.in", "w");
y_file = fopen("input/y_float.in", "w");

fprintf(x_file, "%.10f\n",x(:,:));
fprintf(y_file, "%.10f\n",y(:,:));

fclose(x_file);
fclose(y_file);

%Compute fixed point equivalent

x_f = fi(x, 1, wordlength, frac_len); 
y_f = fi(y, 1, wordlength, frac_len); 

%Write fixed point to file
x_file = fopen("input/x_fixed.in", "w");
y_file = fopen("input/y_fixed.in", "w");

fprintf(x_file, "%f\n",x_f(:,:));
fprintf(y_file, "%1.7f\n",y_f(:,:));

fclose(x_file);
fclose(y_file);

%Retrieve fixed point integer representation
x_f_int = x_f.storedInteger;
y_f_int = y_f.storedInteger;

%Write fixed point to file (integer representation)
x_file = fopen("input/x_fixed_int.in", "w");
y_file = fopen("input/y_fixed_int.in", "w");

fprintf(x_file, "%d\n",x_f_int(:,:));
fprintf(y_file, "%d\n",y_f_int(:,:));

fclose(x_file);
fclose(y_file);

%Compute angles
angles_generator = 1./(2.^(0:1:steps_number-1));
angles_float = atan(angles_generator); %Generate elementary angles
angles_fixed = fi(angles_float, 1, wordlength, frac_len);
angles_int = angles_fixed.storedInteger;

%Generate binary input for VHDL
angles_bin(1:steps_number,1:wordlength) = '0'; %Initialize the vector
angles_bin(1:steps_number,(wordlength-frac_len+1):wordlength) = dec2bin(angles_int); %add fractional part bits
angles_bin(:,end+1) = newline; %For printing to file

%Write angles to file
fixed_file = fopen("input/angles_fixed_frac.in", "w");
float_file = fopen("input/angles_float.in", "w");
fixed_int_file = fopen("input/angles_int.in", "w");
bin_file = fopen("input/angles_bin.in", "w");

fprintf(fixed_file, "%f\n",angles_fixed(:,:));
fprintf(float_file, "%.32f\n",angles_float(:,:));
fprintf(fixed_int_file, "%d\n", angles_int(:));
fprintf(bin_file, "%s \n", angles_bin.');

fclose(fixed_file);
fclose(float_file);
fclose(fixed_int_file);
fclose(bin_file);
