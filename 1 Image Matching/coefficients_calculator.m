function [del_a, del_b, del_x, del_y] = coefficients_calculator(all_coords, n, N)
% CALCULATE THE COEEFICIENTS VIA 'CORRESPONDING POINT'
% THESE COEFFICIENTS ARE THOSE FROM THE 1ST 2 COLS (X,Y) 
% TO THE LAST 2 COLS (x, y)
% all_coords :
%  1st 2 cols are reference image coords [X, Y]
%  last 2 cos are undistorted image coords (x, y)

%n = 9; % num of control points
%N =12; % num of the coefficients

% the first two columns are coordinates on refernce image
all_ = all_coords;
XY = all_(:, 1:2);
A = gen_A( XY );


L_xs = all_(:, 3);
L_ys = all_(:, 4);


% delta_a = inv(A'*A) * A' * L_xs;
del_a = (A'*A) \ A' * L_xs;

del_b = (A'*A) \ A' *  L_ys;

% Evaluate the Precision
Vx = A * del_a - L_xs;
Vy = A * del_b - L_ys;

del_x = sqrt( Vx' * Vx / (n - N) );
del_y = sqrt( Vy' * Vy / (n - N) );

end