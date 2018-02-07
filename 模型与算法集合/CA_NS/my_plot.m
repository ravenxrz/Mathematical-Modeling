% 绘制元胞自动机
clear;clc;close;


% plaza=zeros(n,n);
% 
% plaza(2,2) = 1;

% temp = plaza;
% temp(temp==1)=0;%create the palza without any cars
% plaza_draw=plaza;

n =3;
r_data = ones(n);
g_data = ones(n);
b_data = ones(n);
[L,W]=size(b_data); 

image(cat(3,r_data,g_data,b_data));


% figure('position',[100 100 200 700 ]);
% h=imagesc(PLAZA);
% title('Moore');
% colorbar;
hold on;
% % figure1 = figure(1);
plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k');% 绘制网格
plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k');
% % text(L/2,W/2,'?');
axis image
set(gca, 'xtick', [], 'ytick', []);
axis square;


