x1=randn(10,1);
x2=randn(10,1)+10;
x3=randn(10,1)+20;
x=[x1;x2;x3];
y=randn(30,1);
T=clusterdata([x,y],3)
temp1=find(T==1)
plot(x(temp1),y(temp1),'rd','markersize',10,'markerfacecolor','r')
hold on
temp1=find(T==2)
plot(x(temp1),y(temp1),'yd','markersize',10,'markerfacecolor','y')
temp1=find(T==3)
plot(x(temp1),y(temp1),'kd','markersize',10,'markerfacecolor','k')
legend('cluster 1','cluster 2','cluster 3')