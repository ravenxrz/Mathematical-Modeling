function w = shang(x,standard,flag)
% x 决策矩阵
% standard 是否已经处理化
% flag 判断类型
%cols矩阵列表示评价指标
%行rows表示待选择方案

a=min(x);
b=max(x);
[rows,cols]=size(x);
if (nargin == 2 && standard == 0)
    flag = ones(1,cols);
end

k=1/log(rows);

%标准化指标
if(standard == 0)
    for i=1:rows
        for j=1:cols
            if flag(j)==1
                x(i,j)=(x(i,j)-a(j))/(b(j)-a(j)); %高优指标处理
            else
                x(i,j)=(b(j)-x(i,j))/(b(j)-a(j));%低优指标处理
            end
        end
    end
end

he=sum(x); %计算标准化矩阵的每一列的和，计算第i个待选方案第j个指标的值所占的概率
for i=1:rows
    for j=1:cols
        p(i,j)=x(i,j)/he(j);
    end
end
%指标归一化
for i=1:rows
    for j=1:cols
        if p(i,j)==0
            z(i,j)=0;
        else
            z(i,j)=log(p(i,j));
        end
    end
end

e=zeros(1,cols);
Q = p.*z;

for i = 1:cols
    e(i) = -k*sum(Q(:,i));
end

he=sum(e);
for i=1:cols
    w(i)=(1-e(i))/(cols-he);
end


