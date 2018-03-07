
% 计算溢出概率
clear;clc;
num = 5;            % 管道数，即用户
s = 1;                 % 每个管道的服务台个数
mu = unifrnd(0.3,0.8,num,2);        % 在一定范围内生成两个参数
k = 10;        % 详细参数
T = 50; deltaT = 1;     %观察时间及观察间隔
A = zeros(3,1);
%% 求解各用户管道概率
% for i = 1:num
%     [gk,p,status,Q] = MMSkteam(s,k,mu(i,1),mu(i,2),T,deltaT);
%     theta = sdpvar(1,1);
%     logG =  0;
%     V = p.value;
%     type = p.type;
%     for j  = 1: length(p.value)
%         logG = logG+V(j)*exp(type(j)*theta);
%     end
%     target = gk*theta - logG;
%     ops = sdpsettings('verbose',0);
%     result = optimize([],-target,ops);
%     A(i) = exp( -T*value(target));
% end
% A = A./sum(A);
A =[
    0.2085
    0.2099
    0.2076
    0.1661
    0.2079];
%% 求解最优利润
N_yewu = 3; % 业务数量
N_bs = 3;   % 基站数量
B = 10^6;      % 带宽
W = B;          % 回程链路
M = [4 2 0.5];  % 最低带宽需求
r = [20 15 10]; % 最低速率要求
SINR = 1/(N_bs);
e = log2(1+SINR);
alpha= [20 15 10];
beta1 = 100;
beta2 = 2;
x = intvar(num,N_yewu,N_bs);
y = sdpvar(num,N_yewu,N_bs);
ekij = e*ones(num,N_yewu,N_bs);
a = ekij;
for i = 1:N_yewu
    a(:,i,:) = alpha(i)*a(:,i,:)*B-beta1*B-beta2*e*B;
end
R = x.*y*B*e;
t =x;
for i = 1:num
    t(i,:,:) = x(i,:,:)*A(i);
end
target = sum(sum(sum(t.*y.*a)));
% 添加限制条件
C = [];
% 约束1
for k = 1:num
    for i = 1:N_yewu
        C = [
            C;
            sum(x(k,i,:)) == 1;
        ];
    end
end
% 约束2
for j = 1:N_bs
    C = [C;sum(sum(x(:,:,j).*y(:,:,j)))];
end
% 约束3
for j = 1:N_bs
    C = [
        C;
        sum(sum(x(:,:,j).*y(:,:,j).*R(:,:,j))) <= W;
        ];
end
% 约束4
for k = 1:num
    for i = 1:N_yewu
        C = [
            C;
            sum(x(k,i,:).*y(k,i,:).*R(k,i,:)) >= r(i);
        ];
    end
end
% 约束5
for i = 1:N_yewu
    C = [
        C;
        sum(sum(x(:,i,:).*y(:,i,:)*B)) >= M(i);
      ];
end
% 求解
ops = sdpsettings('verbose',1,'debug',1,'solver','gurobi');
result = optimize(C,-target,ops)