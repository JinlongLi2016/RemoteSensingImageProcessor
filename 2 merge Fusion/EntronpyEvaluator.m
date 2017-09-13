% t = imread('tm_743.bmp');
% for ch = 1:1:3
%     disp( AssessArray(t(:, :, ch)) );
% end

wei_img = imread('加权融合.jpg'); % jiaquan
for ch = 1:1:3
    disp( AssessArray(wei_img(:, :, ch)) );
end

t = imread('乘积变换.jpg'); %chengji
for ch = 1:1:3
    disp( AssessArray(t(:, :, ch)) );
end

t = imread('比值变换融合.jpg'); %bizhi
for ch = 1:1:3
    disp( AssessArray(t(:, :, ch)) );
end
