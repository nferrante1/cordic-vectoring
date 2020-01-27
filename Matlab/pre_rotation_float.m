
function [new_x, new_y, initial_phase] = pre_rotation_float (x_val, y_val)
% CORDIC_PRE_ROTATION_REAL Pre-rotation of x,y values to allow cordic to 
% converge (x_val,y_val are floating point numbers )

new_x = x_val;
new_y = y_val;
initial_phase = 0;
if( x_val < 0) % then the point is in 2nd or 3rd quadrant. (outside convergence cone)
        if( y_val <= 0) %% then the point is in 3rd quadrant
            initial_phase = pi;
        else
            initial_phase = -pi; %%then the point is in 2nd quadrant
        end
           new_y = -y_val;
           new_x = -x_val; 
end
           
    
    