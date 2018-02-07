function w = v2w(v)
% 风速转化到风力等级 
% v 风速
% w 转换到的等级
a = load('wind power.txt');
for i = 1:size(a,1)
    if a(i,1) <= v && a(i,2) >= v
        w = a(i,3);
        return;
    end
end