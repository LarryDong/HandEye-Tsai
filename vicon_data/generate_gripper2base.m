clc; clear; 

index_list = [1,2,4,5,6,8,9,10,11,12,13,14,15,16,17];
N = length(index_list)
rx = zeros(N, 1);
ry = rx;
rz = rx;
tx = rx;
ty = rx;
tz = rx;

SKIP = 50;
for i = 1:N
    idx = index_list(i);
    fid = fopen("calib"+int2str(idx)+".csv", "r");
%     data =  textread(filename, '%d,%d,%f,%f,%f,%f,%f,%f', 100)
    for j = 1:SKIP
        tmp = fgetl(fid);
    end
    d = textscan(fid, '%d,%d,%f,%f,%f,%f,%f,%f', 1);
    rx(i) = deg2rad(d{3});
    ry(i) = deg2rad(d{4});
    rz(i) = deg2rad(d{5});
    tx(i) = d{6}/1000;
    ty(i) = d{7}/1000;
    tz(i) = d{8}/1000;
end


fid = fopen("gripper2base.csv", "w");
for i = 1:N
%     idx = index_list(i);
    data = [rx(i), ry(i), rz(i), tx(i), ty(i), tz(i)];
    fprintf(fid, "%d,%f,%f,%f,%f,%f,%f\r\n", [index_list(i), data]);
end
fclose(fid);
