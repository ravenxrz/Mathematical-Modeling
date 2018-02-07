clear;clc;close;
% 0 empty
% 1 fire
% 2 tree
n=300;      % 森林面积
ul=[n,1:n-1];
dr=[2:n,1];

pgrowth  = 0;   % 生长率
rest = n*n*0.9;     % 烧毁度
deltax = -0.02; 
total = 0.6;        % 控制传播率

n3 = n/3;
location = [
    n/2 n/2
    round(1*n3*1/2),round(n3*2+n3/2)
    round(n3+n3/2),round(n3*2+n3/2)
    ];

% hang=round(n/2);    % 控制燃烧点
% lie=round(n/2);

num = size(location,1);
record_num = 4;
record = zeros(num,record_num);     % 数据记录
sp = 1+[deltax*(1:num)]';
% 蔓延率
pspread = 0.7;
for i = 1:num
    % 参数初始化
    clf;
    l =  location(i,:);
    hang = l(1);
    lie = l(2);
    % 为求平均，对一个蔓延率仿真
    for j = 1:record_num
        veg=zeros(n);
        imh=image(cat(3,veg,veg,veg));
        axis square;
        veg=2*ones(n);
        veg(hang,lie)=1;
        % 仿真开始
        for  k=1:600
            e=length(find(veg==0));
            if(e>rest)
                break
            else
                h1=veg;
                h2=h1;
                h3=h2;
                h4=h3;
                h1(n,1:n)=0;
                h2(1:n,n)=0;
                h3(1:n,1)=0;
                h4(1,1:n)=0;
                sum=(h1(ul,:)==1)+(h2(:,ul)==1)+(h3(:,dr)==1)+(h4(dr,:)==1);
                sum1=((sum==1).*(1-(1-pspread)));
                sum2=((sum==2).*(1-(1-pspread)^2));
                sum3=((sum==3).*(1-(1-pspread)^3));
                sum4=((sum==4).*(1-(1-pspread)^4));
                s=sum1+sum2+sum3+sum4;
                veg=2*(veg==2)-((veg==2)&((sum>0)&(rand(n,n)<s)))+2*((veg==0)&rand(n,n)<pgrowth);
                set(imh,'cdata',cat(3,(veg==1),(veg==2),zeros(n)))
                drawnow %更新事件队列强迫 matlab 刷新屏幕
            end
        end
        record(i,j) = k;
    end
    
end
% 绘图
mean_t = mean(record,2);
% plot(sp,mean_t);

