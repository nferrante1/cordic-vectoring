% Given a point (x,y), this function returns the corresponding polar
% coordinates (radius,phase)
function [radius,phase] = to_polar(x,y)
	radius = sqrt((x^2) + (y^2));

	% atan2(x,y) is used since it takes in account the sign of both the
	% input and the codomain of the function is [-pi,pi] instead atan gives
	% the result in a restricted codomain [-pi/2,pi/2]
	phase = atan2(y,x);
end
