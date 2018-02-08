% 非线性规划
clear;clc;close;
x = sdpvar(1,2);        % 决策变量
z = x(1)^2+x(2)^2+8;    % 目标函数
C = [
    x(1)^2 - x(2) >= 0;
    -x(1) - x(2)^2 ==-2;
    x >= 0;
];      % 约束条件
ops = sdpsettings('solver','gurobi');
result = optimize(C,z);
value(z)