% matlab遗传算法工具使用
%学习测试求解　f = x*sin(y)+y*sin(x) 在x,y属于0-10之间的最大值

% ga,gaoptimset为核心函数
%使用工具箱，能够操作的最多的为适应度函数，这也是我们平常能用到的最多的
%当然也可以进行一些参的设定，合理的设定可以使求解结果更精确也更快
clear;close;clc;
tic
% step1 设置遗传算法的一些参数
ops = gaoptimset('Generations',1000,'StallGenLimit',300,'PlotFcns',@gaplotbestf);
% setp2 进行计算
% final_pop可用于下一次开始的初始化种群，避免多次重复计算
% final_pop 可用于下次迭代，使用在gaoptimset,'InitialPopulation'参数,具体可见p91
[x,fval,reason,output,final_pop] = ga(@fitness,2,ops);
toc