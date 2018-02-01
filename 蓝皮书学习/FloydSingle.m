function [dist,mypath]=FloydSingle(a,sb,db)
% 输入：a—邻接矩阵(aij)是指i 到j 之间的距离，可以是有向的
% sb—起点的标号；db—终点的标号
% 输出：dist—最短路的距离；
% mypath—最短路的路径
n=size(a,1); path=zeros(n);
for i=1:n
    for j=1:n
        if a(i,j)~=inf
            path(i,j)=j; %j 是i 的后续点
        end
    end
end
for k=1:n
    for i=1:n
        for j=1:n
            if a(i,j)>a(i,k)+a(k,j)
                a(i,j)=a(i,k)+a(k,j);
                path(i,j)=path(i,k);
            end
        end
    end
end
dist=a(sb,db);
mypath=sb; t=sb;
while t~=db
    temp=path(t,db);
    mypath=[mypath,temp];
    t=temp;
end
