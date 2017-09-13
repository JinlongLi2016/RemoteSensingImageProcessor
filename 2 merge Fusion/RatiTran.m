function [DB] = RatiTran()
%% ration transformation 
% More please refer to Page171 of the book
% <Principles and Applications of Remote Sensing>
% @ Amos(jinlongli520.gmail.com) 2017-09-13 00:08:50

%% 1 Reading Image
multi_img = imread('tm_743.bmp');
pan_img = imread('spot.bmp');

%% 2 Do some transformation
multi_img = double(multi_img);
weights3  = multi_img ./ ( repmat( sum(multi_img, 3), [1, 1, 3]) +1);
clear multi_img;
% 
DB = weights3 .* double(repmat( pan_img, [1, 1, 3]));
clear pan_img;

%% 
imshow(DB/255); % DM values range from 0~255(double), 
                                % matlab only recongise 0~1(double)
end