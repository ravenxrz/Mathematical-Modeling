% 比赛循环问题-P74
clear;clc;close all;
raw_data = load('table2.txt');
n = size(raw_data,2)+1;
data = zeros(n,n);
for i = 1:n-2
    for j = i+1:n-1
        data(i,j) = sum(raw_data(:,i) & raw_data(:,j));
    end
end
% 补齐
data = data'+data;
% 利用tsp解题
% 决策变量
x = binvar(n,n,'full');
u = sdpvar(1,n);
% 目标
z = sum(sum(data.*x));
% 约束添加
C = [];
for j = 1:n
    C = [C,  sum(x(:,j))-x(j,j) == 1];
end
for i = 1:n
    C = [C, sum(x(i,:)) - x(i,i) == 1];
end
for i = 2:n
    for j = 2:n
        if i~=j
            C = [C,u(i)-u(j) + n*x(i,j)<=n-1];
        end
    end
end
% 参数设置
ops = sdpsettings('debug','1','solver','gurobi');
% 求解
result  = optimize(C,z,ops);
if result.problem== 0
    value(z)
    x = value(x);
    visted = zeros(1,n);
    compare = ones(1,n);
    scan = 1;
    visted(scan) = 1;
    path = strcat(num2str(scan));
    while(~isequal(visted,compare))
        scan = find(x(scan,:) == 1);
        visted(scan) = 1;
         path = strcat(path,',',num2str(scan));
    end
    disp(path);
else
    disp('求解过程中出错');
end