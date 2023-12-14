raw_img = imread('spot.bmp');
% 
% t = imread('tm_743.bmp');
% for ch = 1:1:3
%     disp( CalcCorrCoef(t(:, :, ch), raw_img) );
% end
% t = FusionHandlerBy('weight'); % jiaquan
% for ch = 1:1:3
%     disp( CalcCorrCoef(t(:, :, ch), raw_img) );
% end

% t =FusionHandlerBy('multiplication'); %chengji
% for ch = 1:1:3
%     disp( CalcCorrCoef(t(:, :, ch), raw_img) );
% end

raw_img = double(raw_img);
t = FusionHandlerBy('ratio');%bizhi
for ch = 1:1:3
    disp( CalcCorrCoef(t(:, :, ch), raw_img) );
end