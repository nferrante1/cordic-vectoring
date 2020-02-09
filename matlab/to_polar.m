function [radius,phase] = to_polar(x,y)
%TO_POLAR This function will return given a point on the cartesian
%plane as (x,y) coordinates the corresponding polar coordinates

radius = sqrt((x^2) + (y^2));

%atan2(x,y) is used because it takes in account the sign of both the input
%and the codomain of the function is [-pi,pi] instead
%atan gives the result in a restricted codomain [-pi/2,pi/2]
phase = atan2(y,x);

end

