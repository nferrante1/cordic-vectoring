function [radius, phase] = cordic_vectoring_fixed(x_val,y_val, steps_number, nt)
%CORDIC_VECTORING_FLOAT CORDIC Vectoring mode implementation with fixed  
% point numbers
    
%Set fixed point properties
    %Accumulate successive iterations partial results
    %Current iteration
    x_accumulator = fi(x_val,1,nt.WordLength,nt.FractionLength);
    y_accumulator = fi(y_val,1,nt.WordLength,nt.FractionLength);
    phase_accumulator = fi(0,1,nt.WordLength,nt.FractionLength);
   
    %Previous iteration
    x_accumulator_prev = fi(x_val,1,nt.WordLength,nt.FractionLength);    
    y_accumulator_prev = fi(y_val,1,nt.WordLength,nt.FractionLength);
    phase_accumulator_prev = fi(0,1,nt.WordLength,nt.FractionLength);
      
   %read angles from file
   angles(1,1:nt.FractionLength) = fi(0,1,nt.WordLength,nt.FractionLength);
   file = fopen("input/angles_fixed_frac.in", "r");
   angles_f = fscanf(file, "%f"); %Read as double
   fclose(file);
  
   angles = fi(angles_f,1,nt.WordLength,nt.FractionLength);  %Transform to fi object
    
    k = 1;
   
    %start loop
    while k <= steps_number
        if(y_accumulator_prev < 0)
           sigma = 1;
        else
            sigma = -1;
        end
        
        %Update current accumulator values applying cordic algorithm
        if(sigma > 0)
            x_accumulator = (x_accumulator_prev - (bitsra(y_accumulator_prev,k-1)));
            y_accumulator = (y_accumulator_prev + (bitsra(x_accumulator_prev,k-1)));  
            phase_accumulator = (phase_accumulator_prev - angles(k));
        else
            x_accumulator = (x_accumulator_prev + (bitsra(y_accumulator_prev,k-1)));
            y_accumulator = (y_accumulator_prev - (bitsra(x_accumulator_prev,k-1)));  
            phase_accumulator = (phase_accumulator_prev + angles(k));
        end
        %Update previous accumulator values for the next iteration
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

