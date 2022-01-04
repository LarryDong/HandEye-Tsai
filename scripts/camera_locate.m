clc; clear ; close all;
cameraParams= load('cameraParams.mat');
I = imread("C:\Users\larrydong\Desktop\Image_20220104124034473.bmp");
[imagePoints,boardSize] = detectCheckerboardPoints(I);

worldPoints =  generateCheckerboardPoints(boardSize, 70.5);
worldPoints = [worldPoints, zeros(length(worldPoints), 1)];

% R, t is the camera pose in world coordinate.
[R,t] = estimateWorldCameraPose(imagePoints,worldPoints,cameraParams.cameraParams);

