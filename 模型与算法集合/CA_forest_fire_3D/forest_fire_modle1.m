% CA  forsest fire without firemen

clear all;close all;
%% 网格及元胞数据始化
a=5;                        %元胞边长
M=100;N=100;                %元胞初始尺寸
dt=1;                       %时间步长
ft=50;                     %仿真终止时间
T=25;                       %温度
V=3;                        %风速
theta=90;                   %风向
Ks=[1,1.3,0.5,1.0,1.5,1.8]; %可燃物配置格局更正系数
n=2;                        %可燃物植被类型
tm=20*ones(M,N);            %单个元胞燃烧时间
x0=50;                      %火源横坐标
y0=50;                      %火源纵坐标  
%% 初始化元胞状态A
%A=0到1或-1，0表示未燃烧，1表示完全燃烧，-1表示不能燃烧 
A0=zeros(M,N);               %初始状态未燃烧
A0(x0,y0)=1;                 %指定火源位置

% %加防火带
% r=15;%隔离半径
% x00=x0+6;
% y00=y0;
% x1=[x00-r:0.01:x00+r];
% y1=round(sqrt(r^2-(x1-x00).^2)+y00);
% y2=round(-sqrt(r^2-(x1-x00).^2)+y00);
% for i=1:size(x1,2)
%     A0(round(x1(i)),y1(i))=-2;
%     A0(round(x1(i)),y2(i))=-2;
% end

A=A0;%当前元胞状态
A1=A0;%更新后的元胞状态

%% 传播速度R
b=0.053;
c=0.048;
d=0.275;
R0=b*T+c*V-d;%初始火蔓延速度
R=ones(M,N);

%% 地形坡度
% 地形数据导入

%网格
x=1:M;
y=1:N;
[X,Y]=meshgrid(x,y);

%%高斯分布地形数据
x1=50; 
y1=80;
s1=15;
s2=20;
%二维高斯函数
Z=5+100*exp(-((X-x1).^2./(2.*s1^2)+(Y-y1).^2./(2.*s2.^2)));

% %斜坡地形数据
% Z=10+Y./2;

% %平面地形数据
% Z=20*ones(M,N);

Z(1,1)=0;
% meshz(X,Y,Z)%原始地形图
axis([0 100 0 100 0 200])
map=[1 1 1           %白      -2
    0 0 0            %黑      -1
    0 0.6 0          %深绿     0
    1 0.5 0          %橙红    0-1
    1 0.1 0] ;       %火红     1
colormap(map)
colorbar
meshz(X,Y,Z)%原始地形图
hold on
set(gcf,'position',[200 189.0000  651.2000  464.0000])
xlabel('x')
ylabel('y')
zlabel('z')

%标记火源
z0=Z(x0,y0);
hp=plot3(x0,y0,z0+1,'*r','markersize',6,'linewidth',2);
h=Z;                %地形矩阵

%% 更新元胞数组状态
for t=1:dt:ft

    
        %燃烧结束，计算结果
        if sum(A==1)==0
        t
        sum(sum(A==-1))
        break;       
    end
    
    
    for i=2:M-1     %扫描方式更新元胞状态
        for j=2:N-1
            %坡度和风速对8个方向R的影响
            %OA方向
            Kw=exp(0.1783*V*cos((315-theta)*pi/180));%风更正系数
            dh=h(i,j)-h(i-1,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%地形坡度更正系数 
            R(i-1,j-1)=R0*Ks(n)*Kw*Kf;
            %OB方向
            Kw=exp(0.1783*V*cos((theta)*pi/180));%风更正系数
            dh=h(i,j)-h(i-1,j)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%地形坡度更正系数 
            R(i-1,j)=R0*Ks(n)*Kw*Kf;
            %OC方向
            Kw=exp(0.1783*V*cos((theta-45)*pi/180));%风更正系数
            dh=h(i,j)-h(i-1,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%地形坡度更正系数 
            R(i-1,j+1)=R0*Ks(n)*Kw*Kf;
            %OD方向
            Kw=exp(0.1783*V*cos((theta-90)*pi/180));%风更正系数
            dh=h(i,j)-h(i,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%地形坡度更正系数 
            R(i,j+1)=R0*Ks(n)*Kw*Kf;
            %OE方向
            Kw=exp(0.1783*V*cos((theta-135)*pi/180));%风更正系数
            dh=h(i,j)-h(i+1,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%地形坡度更正系数 
            R(i+1,j+1)=R0*Ks(n)*Kw*Kf;
            %OF方向
            Kw=exp(0.1783*V*cos((theta-180)*pi/180));%风更正系数
            dh=h(i,j)-h(i+1,j)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%地形坡度更正系数 
            R(i+1,j)=R0*Ks(n)*Kw*Kf;
            %OG方向
            Kw=exp(0.1783*V*cos((225-theta)*pi/180));%风更正系数
            dh=h(i,j)-h(i+1,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%地形坡度更正系数 
            R(i+1,j-1)=R0*Ks(n)*Kw*Kf;
            %OH方向
            Kw=exp(0.1783*V*cos((theta+90)*pi/180));%风更正系数
            dh=h(i,j)-h(i,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%地形坡度更正系数 
            R(i,j-1)=R0*Ks(n)*Kw*Kf;
              
            %更新元胞状态A
             tempA=A(i-1:i+1,j-1:j+1);
             tempA=double(tempA==1);%找出A=1的元胞，及周围完全燃烧的元胞
             R(i-1:i+1,j-1:j+1)=tempA.*R(i-1:i+1,j-1:j+1);%未完全燃烧的不扩散
             if A(i,j)==1          %此元胞以完全燃烧
                 A1(i,j)=1;
             else if A(i,j)==-1     %此元胞不能燃烧
                     A1(i,j)=-1;
                 else  if A(i,j)==-2
                         %do nothing
                     else    %更新元胞状态
                        A1(i,j)=A(i,j)+(R(i-1,j)+R(i,j-1)+R(i+1,j)+R(i,j+1))*dt/a...
                           +(R(i-1,j-1)^2+R(i-1,j+1)^2+R(i+1,j+1)^2+R(i+1,j-1)^2)*dt/(2*a^2); 
                        end
                     end
             end
             
        end
    end
%             %加防火带
%         if t>60
%             A1(A1>0&A1<1)=-2;
%         end
    
    A1(A1>1)=1;
    tm(A1==1)=tm(A1==1)-1;
    A1(tm==0)=-1;%已燃烧完全，状态置为-1
    

    %火灾蔓延结果可视化
    
    % 颜色矩阵
    C=A+2;
    C(1,1)=0;
    C(C==3)=4;
    C(C>2&C<3)=3;
    
    meshz(X,Y,Z,10*C)
    drawnow
  
    %跟新当前元胞状态
    A=A1;
end
legend([hp],'Fire source','Location','best')