% 利用yamlip求解TSP问题
clear;clc;close all;
d = load('tsp_dist_matrix.txt')';
n = size(d,1);
% 决策变量
x = binvar(n,n,'full');
u = sdpvar(1,n);
% 目标
z = sum(sum(d.*x));
% 约束添加
C = [];
for j = 1:n
    s = sum(x(:,j))-x(j,j);
    C = [C,   s  == 1];
end
for i = 1:n
    s = sum(x(i,:)) - x(i,i);
    C = [C, s  == 1];
end
for i = 2:n
    for j = 2:n
        if i~=j
            C = [C,u(i)-u(j) + n*x(i,j)<=n-1];
        end
    end
end
% 参数设置
ops = sdpsettings('verbose',0,'solve','lpsolve');
% 求解
result  = optimize(C,z);
if result.problem== 0
    value(x)
    value(z)
else
    disp('求解过程中出错');
end
