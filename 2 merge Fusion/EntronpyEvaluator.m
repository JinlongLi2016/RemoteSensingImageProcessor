% t = imread('tm_743.bmp');
% for ch = 1:1:3
%     disp( AssessArray(t(:, :, ch)) );
% end

wei_img = imread('��Ȩ�ں�.jpg'); % jiaquan
for ch = 1:1:3
    disp( AssessArray(wei_img(:, :, ch)) );
end

t = imread('�˻��任.jpg'); %chengji
for ch = 1:1:3
    disp( AssessArray(t(:, :, ch)) );
end

t = imread('��ֵ�任�ں�.jpg'); %bizhi
for ch = 1:1:3
    disp( AssessArray(t(:, :, ch)) );
end
