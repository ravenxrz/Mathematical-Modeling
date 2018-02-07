clc;
close ;
clear ;
% 原始数据-数据版本1.0
% data = load('raw_data.txt');
% 数据预处理，按月份分开
% [row,col] = size(data);
% temp_data = [];
% for i = 1:12
%     index = find(data(:,3) == i);
%     temp_data =[temp_data;data(index,:)];
% end
% data(:,1:8) = [];
% target = data(:,end);
% target(target ~= 0) = 1;
% data(:,end) = [];
% data = PCA(data,0.9);

% 原始数据-加拿大数据
data = load('canada_datas.txt');

target = data(:,end);
data(:,[1,5,6]) = [];
data(:,end) = [];
useLength = 150;

% 输入数据矩阵
p=data(1:useLength,:)';
% 目标数据矩阵
t  = target(1:useLength,:)';
% 利用mapminmax函数对数据进行归一化
[pn,input_str] = mapminmax(p) ;
[tn,output_str] = mapminmax(t) ;

% 建立BP神经网络，相对旧一点的MATLAB版本，新版本 newff 函数使用更简洁一些
% 但是本质和性能没有区别
net=newff(pn,tn,[size(p,1) 10 size(t,1)],{'purelin','logsig','purelin'});
% 10轮回显示一次结果
net.trainParam.show=10;
% 学习速度为0.05
net.trainParam.lr=0.045;
% 最大训练次数为5000次
net.trainParam.epochs=3000;
% 均方误差
net.trainParam.goal=0.65*10^(-3);
% 网络误差如果连续6次迭代都没有变化，训练将会自动终止（系统默认的）
% 为了让程序继续运行，用以下命令取消这条设置
net.divideFcn = '';
% 开始训练，其中pn,tn分别为输入输出样本
net=train(net,pn,tn);
% 利用训练好的网络，基于原始数据对BP网络仿真
an=sim(net,pn);

% 利用函数mapminmax把仿真得到的数据还原为原始的数量级
% 新版本推荐训练样本归一化和反归一化都使用 mapminmax 函数
a = mapminmax('reverse',an,output_str);

% 输出
subplot(211);
plot(target(1:useLength));hold on;plot(a);title('Actual sample and simulation sample');
legend('Actual','simulation');

% 测试数据
% index = randperm(useLength,50);
index = useLength+1:size(data,1);
testData = data(index,:);
testGroup = target(index,:);
testData = testData';
testGroup = testGroup';

% 归一化处理
ptn = mapminmax('apply',testData,input_str);
tts = sim(net,ptn);
% 反归一化
ttd = mapminmax('reverse',tts,output_str);
subplot(212);
subplot(212);
plot(testGroup);hold on;
plot(ttd);title('Actual sample and simulation sample');
legend('Actual','simulation');

mean(abs(ttd-testGroup)./testGroup)
