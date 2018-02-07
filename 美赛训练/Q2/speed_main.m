% 元胞自动机仿真-风向与燃烧面积关系
clear;clc;close;
% 初始化参数
T = 22.4;          % 温度
V = 3;         % 风速
aw = 1;         % 风对火蔓延影响程度
H = 0.63;        % 最小湿度
W = v2w(V);     % 风等级
pg = 0.000;       % 生长率
% pf = 0.0001;        % 闪电
theta = deg2rad(60);        % 风方向角度
a = 0.03;b = 0.05;c = 0.01; d = 0.3; % 计算初始蔓延度的其它因子
R0 = a*T + b*W + c*H - d;                     % 初始蔓延度
Ks = 1;             % 可燃物配置格局更正系数
% Kf = 1;             % 地形坡度
h = @(x)(R0*Ks*exp(0.1783*x));      % 计算林火蔓延速度公式 x为分解后的风速
Rs = 10;            % 自燃速率
tend = 0.9;
% 外层循环
n = 300;            % 森林尺寸
L = 255;
veg.life = L*ones(n);     % 森林生命值
veg.fire = zeros(n);    % 森林是否起火，初始未起火
hang = round(n/2);                 % 初始起火点
lie = round(n/2);
veg.fire(hang,lie) = 1;
MaxIters =300;        % 最大迭代次数

location = [
    10
    20
    30
    ];
% location (:,1) = [];
num = 4;
record = zeros(size(location,1),num);
% 模拟开始
for i = 1:size(record,1)
    for j = 1:num
        clf;
        % 显示初始图
        veg.life = L*ones(n);     % 森林生命值
        veg.fire = zeros(n);    % 森林是否起火，初始未起火
        hang =round(n/2); % 初始起火点
        lie = round(n/2);
        veg.fire(hang,lie) = 1;
        veg.life(hang,lie) = L-2.5;
        % 一定要设置CDataMapping，这样函数值即可对应颜色，默认为direct是使用RGB三维设置。改为scaled
        im = image(veg.life,'CDataMapping','scaled');
        set(gcf,'position',[-600 100 500 500]);     % 设置位置
        axis square;
        map=[
            0 0 0            %黑      -1
            1 0.5 0          %橙红    0-1
            1 0.1 0      %火红     1
          0 0.6 0  ] ;         %深绿     0
        colormap(map);
        colorbar;
        % 设置区间
        %         [cmin,cmax] = caxis;
        caxis([0,L]);
        set(gca, 'xtick', [], 'ytick', []);
        T = location(i);
        R0 = a*T + b*W + c*H- d;                     % 初始蔓延度
        h = @(x)(R0*Ks*exp(0.1783*x));      % 计算林火蔓延速度公式 x为分解后的风速
        for k = 1:MaxIters
            theta = deg2rad(randi([0 360],1));
            %                     theta = deg2rad(location(i));
            % 可能的内层循环
            lr = V*cos(theta);      % 左右
            ud = V*sin(theta);      % 上下
            % 计算统计来及的方向
            if lr >0
                lr = [n,1:n-1 ];
                k1 = [veg.fire(:,n)  zeros(n,n-1) ];      % 多余的
            else
                lr = [2:n,1];
                k1 = [zeros(n,n-1) veg.fire(:,1) ];     % 多余的
            end
            if ud >0
                ud = [2:n,1];
                k2 = [zeros(n-1,n);veg.fire(1,:)];
            else
                ud = [n,1:n-1];
                k2 = [veg.fire(n,:);zeros(n-1,n)];
            end
            
            % 首先计算森林受周边的火，生命值的变化
            %             temp = veg;
            Rx = h(V*cos(theta));
            Ry = h(V*sin(theta));
            delta = veg.fire(:,lr).*Rx + veg.fire(ud,:).*Ry;
            % 减去边界条件多计算的风速
            delta = delta - Rx.*k1 - Ry*k2;
            veg.life = veg.life - aw*delta-Rs.*veg.fire;
            % 将烧到负值的点进行更新
            veg.fire(veg.life < 0) = 0;
            veg.life(veg.life < 0) = 0;
            % 再计算新火 即不是等于原始生命值并且不等于0
            veg.fire( veg.life ~= L & veg.life ~= 0) = 1;
            % 生长率
            index = find(veg.fire == 0 & veg.life ==  0 & rand(n,n) < pg);
            veg.life(index) = L;
            set(im,'CData',veg.life);
            drawnow;
        end
        record(i,j) =  sum(sum(veg.life == 0));
    end
    
    
end
plot(record);
% plot(10+(1:length(record)*10),record);