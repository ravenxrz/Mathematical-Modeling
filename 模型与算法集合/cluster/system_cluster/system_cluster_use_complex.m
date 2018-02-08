x1=randn(10,1);  
x2=randn(10,1)+10;  
x3=randn(10,1)+20;  
X=[x1;x2;x3];  
Y=randn(30,1);  

X2=zscore(X); %标准化数据  
Y2=pdist(X2); %计算距离  
% Step2 定义变量之间的连接  
Z2=linkage(Y2);  
% Step3 评价聚类信息  
C2=cophenet(Z2,Y2); %0.94698  
% Step4 创建聚类，并作出谱系图  
T=cluster(Z2,6);  
H=dendrogram(Z2);  
