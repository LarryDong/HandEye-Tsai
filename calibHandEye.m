
% Hand-eye calibration  
%
% cam2target.csv format: 1 index, 2-4 rvec, 5-7 tvec. 
% cam2target, transfer a point in camera frame to target(chessboard) frame.
% gripper2base, transfer a point in gripper frame to base frame.
% rvec: the axis-angle notation. rvec's direction is rotation direction, norm is the rotation angle (in rad)
% tvec: unit: mm
% 
% Dong Yan  2022.01.4


clc;clear;

%% load data
fid = fopen('cam2target.csv', 'r');
A =  textscan(fid, '%f,%f,%f,%f,%f,%f,%f');
rvec_t_c = [A{2}, A{3}, A{4}];
tvec_t_c = [A{5}, A{6}, A{7}];

fid = fopen('gripper2base.csv', 'r');
A =  textscan(fid, '%f,%f,%f,%f,%f,%f,%f');
rvec_b_g = [A{2}, A{3}, A{4}];
tvec_b_g = [A{5}, A{6}, A{7}];


%% calculate relative transformation
N = 18;
T_b_g_list = zeros(4, 4, N);
T_t_c_list = zeros(4, 4, N);
for i = 1:N
%     fprintf("%d\n", i);
    r_t_c = rvec_t_c(i, :)';
    t_t_c = tvec_t_c(i, :)';
    R_t_c = Rodrigues(r_t_c);
    T_t_c = [R_t_c, t_t_c; 0,0,0,  1];
    
    r_b_g = rvec_b_g(i, :)';
    t_b_g = tvec_b_g(i, :)';
    R_b_g = Rodrigues(r_b_g);
    T_b_g = [R_b_g, t_b_g; 0,0,0,  1];
    T_t_c_list(:,:,i) = T_t_c;
    T_b_g_list(:,:,i) = T_b_g;
end


%% calculate Gij and Cij
Cij_list = [];
Gij_list = [];
for k = 1:N-1
    i = k;
    j = k+1;
    Cij = inv(T_t_c_list(:,:,i)) * T_t_c_list(:,:,j);
    Gij = inv(T_b_g_list(:,:,i)) * T_b_g_list(:,:,j);
    Cij_list = [Cij_list, Cij];
    Gij_list = [Gij_list, Gij];
end

% X is T_g_c when given GX = XC
T_g_c = tsai(Gij_list, Cij_list)

% Ground-truth (measured by a ruler)
% R: Identity matrix (I)
% t: [-57, 65, 20] mm
