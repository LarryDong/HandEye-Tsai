
% Convert rotation vector to 3x3 rotation matrix

function rvec = invRodrigues(R)
    r = rotm2axang(R);      % convert to target2camera
    r = r(1:3) * r(4);
    rvec = r';
return 
