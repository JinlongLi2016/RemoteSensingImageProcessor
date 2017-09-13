function [val] = CalcEntropy(p)
% 

if p == 0
    val = 0;
elseif p>0 && p <=255
    val = - p* log(p);
else
    fprintf('Wrong p!!!');
end

end