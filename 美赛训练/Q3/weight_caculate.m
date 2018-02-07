% 计算权重
data = load('天气数据.txt');
data(:,end) = [];
EntropyWeight(data,[1 0 1 0])