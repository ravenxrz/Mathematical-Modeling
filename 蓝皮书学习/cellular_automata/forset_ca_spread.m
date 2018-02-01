clear;clc;close;
% 0 empty 
% 1 fire
% 2 tree
n=300;
pspread=0.62;
pgrowth=0.001;
ul=[n,1:n-1];
dr=[2:n,1];
veg=zeros(n);
hang=fix((n-1)*rand(1))+1;
lie=fix((n-1)*rand(1))+1;
veg(hang,lie)=1;
imh=image(cat(3,veg,veg,veg));
axis square;
veg=2*ones(n);
veg(hang,lie)=1;
for  i=1:3000
    e=length(find(veg==0));
    if(e>85500)
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
        pause(0.000000001)
        drawnow %更新事件队列强迫 matlab 刷新屏幕
    end
end
i