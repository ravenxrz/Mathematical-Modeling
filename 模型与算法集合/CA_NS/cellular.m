%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A Two-Lane Cellular Automaton Traffic Flow Model with the Keep-Right Rule
%edited by Milky Zhang,Image Information Institute in Sichuan Universiyt 2014/2/14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;

B=3;             %The number of the lanes
plazalength=50;  %The length of the simulating highways
h=NaN;           %h is the handle of the image


[plaza,v]=create_plaza(B,plazalength);
h=show_plaza(plaza,h,0.1);

iterations=1000;    % 迭代次数
probc=0.1;          % 车辆的密度
probv=[0.1 1];      % 两种车流的密度分布
probslow=0.3;       % 随机慢化的概率
Dsafe=1;            % 表示换道事车至少与后面车距离多少个单位才算安全
VTypes=[1,2,3,4];       %道路上一共有几种最大速度不同的车辆,速度是什么
[plaza,v,vmax]=new_cars(plaza,v,probc,probv,VTypes);%一开始就在车道上布置车辆，做周期循环驾驶，也方便观察流量密度之间的关系

size(find(plaza==1))
PLAZA=rot90(plaza,2);
h=show_plaza(plaza,h,0.1);
for t=1:iterations;
    size(find(plaza==1))
    PLAZA=rot90(plaza,2);
    h=show_plaza(PLAZA,h,0.1);
    [v,gap,LUP,LDOWN]=para_count(plaza,v,vmax);
    [plaza,v,vmax]=switch_lane(plaza,v,vmax,gap,LUP,LDOWN);
    [plaza,v,vmax]=random_slow(plaza,v,vmax,probslow);
    [plaza,v,vmax]=move_forward(plaza,v,vmax);
end




