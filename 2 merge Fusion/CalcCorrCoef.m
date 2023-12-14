function [Coef] = CalcCorrCoef(Am, Bm)
% Calculate the Correlation Coefficents of Matrix 
% A and B
% params explanation

%% Check Shape
assert( sum(size(Am)== size(Bm)) == 2, 'Input matrixs"s shapes are not consistent');

%% Calculate Correlation Coefficients
% 1 remove the mean of matrix A and B
Am = Am - mean(Am(:));
Bm = Bm - mean(Bm(:));
Am = double(Am(:)); Bm = double(Bm(:));
% 2 Calculate the correlation coefficients
Coef = (Am' * Bm)/sqrt( (Am' * Am) * ( Bm' * Bm));

end