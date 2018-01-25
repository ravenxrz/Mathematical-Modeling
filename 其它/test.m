% 清除工作区
clear;clc;close all;
% 创建决策变量
x = sdpvar(1,2);
% 添加约束条件
C = [
    x(1) + x(2) -2 >= 0
    x(2)-x(1) <=1
    x(1)<=1
    ];
% 配置
ops = sdpsettings('verbose',0,'solver','lpsolve');
% 目标函数
z = -(x(1)+2*x(2))/(2*x(1)+x(2)); % 注意这是求解最大值
% 求解
reuslt = optimize(C,z);
if reuslt.problem == 0 % problem =0 代表求解成功
    value(x)
    -value(z)   % 反转
else
    disp('求解出错');
end