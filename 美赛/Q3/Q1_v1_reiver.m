% 问题一-计算通过海平面反射最多有几跳
% 假设：数据统计均在白天,各层的电子密度均为常数
%% 电离层衰减
% 初始化
clear;clc;close all;
Pin = 100;      % 输入功率
L_Pin = 10*log10(Pin);

N = [               % 各层电子密度
    2.5*10^9        % D层
    2*10^11         % E层
    ];
v = [
    5*10^6;    % D层
    10^5;          %E层
    ];
c = 3*10^8;
e = 1.60217662 * 10^(-19);  % 电量
hup = 150*10^3;
hdown = 60*10^3;
deltah = hup - hdown;       % 高度差
hmax = 200*10^3; % 最高高度
Nmax = 8*10^11; % 最大电子密度
R = 6371*10^3;      % 地球半径
m = 9.106*10^(-31);
Lg = 15.4;        % 12点的额外损耗

N1= 35;
N2 = -2;

k = 1;
between = 60:-1:20;
for i = between
    delta = deg2rad(i);    % 仰角

    fmax = sqrt((80.8*Nmax*(1+2*hmax/R))/(sin(delta)^2+2*hmax/R));      % 最大频率估算公式
    f = 0.85*fmax;    % 工作频率
    lamda = c /f;   % 波长
    w = 2*pi*f;     % 工作角频率
    Fa = 10*log10(1.38*10^(-23)*290*f);       %噪声
    noise = Fa+N1+N2;
    
    %% 损耗计算  
    l = deltah/sin(delta);
    a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D层吸收损耗
    La1 = exp(-a1*l)*2;
    a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E层吸收损耗
    La2 = exp(-a2*l)*2;
    La = La1+La2;

    
    %% 海洋平面衰减
    % 初始化
    er = 70;            % 相对介电常数
    o = 5;            % 海水电导率
    ee = er+60*lamda*o*i;     % 海面复介电常数
    
    % 静态
    RH = (sin(delta)-sqrt(ee - cos(delta)^2))/(sin(delta)+sqrt(ee-cos(delta)^2));
    RV = (ee*sin(delta) - sqrt(ee - cos(delta)^2))/(ee*sin(delta)+sqrt(ee - cos(delta)^2));
    R1 = (abs(RV)^2 + abs(RH)^2);
    Lg_static = abs(10*log10(R1/2));
    
    % 动态-加入修正因子
    wind = 10;      % 风速
    h = 0.0051*wind^2;  % 海浪均方根高度
    g = 0.5*(4*pi*h*f*sin(delta)/c)^2;
    p = 1/sqrt(3.2*g-2+sqrt((3.2*g)^2-7*g+9));
    R2 = p*R1;
    Lg_dynamic =abs(10*log10(R2/2));
    
    % 统计单跳
    total = L_Pin-15.4-32.45-20*log10(f/10^6) -noise + 10;
    n1 = intvar(1,1);
    C = [
        n1*(La+Lg_static)+20*log10(150*cos(delta)/sin(delta)*2*n1)<=total;
        ];
    z = -n1;
    result = optimize(C,z);
    X1(k) = value(n1);
    
    if X1(k) == 0
           x_static(k)= NaN;        % 单跳
    else
        x_static(k)=  Lg_static +La +  20*log10(150*cos(delta)/sin(delta)*2)+(20*log(f/10^6)+32.45)/X1(k);        % 单跳
      
    end
    

    
    
    k = k+1;
end
% figure;
% plot(between,x_static,between,x_dynmic);legend('静态','动态');
figure;
plot(between,X1);xlabel('Antenna elevation angle');ylabel('Hup');
