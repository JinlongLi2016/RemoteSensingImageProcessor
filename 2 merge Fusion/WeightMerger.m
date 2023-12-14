function   [G_img] = WeightMerger()
% Merge Two Give Image By Correlation Coefficients Weights
% @ Amos(jinlongli520.gmail.com) 2017-09-13 00:08:50

%% 1 Read In Image
multi_img = imread('tm_743.bmp'); % Multi_spectral Image
pan_img = imread('spot.bmp'); % Panchromatic Image

%% 2 For each channel ...
% G_img stores generated image 
for channel = 1:1:3
    tmp_img = multi_img(:, :, channel);
    coef = CalcCorrCoef(tmp_img, pan_img);
    coef = abs(coef);
    
    G_img(:, :, channel) = ( (1 + coef) * pan_img + (1 - coef) * tmp_img) / 2.;
end

%% Display the image
imshow(G_img)

end
