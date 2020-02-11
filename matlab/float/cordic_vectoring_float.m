% Vectoring mode implementation with floating point numbers
% x_val and y_var are a point of the Cartesian plane
% radius and phase are the corresponding polar conversion
function [radius, phase, x_accumulator, y_accumulator, phase_accumulator] = cordic_vectoring_float(x_val,y_val, initial_phase, steps_number)
	% Accumulate successive iterations partial results
	% Current iteration
	x_accumulator(1:steps_number) = x_val;
	y_accumulator(1:steps_number) = y_val;
	phase_accumulator(1:steps_number) = initial_phase;

	% Previous iteration
	x_accumulator_prev(1:steps_number) = x_val;
	y_accumulator_prev(1:steps_number) = y_val;
	phase_accumulator_prev(1:steps_number) = initial_phase;

	% Create angles vector
	angles_generator = 1./(2.^(0:1:steps_number-1));
	% Generate elementary angles
	angles = atan(angles_generator);

	k = 1;
	% Start loop
	while k <= steps_number
		% Compute sigma
		if (y_accumulator_prev(k) < 0)
			sigma = 1;
		else
			sigma = -1;
		end

		% Update current accumulator values applying cordic
		% algorithm
		x_accumulator(k) = (x_accumulator_prev(k) - (sigma*y_accumulator_prev(k)/(2^(k - 1))));
		y_accumulator(k) = (y_accumulator_prev(k) + (sigma*x_accumulator_prev(k)/(2^(k - 1))));
		phase_accumulator(k) = (phase_accumulator_prev(k) - (sigma*angles(k)));

		% Update previous accumulator values for the next
		% iteration
		x_accumulator_prev(k + 1) = x_accumulator(k);
		y_accumulator_prev(k + 1) = y_accumulator(k);
		phase_accumulator_prev(k + 1) = phase_accumulator(k);

		k = k + 1;
	end

	% At the end x_accumulator will contain the radius of the
	% vector and phase_accumulator will contain the phase of
	% the vector
	radius = x_accumulator(steps_number);
	phase = phase_accumulator(steps_number);
end
