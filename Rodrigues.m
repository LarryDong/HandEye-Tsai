
% Convert rotation vector to 3x3 rotation matrix

function R = Rodrigues(rvec)
    [row, col] = size(rvec);
    assert(row == 3);     % must input 3*1 vector
    theta=norm(rvec);
    rvec=rvec./theta;
    I=eye(3);
    rrvec=[0 -rvec(3) rvec(2);
         rvec(3)  0  -rvec(1);
         -rvec(2) rvec(1) 0];
    R = cos(theta)*I + (1-cos(theta))*rvec*rvec' + sin(theta)*rrvec;
return 
