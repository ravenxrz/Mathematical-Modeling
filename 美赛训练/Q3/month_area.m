% 收集12个月燃烧面积的平均值
close all;
data = load('坐标数据.txt');
month = data(:,3);
area = data(:,end);
count = zeros(12,1);
record = zeros(12,1);   

for i = 1:12
    index = find(month == i);
    count(i) = length(find(area(index) ~= 0));
    record(i) =mean(area(index));
   
end

figure;
bar(count);
figure;
bar(record);

 eight = data(month == 8,:);
record = zeros(9,9);
count  = zeros(9,9);
for i = 1:size(eight,1)
    xy = eight(i,1:2);
    record(xy(1),xy(2))  = record(xy(1),xy(2))+eight(i,end);
    if eight(i,end) ~= 0
        count(xy(1),xy(2)) = count(xy(1),xy(2))+1;
    end
end
final = record./count;
[X,Y] = meshgrid(1:9);
figure;
temp = final;
final(isnan(final)) = 0;
contourf(Y,X,final);title('平均燃烧面积');

figure;
contourf(Y,X,count);title('燃烧次数');
