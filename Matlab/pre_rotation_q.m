function [new_x_q,new_y_q, initial_phase_q] = pre_rotation_q(x_q,y_q,in_lsb)
%PRE_ROTATION_Q implements CORDIC pre rotation in quantized version
%Inputs/outputs are integer values

new_x_q = x_q;
new_y_q = y_q;
initial_phase_q = 0;
pi_q = floor(pi/in_lsb);
pi_neg_q = floor(-pi/in_lsb);
if( x_q < 0) % then the point is in 2nd or 3rd quadrant. (outside convergence cone)
        if( y_q < 0) %% then the point is in 3rd quadrant
            initial_phase_q = pi_neg_q;
        else
            initial_phase_q = pi_q; %%then the point is in 2nd quadrant
        end
           new_y_q = -y_q;
           new_x_q = -x_q; 
end
end

