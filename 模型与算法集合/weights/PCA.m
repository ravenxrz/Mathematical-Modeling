% 计算数据得分，也可计算指标权重，提取最大的特征值所对应的特征向量。
function data = PCA(raw_data,T)
% raw_data 原始数据
% T 保留率
% data 新数据
% 读取数据
A = raw_data;
% 数据标准化
[a,b] = size(A);
% 数据按列进行放置
SA = zeros(a,b);
for i=1:b
    SA(:,i)=(A(:,i)-mean(A(:,i)))/std(A(:,i));  %归一化
end

% 求解相关系数
CM=corrcoef(SA);
% 计算特征值和特征向量
% V特征向量，D特征值
[V, D]=eig(CM);
% 提取特征值，计算贡献率和累计贡献率
DS = zeros(b,3);
DS(:,1) = diag(D);
% 反转，因为求解出的特征值为从小到大
DS = sortrows(DS,-1);
DS(:,2) = DS(:,1)./sum(DS(:,1));
DS(:,3) = cumsum(DS(:,2));

index = find(DS(:,3) >= T);
Com_num = index(1) ;

% 提取主成分对应的特征向量
PV = V(:,end:-1:end-Com_num+1);
% 计算在主成分得分
data=SA*PV;
















