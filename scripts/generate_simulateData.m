% generate simulated data
%
% Generate ideal / low-level noise / high-level noise gripper2base data based on cam2target.
% 
% Dong Yan 2021.01.04


clc;clear;

%% load data
fin = fopen('target2cam.csv', 'r');
A =  textscan(fin, '%f,%f,%f,%f,%f,%f,%f');
fclose(fin);
rvec_c_t = [A{2}, A{3}, A{4}];
tvec_c_t = [A{5}, A{6}, A{7}];

fIdeal = fopen('gripper2base_ideal.csv', 'w');
fLowNoise = fopen('gripper2base_low.csv', 'w');
fHighNoise= fopen('gripper2base_high.csv', 'w');

%% 

N = length(A{2});

%% given values
R_b_t = [-1, 0, 0;
         0, 1, 0;
         0, 0, -1];
t_b_t = [-800, 1120, 0]';      % in mm
T_b_t = [R_b_t, t_b_t; 0,0,0, 1];

% camera to gripper
R_g_c = [1,0,0; 0,1,0; 0,0,1];
t_g_c = [-0.057, 0.035, 0.065]'*1000;
T_g_c = [R_g_c, t_g_c; 0,0,0, 1];


%% generate r_b_g and t_b_g
for i = 1:N
    
    r_c_t = rvec_c_t(i, :)';
    t_c_t = tvec_c_t(i, :)';
    R_c_t = Rodrigues(r_c_t);
    T_c_t = [R_c_t, t_c_t; 0,0,0,  1];
    
    % generate ideal T_b_g
    T_b_g = T_b_t * inv(T_c_t) * inv(T_g_c);
    R_b_g = T_b_g(1:3, 1:3);
    t_b_g = T_b_g(1:3, 4);
    r_b_g = invRodrigues(R_b_g);
    fprintf(fIdeal, "%d, %f, %f, %f, %f, %f, %f\n",i, r_b_g, t_b_g);
    
    % add noise (low)
    r_low = (rand(3,1) - 0.5) * 0.01;   % max: 0.28 degree. (0.5 * 0.01 / pi * 180 = 0.28)
    t_low = (rand(3,1) - 0.5) * 0.01 * 1000;
    R_low = XYZ2Rotation(r_low);
    R_b_g_lowNoise = R_low * R_b_g;
    t_b_g_lowNoise = t_b_g + t_low;
    fprintf(fLowNoise, "%d, %f, %f, %f, %f, %f, %f\n",i, invRodrigues(R_b_g_lowNoise), t_b_g_lowNoise);
    
    % add noise (high)
    r_high = (rand(3,1) - 0.5) * 0.1;   % max: 2.8 degree
    t_high = (rand(3,1) - 0.5) * 0.01 * 1000;
    R_high = XYZ2Rotation(r_low);
    R_b_g_highNoise = R_high * R_b_g;
    t_b_g_highNoise = t_b_g + t_high;
    fprintf(fHighNoise, "%d, %f, %f, %f, %f, %f, %f\n",i, invRodrigues(R_b_g_highNoise), t_b_g_highNoise);
end

fclose(fIdeal);
fclose(fLowNoise);
fclose(fHighNoise);
disp('saved done');

