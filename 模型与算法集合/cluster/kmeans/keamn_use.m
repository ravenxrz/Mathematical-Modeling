% æ€¿‡À„∑®≤‚ ‘
close;clc;clear;
x=[0 0;1 0; 0 1; 1 1;2 1;1 2; 2 2;3 2; 6 6; 7 6; 8 6; 6 7; 7 7; 8 7; 9 7 ; 7 8; 8 8; 9 8; 8 9 ; 9 9];
[idx,C,sumd,D] = kmeans(x,2,'Display','iter','MaxIter',1000,'distance','cityblock');
plot(x(idx == 1,1),x(idx==1,2),'ro',x(idx == 2,1),x(idx == 2,2),'bo');hold on;
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3);
 figure;
 [silh,~] = silhouette(x,idx,'cityblock');
h = gca;
h.Children.EdgeColor = [.8 .8 1];
xlabel 'Silhouette Value';
ylabel 'Cluster';
