%% Matlab神经网络43个案例分析

% 神经网络变量筛选—基于MIV的神经网络变量筛选
% by 王小川(@王小川_matlab)
% http://www.matlabsky.com
% Email:sina363@163.com
% http://weibo.com/hgsz2003

%% 清空环境变量
clc
clear
%% 产生输入 输出数据

% 数据
data = load('isi_bui_datas.txt');
target = data(:,end);
% 去掉无用变量
data(:,end) = [];


%设置网络输入输出值
p=data;
t=target;
[p,input_str] = mapminmax(p);
[t,output_str] = mapminmax(t);
t =t';

%% 变量筛选 MIV算法的初步实现（增加或者减少自变量）


[m,n]=size(p);
yy_temp=p;

% p_increase为增加10%的矩阵 p_decrease为减少10%的矩阵
for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*1.1;
    p(:,i)=pa;
    aa=['p_increase'  int2str(i) '=p;'];
    eval(aa);
end


for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*0.9;
    p(:,i)=pa;
    aa=['p_decrease' int2str(i) '=p;'];
    eval(aa);
end


%% 利用原始数据训练一个正确的神经网络
nntwarn off;
p=yy_temp;
p=p';
% bp网络建立
net=newff(minmax(p),[8,1],{'tansig','purelin'},'traingdm');
% 初始化bp网络
net=init(net);
% 网络训练参数设置
net.trainParam.show=50;
net.trainParam.lr=0.05;
% net.trainParam.mc=0.9;
net.trainParam.epochs=2000;

% bp网络训练
net=train(net,p,t);


%% 变量筛选 MIV算法的后续实现（差值计算）

% 转置后sim

for i=1:n
    eval(['p_increase',num2str(i),'=transpose(p_increase',num2str(i),');'])
end

for i=1:n
    eval(['p_decrease',num2str(i),'=transpose(p_decrease',num2str(i),');'])
end


% result_in为增加10%后的输出 result_de为减少10%后的输出
for i=1:n
    eval(['result_in',num2str(i),'=sim(net,','p_increase',num2str(i),');'])
end

for i=1:n
    eval(['result_de',num2str(i),'=sim(net,','p_decrease',num2str(i),');'])
end

for i=1:n
    eval(['result_in',num2str(i),'=transpose(result_in',num2str(i),');'])
end

for i=1:n
    eval(['result_de',num2str(i),'=transpose(result_de',num2str(i),');'])
end

%% MIV的值为各个项网络输出的MIV值 MIV被认为是在神经网络中评价变量相关的最好指标之一，其符号代表相关的方向，绝对值大小代表影响的相对重要性。


for i=1:n
    IV= ['result_in',num2str(i), '-result_de',num2str(i)];
    eval(['MIV_',num2str(i) ,'=mean(',IV,')'])
end
