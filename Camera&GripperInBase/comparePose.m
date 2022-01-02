
% This code try to compare "camera" in target and "gripper" in base.
% all unit are in "Meter"


clc; clear; close all;

%% Given the target to base transform;
R_b_t = [-1, 0, 0;
         0, 1, 0;
         0, 0, -1];
t_b_t = [-10, 43, 0]' / 1000;      % in m
T_b_t = [R_b_t, t_b_t; 0,0,0, 1];

%% calculate camera pose
imageName = "C:\Users\larrydong\MVS\Data\Image_20220102213103375.bmp";

I = imread(imageName);
[worldOrientation, worldLocation, imagePoints, worldPoints] = calcCameraPose(I);
worldOrientation;   % rotate camera to world frame.
worldLocation;      % camera position in world-coordinate
t_t_c = worldLocation;                   % 这个location就是camera在world下的坐标，即平移
R_t_c = inv(worldOrientation);           % 这个旋转是坐标系旋转，而计算点的旋转需要求逆
T_t_c = [R_t_c, t_t_c; 0,0,0, 1];        % 应该是没问题的
T_b_c = T_b_t * T_t_c;                  % 计算camera到base系坐标

% test: 验证一个点。
% P = [1,0, 0,1]';
% T_t_c * P;

% 显示棋盘格检测结果
% fig = figure('Name', 'chessboard');hold on;
% imshow(I); hold on;
% plot(imagePoints(:,1), imagePoints(:,2), 'ro', 'MarkerSize', 8);

% 显示相机相对于棋盘格
%  pcshow(worldPoints,'VerticalAxis','Y','VerticalAxisDir','down', 'MarkerSize',80);
%  hold on
%  plotCamera('Size',0.1,'Orientation', R_t_c,'Location', t_t_c);
%  hold off


%% load  gripper to base
% % load from file
% SKIP = 20;
% filename = "../vicon_data/Trial01.csv";
% fid = fopen(filename, "r");
% for j = 1:SKIP
%     tmp = fgetl(fid);
% end
% d = textscan(fid, '%d,%d,%f,%f,%f,%f,%f,%f', 1);
% rx = deg2rad(d{3});
% ry = deg2rad(d{4});
% rz = deg2rad(d{5});
% tx = d{6};
% ty = d{7};
% tz = d{8};
% rvec = [rx, ry, rz]';
% tvec = [tx, ty, tz]'/1000;

% calculate online
RX = 136;
RY = -126;
RZ = -14;
TX = -443;
TY = 120;
TZ = 1373;
rvec = deg2rad([RX, RY, RZ]');
tvec = [TX, TY, TZ]' /1000;

R_b_g = Rodrigues(rvec);
t_b_g = tvec;
T_b_g= [R_b_g, t_b_g; 0,0,0, 1];


%% compare the result
T_b_c
T_b_g


















