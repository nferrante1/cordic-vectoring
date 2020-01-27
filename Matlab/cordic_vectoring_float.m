function [radius, phase] = cordic_vectoring_float(x_val,y_val, steps_number)
%CORDIC_VECTORING_FLOAT CORDIC Vectoring mode implementation with floating  
% point numbers
% x_val and y_val are input values, representing a point on the cartesian
% plane.
% steps_number represent the number of steps performed by cordic to
% determine the result. Remember that cordic converge with 1 bit of
% precision per step (k bit of precision --> k steps)
  
    %Accumulate successive iterations partial results
    %Current iteration
    x_accumulator = x_val;
    y_accumulator = y_val;
    phase_accumulator = 0;
   
    %Previous iteration
    x_accumulator_prev = x_val;
    y_accumulator_prev = y_val;
    phase_accumulator_prev = 0;
    
    %generate angles vector
    angle_file = fopen("input/angles_float.in","r");
    angles = fscanf(angle_file, "%f");
    fclose(angle_file);
   
    k = 1;
   
    %start loop
    while k < steps_number
        if(y_accumulator_prev < 0)
            sigma = 1;
        else
            sigma = -1;
        end
        
        %Update current accumulator values applying cordic algorithm
        x_accumulator = (x_accumulator_prev - (sigma*y_accumulator_prev/(2^(k-1))));
        y_accumulator = (y_accumulator_prev + (sigma*x_accumulator_prev/(2^(k-1))));  
        phase_accumulator = (phase_accumulator_prev - (sigma*angles(k)));
        
%         %Update previous accumulator values for the next iteration
         x_accumulator_prev = x_accumulator;
         y_accumulator_prev = y_accumulator;
         phase_accumulator_prev = phase_accumulator;
        
        k = k+1;
    end

    % At the end x_accumulator will contain the radius of the vector
    % and phase_accumulator will contain the phase of the vector
    radius = x_accumulator;
    phase = phase_accumulator;

end

