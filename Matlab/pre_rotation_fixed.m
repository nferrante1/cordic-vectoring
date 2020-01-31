function [new_x, new_y, initial_phase] = pre_rotation_fixed (x_val, y_val, nt)
% CORDIC_PRE_ROTATION_REAL Pre-rotation of x,y values to allow cordic to 
% converge (x_val,y_val are fixed point numbers )
 
%Set fixed point properties and initialize variables

new_x = fi(x_val,1,nt.WordLength,nt.FractionLength);
new_y = fi(y_val,1,nt.WordLength,nt.FractionLength);
initial_phase = fi(0,1,nt.WordLength,nt.FractionLength);

if( x_val < 0) % then the point is in 2nd or 3rd quadrant. (outside convergence interval)
        if( y_val < 0) %% then the point is in 3rd quadrant
            initial_phase = fi(pi);
        else
            initial_phase = fi(-pi); %%then the point is in 2nd quadrant
        end
           new_y = -new_y;
           new_x = -new_x;           
end
