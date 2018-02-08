% 在程序的所有节骨眼都进行了详尽的注释
clc;
clear;

% 以下数据背景：银行各种理财金融衍生品，客户在购买某种理财产品的时候
% 一般会有10天的“犹豫期”，在这10天可以自由退买
% 我们分析客户购买行为数据发现，在当天（姑且称之为第0天）购买之后
% 在第1天没有发生退买（保有量）的比率大概是92.81%，在第2天没有退买的比率大概是97.66%
% 以此类推
% 这里取前8天的数据：
x0 = [92.810 	97.660 	98.800 	99.281 	99.537 	99.537 	99.817 	100.000];

n = length(x0);
% 做级比判断，看看是否适合用GM(1，1)建模
lamda = x0(1:n-1)./x0(2:n);
range = minmax(lamda);
% 判定是否适合用一阶灰色模型建模
if range(1,1) < exp(-(2/(n+2))) || range(1,2) > exp(2/(n+2))
    error('级比没有落入灰色模型的范围内');
else
   % 空行输出
    disp('              ');
    disp('可用G(1，1)建模');
end

% 做AGO累加处理
x1 = cumsum(x0);
for i = 2:n
    % 计算紧邻均值，也就是白化背景值
    z(i) = 0.5*(x1(i)+x1(i-1));
end
B = [-z(2:n)',ones(n-1,1)];
Y = x0(2:n)';
% 矩阵做除法，计算发展系数和灰色作用量
% 千万注意：这里是右除，不是左除
u = B\Y;
% 在MATLAB中，用大写做字母D表示导数,dsolve函数用来求解符号常微分方程
x = dsolve('Dx+a*x=b','x(0)=x0');
% subs函数的作用是替换元素，这里是把常量a,b,x0换成具体u(1),u(2),x1(1)数值
x = subs(x,{'a','b','x0'},{u(1),u(2),x1(1)});
forecast1 = subs(x,'t',0:n-1);
% digits和vpa函数用来控制计算的有效数字位数
digits(6);
% y值是AGO形式的（还是累加的）
y = vpa(x);
% 把AGO输出值进行累减
% diff用于对符号表达式进行求导
% 但是如果输入的是向量，则表示计算原向量相邻元素的差
forecast11 = double(forecast1);
exchange = diff(forecast11);
% 输出灰色模型预测的值
forecast = [x0(1),exchange]
% 计算残差
epsilon = x0 - forecast;
% 计算相对误差
delta = abs(epsilon./x0);

% 检验模型的误差
% 检验方法一：相对误差Q检验法
Q = mean(delta)
% 检验方法二：方差比C检验法
% 计算标准差函数为std（x，a）
% 如果后面一个参数a取0表示的是除以n－1，如果是1就是最后除以n
C = std(epsilon,1)/std(x0,1)
% 检验方法三：小误差概率P检验法
S1 = std(x0,1);
S1_new = S1*0.6745;
temp_P = find(abs(epsilon-mean(epsilon)) < S1_new);
P = length(temp_P)/n

% 绘制原始数列与灰色模型预测得出的数列差异折线图
plot(1:n,x0,'ro','markersize',11);
hold on
plot(1:n,forecast,'k-','linewidth',2.5);
grid on;
axis tight;
xlabel('x');
ylabel('y');
title('保有量比例与时间序列的关系');
legend('原始数列','模型数列');
