
% calculate the R_t_c and t_t_c
function [R, t, imagePoints, worldPoints] = calcCameraPose(I)
    cameraParams= load('cameraParams.mat');
    [imagePoints,boardSize] = detectCheckerboardPoints(I);
    worldPoints =  generateCheckerboardPoints(boardSize, 0.0707);
    worldPoints = [worldPoints, zeros(length(worldPoints), 1)];
    [R,t] = estimateWorldCameraPose(imagePoints,worldPoints,cameraParams.cameraParams);
    t = t';
%     imshow(I); hold on;
%     plot(imagePoints(:, 1), imagePoints(:, 2), 'o')
return 
