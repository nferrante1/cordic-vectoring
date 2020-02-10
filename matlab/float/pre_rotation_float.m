% This function implements CORDIC pre-rotation in float version
% Inputs/outputs are floating point numbers
function [new_x, new_y, initial_phase] = pre_rotation_float (x_val, y_val)
    new_x = x_val;
    new_y = y_val;
    initial_phase = 0;

    if (x_val < 0) % The point is in 2nd or 3rd quadrant (outside convergence cone)
        if (y_val < 0) % The point is in 3rd quadrant
            % Rotate to 1st quadrant
            initial_phase = -pi;
        else % The point is in 2nd quadrant
            % Rotate to 4th quadrant
            initial_phase = pi;
        end
        % When rotating we move the point to the symmetric wrt the origin
        new_y = -y_val; 
        new_x = -x_val; 
    end
end