%%清空环境变量
clc
clear
close all

%原始数据
data = load('天气数据.txt');
target = data(:,end);
useLength = 200;
p=data(1:useLength,:);  %输入数据矩阵
t=target(1:useLength,:);           %目标数据矩阵
p = p';
t = t';
% 利用mapminmax函数对数据进行归一化
[pn,input_str] = mapminmax(p) ;
[tn,output_str] = mapminmax(t) ;


%%网络建立和训练
%网络建立，输入为[x1;x2]，输出为F。spread使用默认
net=newrb(pn,tn,10^-40,2);
%%网络的效果验证
%将原数据回带，测试网络效果
ty=sim(net,pn);
ty = mapminmax('reverse',ty,output_str);
x = 1:length(t);
%%使用图像来看网络对非线性函数的拟合效果
plot(x,t(1,:),'r-o',x,ty(1,:),'b--+')

% 预测
pnew= data(useLength+1:end,:);
pnew = pnew';
%归一化
pnew = mapminmax('apply',pnew,input_str);
tnew = sim(net,pnew);
% 去归一化
tnew = mapminmax('reverse',tnew,output_str)
figure;
plot(target(useLength+1:end,:));hold on;plot(tnew);

