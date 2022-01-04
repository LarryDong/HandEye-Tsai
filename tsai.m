
function X = tsai(A,B)

% Calculates the least squares solution of
% AX = XB
% 
% A New Technique for Fully Autonomous and Efficient 3D Robotics Hand/Eye Calibration. Lenz Tsai
% Mili Shah July 2014


% checked, modified and commented by LarryDong 2021.12.28
%
% Input: A/B: (4,4N) matrix (homogeneous transformation matrix, (R, t | 0, 1) )
% Output: X: (4,4), AX = XB
%
% For hand-eye calibration, 
% X: T_g_c, transform a point from camera to gripper 
% A(4, i*4-3:i*4): homogeneous transformation from gripper_i to gripper_j
% B(4, i*4-3:i*4): homogeneous transformation from camera_i to camera_j
% The equation `AX=XB` is based on rigid body transformation assumption.


[m,n] = size(A); n = n/4;
S = zeros(3*n,3);
v = zeros(3*n,1);

%% Calculate best rotation R
for i = 1:n
    A1 = logm(A(1:3,4*i-3:4*i-1));                  % 计算旋转对应的反对称矩阵：exp(\phi^)=Aij，其中\phi^是旋转轴\phi的反对称矩阵，即下面的a
    B1 = logm(B(1:3,4*i-3:4*i-1));                  % calculate the skew matrix of a rotation: exp(\phi^)=Aij, where \phi& is the skew matrix of aixs-rotation \phi (is `a` in next lines)
    a = [A1(3,2) A1(1,3) A1(2,1)]'; a = a/norm(a);  % 计算旋转向量增量 a_ij
    b = [B1(3,2) B1(1,3) B1(2,1)]'; b = b/norm(b);  % calculate the rotation vector (axis) increasement a_ij
    S(3*i-2:3*i,:) = skew(a+b);                     % 对应论文的公式(12)中的Skew(Pgij+Pcij)    Eq.12 in reference paper, Skew(Pgij+Pcij)
    v(3*i-2:3*i,:) = a-b;                           % 对应论文的公式(12)中的Pcij-Pgij    Eq.12 in reference paper, Pcij-Pgij
end

x = S\v;                            % x is Pcg' in Eq.12
theta = 2*atan(norm(x));
eps = 0.0000000000001;                      % avoid divide-by-zero. Added by LarryDong
x = x/(norm(x)+eps);
R = (eye(3)*cos(theta) + sin(theta)*skew(x) + (1-cos(theta))*x*x')';    % Rodrigues. (Eq.10)


%% Calculate best translation t
% This paper first calculate R then t, in a seperate procedure. Eq. 15
C = zeros(3*n,3);
d = zeros(3*n,1);
I = eye(3);

for i = 1:n
    C(3*i-2:3*i,:) = I - A(1:3,4*i-3:4*i-1);    % C is (Rgij-I) in Eq. 15       (Negative on both side)
    d(3*i-2:3*i,:) = A(1:3,4*i)-R*B(1:3,4*i);   % d is (RcgTcij - Tgij) in Eq. 15
end

t = C\d;
X = [R t;0 0 0 1];
end



%% other functions.
function Sk = skew( x )
   Sk = [0,-x(3),x(2);x(3),0,-x(1);-x(2),x(1),0];
end
