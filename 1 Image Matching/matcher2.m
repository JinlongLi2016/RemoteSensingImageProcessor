function [img_matched] = matcher2()
% A FUNCTION OF IMAGE MATCHING
% ������׼

clear all;
% the first two columns are coordinates in base image
all_ = load('sp2.txt');
all_(:, 1) = all_(:, 1) - 378500;
all_(:, 2) = all_(:, 2) - 533500;

cood = all_(:, 1:4);
% delta_a/b from base to warp image中文
[delta_a, delta_b, ~, ~] =coefficients_calculator(cood, 9, 6);

coord_t = [cood(:, 3:4), cood(:, 1:2)] ;
% a/b2 from warp image to base_image
[delta_a2, delta_b2, inacc_x, inacc_y] = coefficients_calculator(coord_t, 9, 6);
fprintf('in_acc_x:    %f, in_acc_y:   %f\n', inacc_x, inacc_y);
Pb = all_(1, 1:2); 
Pw = all_(1, 3:4);
saw_Del = OutAcc(Pb, Pw, [delta_a, delta_b]);
fprintf('out acc: ');
disp(saw_Del);
% after calculating the coefficents
% 1. read in the reference image and to_be_undistorted image
% 2. according to coefficents, converts the 
%     undistorted image to distorted image.
%     which meas: the coefficients are converting the undis->reference
%     image. 
% 3. 
all_raw_img = imread('wucesource.tif');
all_raw_img = im2double(all_raw_img);
for channel = 1:1:3
    
    raw_img = all_raw_img(:, :, channel);

    % identify the size of output image
    [dis_m, dis_n] = size(raw_img);
    dis_coords = [0, 0; dis_n-1, 0; 0, dis_m-1; dis_n-1, dis_m-1];
    dis_A = gen_A( dis_coords );
    undis_coords = [dis_A * delta_a2, dis_A * delta_b2];
    output_m = ( max(undis_coords(:, 2)) - min(undis_coords(:, 2)) ) + 1;
    output_n = ( max(undis_coords(:, 1)) - min(undis_coords(:, 1)) ) + 1;

    % for every point
    t = 0;
    output_img = zeros(int32(output_m), int32(output_n), 'double'); % output_m / output_n  % m row n column
    for i = 0 :1:0 + output_m - 1 % y
        for j = 0 :1:0 +  output_n - 1 % x
            t_A = gen_A( [j + int32( min(undis_coords(:, 1)) ), i + int32( min(undis_coords(:, 2)) )]); % (x, y)
            row_x = t_A * delta_a; %  
            row_y = t_A * delta_b; % (raw_x, raw_y) in raw image

            x = int32(row_x) ; % 
            y = int32(row_y);
            
            if(1<=row_x && row_x <= dis_n-2 && row_y >=1 &&row_y <= dis_m-2)        
                R1 = raw_img(y, x + 1) * (row_x - double(x)) + raw_img(y, x) * (double(x) +1 - row_x);
                R2 = raw_img(y+1, x+1) * (row_x - double(x)) + raw_img(y+1, x) * (double(x) + 1 - row_x);
                % output_img(j+1, i+1)
                output_img(j+1, i+1) = R1*(double(y)+1 - row_y) + R2 * (row_y -double( y ));
            else
                t = t + 1;
            end
        end
    end
    disp(t);
%     show_img = flipud(output_img);
%     show_img = rot90(show_img, 3);
%     temp_img(:, :, channel) = show_img;
    output_img = flipud(output_img);
    temp_img(:, :, channel) = output_img;
end

% 
imshow(temp_img);
fprintf('do something');
img_matched = temp_img;

end

