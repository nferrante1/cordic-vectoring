% This function computes the gain of cordic vectoring mode
% The value depends only on the number of steps to compute
function gain = gain_cordic(steps_number)
    gain = prod((sqrt(1.0 + 2.^(-2.*linspace(0, steps_number - 1, steps_number)))));
end