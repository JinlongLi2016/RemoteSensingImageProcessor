% t = imread('tm_743.bmp');
% for ch = 1:1:3
%     disp( AssessArray(t(:, :, ch)) );
% end
% 
% wei_img = FusionHandlerBy('weight');% jiaquan
% for ch = 1:1:3
%     disp( AssessArray(wei_img(:, :, ch)) );
% end
% 
% t =FusionHandlerBy('multiplication'); %chengji
% for ch = 1:1:3
%     disp( AssessArray(t(:, :, ch)) );
% end

t = FusionHandlerBy('ratio'); %bizhi
for ch = 1:1:3
    disp( AssessArray(t(:, :, ch)) );
end
