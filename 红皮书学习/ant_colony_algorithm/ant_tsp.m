%% 第8章 蚁群算法及Matlab实现——TSP问题
% 程序8-1
%--------------------------------------------------------------------------
%% 数据准备
% 清空环境变量
clear all
clc

% 程序运行计时开始
t0 = clock;

%导入数据
citys=xlsread('Chap9_citys_data.xlsx', 'B2:C53');
%--------------------------------------------------------------------------
%% 计算城市间相互距离
n = size(citys,1);
x1 = citys(:,1)*ones(1,n);
deltax = (x1-x1').^2;
y1 = citys(:,2)*ones(1,n);
deltay = (y1-y1').^2;
D = sqrt(deltax+deltay);

%--------------------------------------------------------------------------
%% 初始化参数
m = 75;                              % 蚂蚁数量
alpha = 1;                           % 信息素重要程度因子
beta = 5;                            % 启发函数重要程度因子
p                                                               = 0.2;                           % 信息素挥发(volatilization)因子
Q = 10;                               % 常系数
Heu_F = 1./D;                        % 启发函数(heuristic function)  这里是距离的倒数，即到达对方点的距离越短选中改点的概率越大
Tao = ones(n,n);                     % 信息素矩阵
Paths = zeros(m,n);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 100;                      % 最大迭代次数
Route_best = zeros(iter_max,n);      % 各代最佳路径
Length_best = zeros(iter_max,1);     % 各代最佳路径的长度
Length_ave = zeros(iter_max,1);      % 各代路径的平均长度
Limit_iter = 0;                      % 程序收敛时迭代次数
%-------------------------------------------------------------------------
%% 迭代寻找最佳路径
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
    start = randi([1,n],1,m);
    Paths(:,1) = start;
    % 构建解空间
    citys_index = 1:n;
    % 确定每个蚂蚁的路径
    % 逐个蚂蚁路径选择
    for i = 1:m
        % 逐个城市路径选择
        for j = 2:n
            tabu = Paths(i,1:(j - 1));           % 已访问的城市集合(禁忌表)
            allow_index = ~ismember(citys_index,tabu);    % 参加说明1（程序底部）
            allow = citys_index(allow_index);  % 待访问的城市集合
            % 求解城市间转移概率
            currentPos = tabu(end);           %当前蚂蚁位置
            P = Tao(currentPos,allow).^alpha .* Heu_F(currentPos,allow).^beta;
            sumP = sum(P);
            P = P/sumP;
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
        Route = Paths(i,:);
        for j = 1:(n - 1)
            Length(i) = Length(i) + D(Route(j),Route(j + 1));
        end
        Length(i) = Length(i) + D(Route(n),Route(1));
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
    Delta_Tau = zeros(n,n);
    % 逐个蚂蚁计算
    for i = 1:m
        % 逐个城市计算
        for j = 1:(n - 1)
            Delta_Tau(Paths(i,j),Paths(i,j+1)) = Delta_Tau(Paths(i,j),Paths(i,j+1)) + Q/Length(i);
        end
        Delta_Tau(Paths(i,n),Paths(i,1)) = Delta_Tau(Paths(i,n),Paths(i,1)) + Q/Length(i);
    end
    Tao = (1-p) * Tao + Delta_Tau;
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Paths = zeros(m,n);
end
%--------------------------------------------------------------------------
%% 结果显示
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
Time_Cost=etime(clock,t0);
disp(['最短距离:' num2str(Shortest_Length)]);
disp(['最短路径:' num2str([Shortest_Route Shortest_Route(1)])]);
disp(['收敛迭代次数:' num2str(Limit_iter)]);
disp(['程序执行时间:' num2str(Time_Cost) '秒']);
%--------------------------------------------------------------------------
%% 绘图
figure(1)
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...  %三点省略符为Matlab续行符
    [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       起点');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       终点');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['ACA最优化路径(最短距离:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b')
legend('最短距离')
xlabel('迭代次数')
ylabel('距离')
title('算法收敛轨迹')
%--------------------------------------------------------------------------
%% 程序解释或说明
% 1. ismember函数判断一个变量中的元素是否在另一个变量中出现，返回0-1矩阵；
% 2. cumsum函数用于求变量中累加元素的和，如A=[1, 2, 3, 4, 5], 那么cumsum(A)=[1, 3, 6, 10, 15]。
