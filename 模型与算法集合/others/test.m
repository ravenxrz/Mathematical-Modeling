% 清除环境变量
clear;clc;close;
x = sdpvar(1,1);
C = [
    1<=x<=2
];
z = x;
ops = sdpsettings('verbose',0,'solver','lpsolve');
result = optimize(C,z,ops);
