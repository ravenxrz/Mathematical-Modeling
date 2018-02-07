% CA  forsest fire with firemen

clear all;close all;
%% 网格及元胞数据始化
a=5;                        %元胞边长
M=100;N=100;                %元胞初始尺寸
CA0=cell(M,N);              %初始元胞数组
dt=1;                       %时间步长
ft=80;                      %仿真终止时间
T=25;                       %温度
V=0;                        %风速
theta=0;                   %风向
Ks=[1,1.3,0.5,1.0,1.5,1.8]; %可燃物配置格局更正系数
n=2;                        %可燃物植被类型
tm=15*ones(M,N);            %单个元胞燃烧时间
x0=50;                      %火源横坐标
y0=50;                      %火源纵坐标  

rt=50;                      %火灾响应时间
num0=40;                    %消防覆盖元胞个数
p=0.8;                      %灭火强度


%% 初始化元胞状态A
%A=0到1或-1，0表示未燃烧，1表示完全燃烧，-1表示不能燃烧 
A0=zeros(M,N);               %初始状态未燃烧
A0(x0,y0)=1;                 %指定火源位置

A=A0;%当前元胞状态
A1=A0;%更新后的元胞状态

%% 传播速度R
b=0.053;
c=0.048;
d=0.275;
R0=b*T+c*V- d;%初始火蔓延速度
R=ones(M,N);

%% 地形坡度
% 地形数据导入
%%高斯分布地形数据
x=1:M;
y=1:N;
[X,Y]=meshgrid(x,y);
x1=50; 
y1=80;
s1=15;
s2=20;
%二维高斯函数
Z=5+50*exp(-((X-x1).^2./(2.*s1^2)+(Y-y1).^2./(2.*s2.^2)));

% %斜坡地形数据
% Z=10+Y./2;

% %平面地形数据
% Z=20*ones(M,N);

Z(1,1)=0;
meshz(X,Y,Z)%原始地形图
axis([0 100 0 100 0 100])
map=[0.8 0.8 0.8     %浅灰
    0 0 0      %深灰
    0 0.6 0         %深绿
    1 0.5 0          %橙红
    1 0.1 0] ;       %火红
colormap(map)
hold on
set(gcf,'position',[434.6000  189.0000  651.2000  464.0000])
xlabel('x')
ylabel('y')
zlabel('z')

%标记火源
z0=Z(x0,y0);
h1=plot3(x0,y0,z0+1,'*r','markersize',6,'linewidth',2);
h=Z;                %地形矩阵

%set(hp,'color','k')
%% 更新元胞数组状态
for t=1:dt:ft

    %灭火初始化
    if t==rt+1        %开始灭火
        [a0,b0]=find(A>0&A<1);
        
        [c0,d0]=max(a0);
        A(c0(1),b0(d0(1))+2)=-2;%从最北方的点开始灭火   
         A(c0(1),b0(d0(1))+1)=-2;
         z0=Z(c0(1),b0(d0(1)));
         h2=plot3(b0(d0(1)),c0(1)-1,z0+1,'ok','markersize',6,'linewidth',2);
         
%         [c0,d0]=min(a0);
%         A(c0(1),b0(d0(1)))=-2;%从最南方的点开始灭火  
%         z0=Z(c0(1),b0(d0(1)));
%              h2=plot3(c0(1)+2,b0(d0(1))-7,z0+3,'ok','markersize',6,'linewidth',2);
    end
    
    %判断燃烧是否结束
    if sum(A==1)==0
        t
        sum(sum(A<0))
        break;
        
    end
    num=num0;
    
    for i=2:M-1     %扫描方式更新元胞状态
        for j=2:N-1
            %8个坡度和风速对R的影响
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
             temp=A(i-1:i+1,j-1:j+1);
             temp1=double(temp==1);%找出A=1的元胞，及周围完全燃烧的元胞

             R(i-1:i+1,j-1:j+1)=temp1.*R(i-1:i+1,j-1:j+1);%未完全燃烧的不扩散
             if A(i,j)==1          %此元胞正完全燃烧
                  if sum(temp(temp==-2))~=0%元胞周围有灭火因子（状态为-2的元胞）
                      if num>0&&rand>1-p
                         A1(i,j)=-2; 
                         num=num-1;
                      end
                      
                  end
             else if A(i,j)==-1     %此元胞不能燃烧或已经燃烧完
                      A1(i,j)=-1 ;
                 else if A(i,j)==-2
                             A1(i,j)=-2;
                     else               %更新元胞状态
                         
                      if sum(temp(temp==-2))~=0%元胞周围有灭火因子（状态为-2的元胞）
                          if A(i,j)~=0
                              if num>0&&rand>1-p
                                  A1(i,j)=-2;
                                  num=num-1;
                              end                           
                          end
                      else
                        A1(i,j)=A(i,j)+(R(i-1,j)+R(i,j-1)+R(i+1,j)+R(i,j+1))*dt/a...
                           +(R(i-1,j-1)^2+R(i-1,j+1)^2+R(i+1,j+1)^2+R(i+1,j-1)^2)*dt/(2*a^2); 
                      end
                      
                     end
                     
                 end
             end           
        end
    end
    A1(A1>1)=1;
    tm(A1==1)=tm(A1==1)-1;
    A1(tm==0)=-1;%已燃烧完全，状态置为-1
    %火灾蔓延结果可视化
    
    % 颜色矩阵
    C=A1+2;
    C(1,1)=0;
    C(C==3)=4;
    C(C>2&C<3)=3;
    
    meshz(X,Y,Z,50*C)
    drawnow
  

    %产生新的当前元胞状态
    A=A1;
end
legend([h1,h2],'Fire source','Extinguishing starting point','Location','best')