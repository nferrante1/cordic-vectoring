function gain = gain_cordic(steps_number)
%GAIN_FLOAT Compute the gain of cordic vectoring mode
%   the value depend on the number of steps to compute
    %Expression of gain;
    gain = prod(( sqrt(1.0 + 2.^(-2.*linspace(0,steps_number-1,steps_number)))));
end

