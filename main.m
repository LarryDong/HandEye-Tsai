clc;clear;

%% load data
file_t2c = fopen('target2cam.csv', 'r');
data_t2c =  textscan(file_t2c, '%f,%f,%f,%f,%f,%f,%f');
rvec_t2c = [data_t2c{2}, data_t2c{3}, data_t2c{4}];
tvec_t2c = [data_t2c{5}, data_t2c{6}, data_t2c{7}];

file_g2b= fopen('gripper2base.csv', 'r');
data_g2b =  textscan(file_g2b, '%f,%f,%f,%f,%f,%f,%f');
rvec_g2b = [data_g2b{2}, data_g2b{3}, data_g2b{4}];
tvec_g2b = [data_g2b{5}, data_g2b{6}, data_g2b{7}];


%% calculate T_bg and T_tc

N = 14;
T_b_g_list = zeros(4, 4, N);
T_t_c_list = zeros(4, 4, N);

for i = 1:N
    r_c_t = rvec_t2c(i, :)';
    t_c_t = tvec_t2c(i, :)';
    R_c_t = Rodrigues(r_c_t);
    T_c_t = [R_c_t, t_c_t; 
            0,0,0,  1];
    T_t_c = inv(T_c_t);
    
    r_b_g = rvec_g2b(i, :)';
    t_b_g = tvec_g2b(i, :)';
    R_b_g = Rodrigues(r_b_g);
    T_b_g = [R_b_g, t_b_g;
            0,0,0,   1];

    T_t_c_list(:,:,i) = T_t_c;
    T_b_g_list(:,:,i) = inv(T_b_g);
end

%% calculate Gij and Cij
Gij_list = [];
Cij_list = [];
K = 5;
for k = 1:K
    seq = randperm(N);
    i, j = seq(1:2);            % random select two pose.
    Gij = inv(T_b_g_list(:,:,i)) * T_b_g_list(:,:,j);
    Cij = inv(T_t_c_list(:,:,i)) * T_t_c_list(:,:,j);
    Gij_list = [Gij_list, Gij];
    Cij_list = [Cij_list, Cij];
end

X = tsai(Gij_list, Cij_list);

% X is T_g_c when given GX = XC
X
