function [A] = gen_A(XY)
% A FUCNTION TO GENERATE A [refer to page 130 of book
%'Principles and Applications of Remote Sensing'  for more information
% on A].

[m, ~]= size( XY );
t = XY .* XY;
A =[ones(m, 1),  XY, t(:, 1),  [XY(:, 1) .* XY(:, 2)],  t(:, 2) ];
end 