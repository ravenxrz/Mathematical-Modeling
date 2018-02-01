% 本程序添加了动量因子
% 本程序是基于梯度训练算法的RBF网络
% 所以添加动量因子以便不会轻易陷入局部极小值
clc;
close all;
clear all;
warning off;
% 初始化参数
% 该网络有三层，输入层和输出层都是线性函数，隐含层由距离函数和激活函数构成
SamNum = 120;
TargetSamNum = 60;
% 样本输入维度
InDim = 1;
% 隐含层神经元数量
UnitNum = 10;
MaxEpoch = 10000;
% 目标误差
E0 = 0.09;

% 输入置于[1,60]区间的随机数
% 理论样本
SamIn = sort(59*rand(1,SamNum)+1);
SamOut = 0.5447*SamIn.^0.1489;

% 实际样本
TargetIn = 1:60;
TargetOut = [0.53173198482933 
0.599828865
0.644564773
0.671027441
0.697281167
0.717013297
0.732752613
0.745040151
0.75565936
0.763524144
0.779177473
0.792189854
0.806571209
0.813644571
0.822233807
0.826976013
0.837737352
0.842773177
0.854878049
0.859771055
0.863536819
0.865907219
0.869966906
0.872734818
0.875641915
0.878079332
0.881514601
0.886842845
0.891857506
0.898078292
0.906074968
0.910126947
0.91328894
0.917005814
0.920081668
0.924666569
0.928067079
0.932732111
0.936609264
0.940518784
0.94417839
0.946870779
0.958960328
0.961151737
0.963206107
0.964973998
0.967341306
0.96778647
0.968232044
0.970466082
0.974362934
0.98011496
0.98424337
0.987633062
0.991046183
0.995581505
0.997785861
1
1
1]';

figure;
hold on;
% 添加边框和网格线
box on;
grid on;
plot(SamIn,SamOut,'kO');
plot(TargetIn,TargetOut,'b-');
xlabel('x');
ylabel('y');
title('训练和测试图');

% 原始样本对（输入和输出）初始化
[SamIn,minp,maxp,SamOut,mint,maxt] = premnmx(SamIn,SamOut); 

% 利用原始输入数据的归一化参数对新数据进行归一化；
TargetIn = tramnmx(TargetIn,minp,maxp);    
TargetOut = tramnmx(TargetOut,mint,maxt);   

% 初始化数据中心
Center = 8*rand(InDim,UnitNum)-4;
% 初始化宽度
SP = 0.2*rand(1,UnitNum)+0.1;
% 初始化权值，这里的权值是指隐含层与输出层之间的权值
% 跟BP网络不同的是，这里没有输入层与隐含层之间的权值
% 所以单从网络结构上讲，RBF网其实更简单
W = 0.2*rand(1,UnitNum)-0.1;

% 数据中心学习速度（速率）
lrCent = 0.02;
% 宽度学习速度（速率）
lrSP = 0.001;
% 权值学习速度（速率）
lrW = 0.001;
% 动量因子系数
arf = 0.001;

% 用来存储误差
ErrHistory = [];

for epoch = 1:MaxEpoch
% 计算书中输出样本与数据中心之间的距离（这里是欧式距离）
% 相当于书中的||x-c||表达式，其具体表达式为 sum((x-y).^2).^0.5
    AllDist = dist(Center',SamIn);
SPMat = repmat(SP',1,SamNum);
% 以高斯函数作为激活函数，高斯函数表达式为exp(-n^2)
UnitOut = radbas(AllDist./SPMat);
% 隐含层神经元数据经过加权后在输出层输出
% 输出层是线性激活函数所以直接加权输出即可
    NetOut = W*UnitOut;
    Error = SamOut-NetOut;
    
    SSE = sumsqr(Error)
    ErrHistory = [ErrHistory SSE];

    if SSE<E0,break,end
    
        % 初始化用来存储前一次调整量的变量，全部用0矩阵填充
        CentGrad = zeros(size(Center(:,1))); 
        SPGrad = zeros(size(SP(1))); 
        WGrad = zeros(size(W(1)));
    
    for i = 1:UnitNum
        
       % 存储前一次训练的调整量，以下是数据中心前一次调整量赋给变量CenterPre
       % 以便后续动量因子会用到
        CenterPre = CentGrad ;
       % 宽度前一次调整量
        SPPre = SPGrad ;
       % 隐含层与输出层之间的连接权值矩阵前一次调整量
        WPre = WGrad ;
      
        % 数据中心的网络反向调整
        % 原理仍然是链式偏导
        % 根据求导，数据中心的调整量CentGrad等于 （样本-数据中心）*误差*隐含层网络输出
% *权值/宽度平方
% 以下宽度调整量和权值调整量类似
CentGrad=(SamIn-repmat(Center(:,i),1,SamNum))*(Error.*UnitOut(i,:)*W(i)/(SP(i)^2))'; 
    SPGrad = AllDist(i,:).^2*(Error.*UnitOut(i,:)*W(i)/(SP(i)^3))';
        WGrad = Error*UnitOut(i,:)';
        
        % 更新网络的数据中心、宽度以及权值
        Center(:,i) = Center(:,i)+lrCent*CentGrad;
        SP(i) = SP(i)+lrSP*SPGrad;
        W(i) = W(i)+lrW*WGrad;
        
        % 梯度法训练RBF网络同样不能幸免极易陷入局部极小值的缺陷，所以这里添加动量因子
        Center(:,i) = Center(:,i)+ arf*CenterPre ;
        SP(i) = SP(i)+ arf*SPPre ;
        W(i) = W(i) + arf*WPre ;   
    end
end

% 测试网络的性能如何
TestDistance = dist(Center',TargetIn);
TestSpreadsMat = repmat(SP',1,TargetSamNum);
TestHiddenUnitOut = radbas(TestDistance./TestSpreadsMat);
TestNNOut = W*TestHiddenUnitOut;
% 训练样本进行了归一化，所以需要还原
TestNNOut = postmnmx(TestNNOut,mint,maxt);
TargetIn = postmnmx(TargetIn,minp,maxp);
plot(TargetIn,TestNNOut,'r-');
axis tight;
legend('理论样本','实际样本','测试样本');

figure;
hold on;
grid;
box;
[xx,Num] = size(ErrHistory);
plot(1:Num,ErrHistory,'k-');
xlabel('训练次数');
ylabel('误差大小');
title('训练误差图');
