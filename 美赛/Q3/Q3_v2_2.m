% 静区最多衰减
clear;close;clc;
down = deg2rad(22);     % 下界
up = deg2rad(60);           % 上界
hup = 150*10^3;         %E层
hdown = 60*10^3;    %D层
total = (hdown/sin(down)*cos(down) - hup/sin(up)*cos(up) )*2;
v = 50 * 1.852;
total/v