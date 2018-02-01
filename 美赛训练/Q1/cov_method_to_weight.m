% 初始化
clear;clc;close;
% 数据读入
datas = load('canada_datas.txt');
temp = datas(:,1);
RH = datas(:,2);
ws = datas(:,3);
rain = datas(:,4);

FFMC = datas(:,5);
DMC = datas(:,6);
DC = datas(:,7);
ISI = datas(:,8);
BUI = datas(:,9);

FWI = datas(:,10);

n = length(FWI);

% 各项回归
[b_dc,~,r_dc,rint_dc,stats_dc] = regress(DC,[ones(n,1),rain,temp]);


[b_fwi,bint,r_fwi,rint_fwi,stats_fwi] = regress(FWI,[ones(n,1),BUI,ISI]);