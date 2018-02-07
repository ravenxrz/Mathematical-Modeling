%MIV code
%本代码来自www.nnetinfo.com
%代码主旨用于教学,供大家学习理解用神经网络MIV算法检测输入与输出的相关性
clc;clear;
data = load('canada_datas.txt');
target = data(:,end);
data(:,5:(end-1)) = [];
data(:,end) = [];

inputData  = data'; %将x1,x2作为输入数据

outputData = target';       %将y作为输出数据

%使用用输入输出数据（inputData、outputData）建立网络，
net = newrb(inputData, outputData,0.01, 2);    %以X，Y建立径向基网络，目标误差为0.01，径向基的spread=2
%===================使用BP训练网络==========================
% net= newff(inputData,outputData,4,{'tansig','purelin'},'trainlm');
% net.divideParam.trainRatio =1;  %本例数据点较少，把数据全用于训练
% net.divideParam.valRatio =0;
% net.divideParam.testRatio =0;
% net= train(net,inputData,outputData);
%===================使用BP训练网络==========================
simout = sim(net,inputData); %调用matlab神经网络工具箱自带的sim函数得到网络的预测值

figure;  %新建画图窗口窗口
t=1:length(simout);
plot(t,outputData,'b',t,simout,'r')%画图，对比原来的y和网络预测的y

inputLen = size( inputData,1); %
delta    = zeros(1,inputLen);

for i = 1 : inputLen
    inputData1 = inputData;
    inputData1(i,:) = inputData1(i,:)*0.9; %对第i个输入减少10%
    
    inputData2 = inputData;
    inputData2(i,:) = inputData2(i,:)*1.1; %对第i个输入增加10%
    
    %求输入的落差引起网络输出的落差
    dd{i} = ( sim(net, inputData2) - sim(net, inputData1));
    delta(i) = mean(dd{i});
    disp(['变量',num2str(i),'的影响值 ： ',num2str(delta(i))])
end

% ===以下代码供研究使用，与MIV算法无关。=====================================
% ===下面的代码用于绘画网络在x1,x2上的拟合效果。
% ==可以看到在x1上是波动的，而在x2上是平缓的，所以在X1上的波动会引起网络输出的落差
% w1 = linspace(min(x1),max(x1),50);
% w2 = linspace(min(x2),max(x2),50);
% 
% [X1,X2]=meshgrid(w1,w2);
% [m,n] = size(X1);
% v = zeros(m,n);
% for  i = 1 : m
%     for j = 1 : n
%         v (i,j)=   sim(net,[X1(i,j);X2(i,j)]);
%     end
% end
% figure(2)
% surf(X1,X2,v)
% ===============================================================