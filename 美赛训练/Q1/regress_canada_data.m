% 加拿大数据回归
clear;clc;
data = load('canada_datas.txt');
fwi = load('canada_datas_fwi.txt');
% 归一化
for i = 1:size(data,2)
    data(:,i) = (data(:,i) - mean(data(:,i))./std(data(:,i)));
end

figure(1); 
fwi = (fwi - mean(fwi))/std(fwi);
index = find(fwi >= 0.97);
data(index,:) = [];
fwi(index,:) = [];
% 去掉风向
data(:,4) = [];
[b,bint,r,rint,stats] = regress(fwi,[ones(size(data,1)),data]);
rcoplot(r,rint);