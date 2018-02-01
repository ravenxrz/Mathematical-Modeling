%forest fire
% 参数说明
% burning -> empty
% green -> burning if one neigbor burning or with prob=f (lightning)
% empty -> green with prob=p (growth)
% veg = {empty=0 burning=1 green=2}
% 清空
clear;close;clc;
%% 初始化
n=200;
Plightning = .00005;
Pgrowth = .01; %.01
z=zeros(n,n);
o=ones(n,n);
veg=z;
sum=z;
imh = image(cat(3,z,veg*.02,z));
UP= [n 1:n-1];
LEFT = UP;
DOWN = [2:n 1];
RIGHT = DOWN;

for i=1:1000
    % 求着火的邻居
    sum = (veg(UP,:) == 1) + ( veg(DOWN,:)==1) ...
        +(veg(:,LEFT) == 1)+(veg(:,RIGHT) == 1);
    
    veg = 2*( (veg == 2) | ((veg == 0) & (rand(n) <Pgrowth)) )-...     % 下一状态为数
        ( sum >0 | ((veg == 2) & (rand(n) < Plightning)) );
    
    set(imh, 'cdata', cat(3,(veg==1),(veg==2),z) )
    drawnow
    pause(0.2);
end

