function weights = EntropyWeight(D,flag)
%% 熵权法求指标权重,R为输入矩阵,返回权重向量weights

[rows,cols]=size(D);   % 输入矩阵的大小,rows为对象个数，cols为指标个数
R = zeros(size(D));
a=min(D);
b=max(D);
% 归一化
for i=1:rows
    for j=1:cols
        if flag(j)==1
            R(i,j)=(D(i,j)-a(j))/(b(j)-a(j)); %高优指标处理
        else
            R(i,j)=(b(j)-D(i,j))/(b(j)-a(j));%低优指标处理
        end
    end
end
k=1/log(rows);         % 求k

f=zeros(rows,cols);    % 初始化fij
sumBycols=sum(R,1);    % 输入矩阵的每一列之和(结果为一个1*cols的行向量)
% 计算fij
for i=1:rows
    for j=1:cols
        f(i,j)=R(i,j)./sumBycols(1,j);
    end
end

lnfij=zeros(rows,cols);  % 初始化lnfij
% 计算lnfij
for i=1:rows
    for j=1:cols
        if f(i,j)==0
            lnfij(i,j)=0;
        else
            lnfij(i,j)=log(f(i,j));
        end
    end
end

Hj=-k*(sum(f.*lnfij,1)); % 计算熵值Hj
weights=(1-Hj)/(cols-sum(Hj));
end