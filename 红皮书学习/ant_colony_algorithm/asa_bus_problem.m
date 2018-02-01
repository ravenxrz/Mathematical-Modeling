%Bus Problem 由蓝桥杯算法练习题想到的一个问题
%% 初始化
clear;clc;close;
% 程序运行计时开始
tic
% 注意距离矩阵不要使用inf,否则启发函数会有问题。当然可以通过更改启发函数来进行修正
% inf = 1000;
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
%% 蚁群算法
% 初始化参数
n = size(D,1);
m = ceil(n*1.5);                              % 蚂蚁数量
alpha = 2;                           % 信息素重要程度因子
beta = 4;                            % 启发函数重要程度因子
p = 0.3;                           % 信息素挥发(volatilization)因子
Q = 10;                               % 常系数
Heu_F = 1./D;                      % 启发函数(heuristic function)  这里是距离的倒数，即到达对方点的距离越短选中改点的概率越大
Tao = ones(n-2,n-2);                     % 信息素矩阵
Paths = zeros(m,n-2);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 80;                      % 最大迭代次数
Route_best = zeros(iter_max,n-2);      % 各代最佳路径
Length_best = zeros(iter_max,1);     % 各代最佳路径的长度
Length_ave = zeros(iter_max,1);      % 各代路径的平均长度
Limit_iter = 0;                      % 程序收敛时迭代次数
%-------------------------------------------------------------------------
%% 迭代寻找最佳路径
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
    start = randi([1,n-2],1,m);
    Paths(:,1) = start;
    % 构建解空间
    citys_index = 1:n-2;
    % 确定每个蚂蚁的路径
    % 逐个蚂蚁路径选择
    for i = 1:m
        % 逐个城市路径选择
        for j = 2:n-2
            tabu = Paths(i,1:(j - 1));           % 已访问的城市集合(禁忌表)
            allow_index = ~ismember(citys_index,tabu);    % 参加说明1（程序底部）
            allow = citys_index(allow_index);  % 待访问的城市集合
            % 求解城市间转移概率
            currentPos = tabu(end);           %当前蚂蚁位置
            P0 = Tao(currentPos,allow).^alpha .* Heu_F(currentPos,allow).^beta;
            sumP = sum(P0);
            P = P0/sumP;
            % 轮盘赌法选择下一个访问城市
            Pc = cumsum(P);     %参加说明2(程序底部)
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Paths(i,j) = target;
        end
    end
    % 计算各个蚂蚁的路径距离
    Length = zeros(m,1);
    for i = 1:m
        Route = Paths(i,:)+1;       % 还原真实路径
        for j = 1:(n - 3)
            Length(i) = Length(i) + minD(Route(j),Route(j + 1));
        end
        Length(i) = Length(i)+minD(1,Route(1))+minD(Route(end),n);
    end
    % 计算最短路径距离及平均距离
    if iter == 1
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min_Length;
        Length_ave(iter) = mean(Length);
        Route_best(iter,:) = Paths(min_index,:);
        Limit_iter = 1;
        
    else
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min(Length_best(iter - 1),min_Length);    % 动态规划思想
        Length_ave(iter) = mean(Length);
        if Length_best(iter) == min_Length
            Route_best(iter,:) = Paths(min_index,:);
            Limit_iter = iter;
        else
            Route_best(iter,:) = Route_best((iter-1),:);
        end
    end
    % 更新信息素
    Delta_Tau = zeros(n-2,n-2);
    
    % 逐个蚂蚁计算
    for i = 1:m
        PerQ = Q/Length(i);
        % 逐个城市计算
        for j = 1:(n - 3)
            Delta_Tau(Paths(i,j),Paths(i,j+1)) = Delta_Tau(Paths(i,j),Paths(i,j+1)) + PerQ;
        end
    end
    Tao = (1-p) * Tao + Delta_Tau;
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Paths = zeros(m,n-2);
end
%--------------------------------------------------------------------------
%% 结果显示
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['最短距离:' num2str(Shortest_Length)]);
disp(['最短路径:' num2str([1 Shortest_Route+1 n])]);
disp(['收敛迭代次数:' num2str(Limit_iter)]);
%% 绘制算法收敛过程
plot(1:iter_max,Length_best,'b')
toc