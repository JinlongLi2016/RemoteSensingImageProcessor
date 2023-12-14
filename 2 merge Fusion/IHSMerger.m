function   [i_hs] = IHSMerger()
% IHS Transformation Merging
% @ Amos(jinlongli520.gmail.com) 2017-09-13 00:08:50

%% 1 Read in the  Image
multi_img = imread('tm_743.bmp');
pan_img = imread('spot.bmp');

%% 2 rbg to ihs
% Transform from RGB to IHS
ihs =  rgb2hsv(multi_img);
intensity_channel = ihs(:, :, 3);
% Histgram Matching
matched_pan = imhistmatch(pan_img, intensity_channel);
ihs(:, :, 3) = matched_pan; % Replace the Intensity Channel
% Trasform back from IHS to RGB
i_hs = hsv2rgb(ihs);

%% Display Merging Image
imshow(i_hs);

end
