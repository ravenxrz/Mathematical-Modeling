clear;clc;close;
% 0 empty
% 1 fire
% 2 tree
n=300;
rest = n*n*0.9;
% 生长率
deltax = 0.000001;
total = 0.00001;
maybe = zeros(10+1,2);
for i1 = 0:10
    pgrowth = i1*deltax;
    % 蔓延率
    for i2 = 1:-0.01:0.5
        % 参数初始化
        clf;
        pspread = i2;
        ul=[n,1:n-1];
        dr=[2:n,1];
        veg=zeros(n);
        imh=image(cat(3,veg,veg,veg));
        axis square;
        record_num = 5;
        record = zeros(1,record_num);
        flag = 0;
        
        hang=fix((n-1)*rand(1))+1;
        lie=fix((n-1)*rand(1))+1;
        veg=2*ones(n);
        veg(hang,lie)=1;
        % 仿真开始
        for  j=1:1000
            e=length(find(veg==0));
            if(e>rest)
                flag = 1;
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
%                drawnow %更新事件队列强迫 matlab 刷新屏幕
            end
        end
        % 记录可能的停止率
        if(flag == 1)
            flag = 0;
            maybe(i1+1,2) = i2;
        else
            maybe(i1+1,1) = i2;
            break;
        end
    end
end

