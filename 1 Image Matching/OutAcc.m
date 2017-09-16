function [outacc] = OutAcc(Pb, Pw, coef)
%%
%
% X = Pb(1); 
% Y = Pb(2);

t_A = gen_A(Pb);

del_a = coef(:, 1);
del_b = coef(:, 2);

Pw_calc = [t_A * del_a, t_A * del_b];

outacc = Pw - Pw_calc;

end