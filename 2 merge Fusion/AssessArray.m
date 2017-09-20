function [ H ] = AssessArray( DataArray )
% Calculate The Entropy Of An Array
% øº ‘”√

DataArray = uint8(DataArray);
H = 0.0;
if ndims(DataArray) == 2
    [m, n] = size(DataArray);
    total_pixels = m*n;
    for pix_val =0:1:255
        temp = (DataArray == pix_val);
        p = sum(temp(:)) / total_pixels;
        H = H + CalcEntropy(p);
    end
    
elseif ndims(DataArray) == 3
    [m, n , ch] = size(DataArray);
    total_pixels = m * n * ch;
    for channel = 1:1:ch
        for pix_val = 0:1:255
            temp = (DataArray==pix_val);
            p = sum(temp(:)) / total_pixels;
            H = H + CalcEntropy(p);% The joint entropy ...
        end
    end
else
    H = 0;
    fprintf('Wrong DataArray');
end

end