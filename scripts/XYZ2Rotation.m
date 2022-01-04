
% convert XYZ eular angle to rotation matrix.

function R = XYZ2Rotation(XYZ)
    x = XYZ(1);
    y = XYZ(2);
    z = XYZ(3);
    rotX = [1, 0, 0;
            0, cos(x), sin(x);
            0, -sin(x), cos(x)];
    rotY = [cos(y), 0, -sin(y);
            0, 1, 0;
            sin(y), 0, cos(y)];
    rotZ = [cos(z), sin(z), 0;
            -sin(z), cos(z), 0;
            0, 0, 1];
    R =  rotZ * rotY * rotX;
end
