function [radius, phase, x_accumulator , y_accumulator, phase_accumulator] = cordic_vectoring_q(x_val,y_val,initial_phase, steps_number)
  
    %Accumulate successive iterations partial results
    %Current iteration
    x_accumulator(1:steps_number) = x_val;
    y_accumulator(1:steps_number) = y_val;
    phase_accumulator(1:steps_number) = initial_phase;
   
    %Previous iteration
    x_accumulator_prev(1:steps_number) = x_val;
    y_accumulator_prev(1:steps_number) = y_val;
    phase_accumulator_prev(1:steps_number) = initial_phase;
    
    %generate angles vector
    angle_file = fopen("input/angles_q.in","r");
    angles = fscanf(angle_file, "%d");
    fclose(angle_file);
   
    k = 1;
   
    %start loop
    while k <= steps_number
        if(y_accumulator_prev(k) < 0)        
           %Update current accumulator values applying cordic algorithm
            x_accumulator(k) = (x_accumulator_prev(k) - (floor(y_accumulator_prev(k)/(2^(k-1)))));
            y_accumulator(k) = (y_accumulator_prev(k) + (floor(x_accumulator_prev(k)/(2^(k-1)))));  
            phase_accumulator(k) = (phase_accumulator_prev(k) - (floor(angles(k))));
        else
            x_accumulator(k) = (x_accumulator_prev(k) + (floor(y_accumulator_prev(k)/(2^(k-1)))));
            y_accumulator(k) = (y_accumulator_prev(k) - (floor(x_accumulator_prev(k)/(2^(k-1)))));  
            phase_accumulator(k) = (phase_accumulator_prev(k) + (floor(angles(k))));
        end   
         %Update previous accumulator values for the next iteration
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
