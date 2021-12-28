function R = Rodrigues(om)
theta=norm(om);
om=om./theta;
I=eye(3);
rom=[0 -om(3) om(2);
     om(3)  0  -om(1);
     -om(2) om(1) 0];
R = cos(theta)*I+(1-cos(theta))*om*om'+ sin(theta)*rom;
return 