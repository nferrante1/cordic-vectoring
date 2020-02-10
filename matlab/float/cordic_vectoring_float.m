function [radius, phase, x_accumulator, y_accumulator, phase_accumulator] = cordic_vectoring_float(x_val,y_val, initial_phase, steps_number)
%CORDIC_VECTORING_FLOAT CORDIC Vectoring mode implementation with floating  
% point numbers
% x_val and y_val represent a point on the cartesian plane.
%radius and phase represent the corresponding polar conversion 

  
    %Accumulate successive iterations partial results
    %Current iteration
    x_accumulator(1:steps_number) = x_val;
    y_accumulator(1:steps_number) = y_val;
    phase_accumulator(1:steps_number) = initial_phase;
   
    %Previous iteration
    x_accumulator_prev(1:steps_number) = x_val;
    y_accumulator_prev(1:steps_number) = y_val;
    phase_accumulator_prev(1:steps_number) = initial_phase;
   
    %Compute angles
        angles_generator = 1./(2.^(0:1:steps_number-1));
        angles = atan(angles_generator); %Generate elementary angles
   
    k = 1;
   
    %start loop
    while k <= steps_number
        if(y_accumulator_prev(k) < 0)
            sigma = 1;
        else
            sigma = -1;
        end
        
        %Update current accumulator values applying cordic algorithm
        x_accumulator(k) = (x_accumulator_prev(k) - (sigma*y_accumulator_prev(k)/(2^(k-1))));
        y_accumulator(k) = (y_accumulator_prev(k) + (sigma*x_accumulator_prev(k)/(2^(k-1))));  
        phase_accumulator(k) = (phase_accumulator_prev(k) - (sigma*angles(k)));
        
%         %Update previous accumulator values for the next iteration
         x_accumulator_prev(k+1) = x_accumulator(k);
         y_accumulator_prev(k+1) = y_accumulator(k);
         phase_accumulator_prev(k+1) = phase_accumulator(k);
        
        k = k+1;
    end

    % At the end x_accumulator will contain the radius of the vector
    % and phase_accumulator will contain the phase of the vector
    radius = x_accumulator(steps_number);
    phase = phase_accumulator(steps_number);

end
