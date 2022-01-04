% generate gripper to base transformation
% 
% Input: a folder includes many vicon data.
% Output: a csv file with all rvec/tvec from those data.
% 
% Dong Yan 2021.01.04


clc; clear; 

index_list = [1,2,3,4,5,7,8,10,13,15,16,17,18,19,20,21,22,23]; % skip invalid record.
VALID_NUMBER = length(index_list);

rvec = zeros(VALID_NUMBER, 3);
tvec = zeros(VALID_NUMBER, 3);

for i = 1:VALID_NUMBER
    idx = index_list(i);
    filename = "vicon_data/aa"+int2str(idx)+".csv";
    fid = fopen(filename, "r");
    for j = 1:20                             % skip the "titles" of csv file.
        tmp = fgetl(fid);
    end
    d = textscan(fid, '%d,%d,%f,%f,%f,%f,%f,%f', 1);
    rvec(i, :) = deg2rad([d{3}, d{4}, d{5}]);
    tvec(i, :) = [d{6}, d{7}, d{8}];
end


fid = fopen("gripper2base.csv", "w");
for i = 1:VALID_NUMBER
    idx = index_list(i);
    fprintf(fid, "%d, %f, %f, %f, %f, %f, %f\r\n", [idx, rvec(i, :), tvec(i, :)]);
end
fclose(fid);
disp("saved `gripper2base.csv` done");