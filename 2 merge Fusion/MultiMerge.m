function [DB] = MultiMerge()
%% ³Ë»ý±ä»»
% @ Amos(jinlongli520.gmail.com) 2017-09-13 00:08:50

%% 1 Read In Image
multi_img = imread('tm_743.bmp');
pan_img = imread('spot.bmp');

%% 
DB = single(multi_img) .* single(repmat( pan_img, [1, 1, 3]));
clear multi_img;
clear pan_img;
% Values range are far bigger than 255, find a way to map it 
% to 0~255
DB = log(DB+1) * 255. / 11.01;

imshow(DB/255);
end