clc;
close;
clear all;
% 控制输出结果精度
format short;
% 原始数据
x= load('raw_data.txt');
x(:,1:4) = [];
n1=size(x,2);
% 数据标准化处理
for i = 1:n1
    x(:,i) = x(:,i)./x(:,1);
end
% 保存中间变量，亦可省略此步，将原始数据赋予变量data
data=x;
% 分离参考数列（母因素）
consult=data(:,end);
m1=size(consult,2);
% 分离比较数列（子因素）
compare=data(:,1:end-1);
m2=size(compare,2);
for i=1:m1
    for j=1:m2
        t(:,j)=compare(:,j)-consult(:,i);
    end
    min_min=min(min(abs(t)));
    max_max=max(max(abs(t)));
    % 通常分辨率都是取0.5
    resolution=0.5;
    % 计算关联系数
    coefficient=(min_min+resolution*max_max)./(abs(t)+resolution*max_max);
    % 计算关联度
    corr_degree=sum(coefficient)/size(coefficient,1);
    r(:,i)=corr_degree;
end

r
