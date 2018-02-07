%Bus Problem 由蓝桥杯算法练习题想到的一个问题
clear;clc;close;
tic
%% 初始化
% D = [
%     0 10 inf inf inf inf
%     0 0 50 80 inf inf
%     0 0 0 10 inf inf
%     0 0 0 0 50 10
%     0 0 0 0 0 inf
%     0 0 0 0 0 0
%     ];
% D = D+D';
D = load('dist2.txt');
% 采用Floyd算法求解多源最短路径
minD = Floyd(D);
%% 模拟退火求解
n = size(D,1);
amount = size(D,1)-2; % 因为不需要计算首尾
a = 0.99;	% 温度衰减函数的参数
t0 = 100; tf = 3; t = t0;
Markov_length = 100*amount;	% Markov链长度
% 产生初始解
sol_new = 2:2+amount-1;
% E_current是当前解对应的回路距离；
% E_new是新解的回路距离；
% E_best是最优解的
E_current = inf;E_best = inf;
% sol_new是每次产生的新解；sol_current是当前解；sol_best是冷却中的最好解；
sol_current = sol_new; sol_best = sol_new;

while t>=tf  % 外层控制降温
    for r=1:Markov_length		% 内层控制解
        % step1 随机扰动，产生新解
        sol_new = natural_code_new_solution(sol_new,amount);
        % step2 计算目标函数值（即内能）
        E_new = minD(1,sol_new(1))+minD(sol_new(end),n);
        for i = 1 :amount-1
            E_new = E_new + ...
                minD(sol_new(i),sol_new(i+1));
        end
        % step3 是否接受新解
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                % 把冷却过程中最好的解保存下来
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            % 若新解的目标函数值小于当前解的，
            % 则仅以一定概率接受新解
            if rand < exp(-(E_new-E_current)./t)
                E_current = E_new;
                sol_current = sol_new;
            else
                sol_new = sol_current;  % 重置温度，避免温度升高
            end
        end
    end
    t=t.*a;		% 控制参数t（温度）减少为原来的a倍
end
disp('最优路径');
disp(num2str([1 sol_best n]));
disp('最短距离');
disp(E_best);
toc