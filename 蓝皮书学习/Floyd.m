function dist=Floyd(a)
% 输入：a—邻接矩阵(aij)是指i 到j 之间的距离，可以是有向的
% 输出：dist—最短路的距离；
n=size(a,1);
for k=1:n
    for i=1:n
        for j=1:n
            if a(i,j)>a(i,k)+a(k,j)
                a(i,j)=a(i,k)+a(k,j);
            end
        end
    end
end
dist=a;

