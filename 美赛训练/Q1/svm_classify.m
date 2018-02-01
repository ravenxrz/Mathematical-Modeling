% 采用支持向量机进行分类
clear;clc;close;
% 首先不进行PCA处理
data = load('raw_data.txt');
data(:,1:8) = [];
target = data(:,end);
target(target ~= 0) = 1;
data(:,end) = [];
data = PCA(data,0.9);
% 进行训练
useDataLength = 400;
% 前400组数据用来进行训练
trainData = data(1:useDataLength,:);
trainGroup = target(1:useDataLength,:);
SVMStruct = svmtrain(trainData,trainGroup,'kernel_function','linear');
% 测试数据
% index = randperm(size(data,1));
% testData = data(index,:);
% testGroup = target(index,:);
testData = data(useDataLength+1:end,:);
testGroup = target(useDataLength+1:end,:);

% 分类测试
classification = svmclassify(SVMStruct,testData);
%计算分类精度
count=sum(classification == testGroup);
disp(count/length(testData));