
% generate camera to target transformation from images.
% 
% Input: folder with many chessboard images
% Output: a CSV file with all rvec/tvec
% 
% Dong Yan 2022.01.04


clc; clear; close all;
image_path = "image/";
fid = fopen('cam2target.csv', 'w');
fid2 = fopen('target2cam.csv', 'w');

N = 25;
for i = 1:N
    filename = image_path + i + ".bmp";
    I = imread(filename);
    try
        [orientation, location, imagePoints] = calcCameraPose(I, 20);
        t_t_c = location;
        R_t_c = orientation';
    catch 
        disp("Error. No: " + i + ", no camera estimate from function.");
        continue;
    end 
    
    fig = figure('Name', 'chessboard');hold on;
    imshow(I); hold on;
    plot(imagePoints(:,1), imagePoints(:,2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    saveas(fig, image_path + "detection/chessboard" + i + ".bmp");
%     waitforbuttonpress;             % wait for key press;s
    close(fig);
    
    R_c_t = R_t_c';
    r_c_t = invRodrigues(R_c_t);
    t_c_t = - R_c_t * t_t_c;
    fprintf(fid, "%d, %f, %f, %f, %f, %f, %f\n",i, invRodrigues(R_t_c), t_t_c); 
    fprintf(fid2, "%d, %f, %f, %f, %f, %f, %f\n",i, r_c_t, t_c_t); 
end

fclose(fid);
fclose(fid2);
disp("Saved target2camera pose into file.");
close all;
