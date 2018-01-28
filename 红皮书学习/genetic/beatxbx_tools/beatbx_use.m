clc;clear;
tic;
% step1 初始化
% 个体数量
NIND = 35;
% 最大遗传代数
MAXGEN = 180;
% 变量的维数
NVAR = 2;
% 变量的二进制位数
% 上下界
bounds=[
    -10 10
    -10 10
    ];
precision=0.0001; %运算精度
PRECI=ceil(log2((bounds(:,2)-bounds(:,1)) ./ precision));
 %交配概率
PC =0.90;
% 代沟
% 代沟的大小决定父代复制到子代的程度
GGAP = 1;
% 追踪
trace = zeros(MAXGEN,1);

% step2 构建区域描述器
FieldD = [
    PRECI'
    bounds'
    rep([1;0;1;1],[1,NVAR])
    ];

%step3 规划种群
Chrom = crtbp(NIND,sum(PRECI));
% 代计数器
gen = 0;
% 把二进制子串变成十进制
obj_x = bs2rv(Chrom,FieldD);
% 计算出事种群个体的目标函数值，这里是三个变量
obj_fitness = fitness(obj_x(:,1),obj_x(:,2));
% 最优种群
BestChrom = Chrom;
% 最优解
BestFval = obj_fitness(1);  % 记录最优值
BestFitness = obj_fitness; %记录最优值对应的种群的所有指

%step4 进化计算
while gen < MAXGEN
    % 种群复制，首先按照适应度进行排序（但实际上不是排序），返回的值保证一定为证
    FitnV = ranking(obj_fitness);
    % 选择操作
    SubChrom = select('sus',Chrom,FitnV,GGAP);
    % 交叉操作
    SubChrom = recombin('xovsp',SubChrom,PC);
    % 基因突变
    SubChrom = mut(SubChrom);
    % 二进制转化
    sub_obj_x = bs2rv(SubChrom,FieldD);
    % 计算子代目标函数值
    sub_ovj_fitness = fitness(sub_obj_x(:,1),sub_obj_x(:,2));
    % 重新插入到种群，这一代的子代变成下一代的父代
    [Chrom,obj_fitness] = reins(Chrom,SubChrom,1,1,obj_fitness,sub_ovj_fitness);
    gen = gen+1;
    % 性能跟踪
    min_value = min(obj_fitness);
    if BestFval > min_value
        BestFval = min_value;
        BestFitness = obj_fitness;
        BestChrom = Chrom;
    elseif BestFval == min_value
        BestFitness = [BestFitness;obj_fitness];
        BestChrom = [BestChrom;Chrom];
    end
    trace(gen) = min_value;
    trace(gen,2) = sum(obj_fitness)/length(obj_fitness);
end

% 绘图
 plot(trace(:,1));hold on;
 plot(trace(:,2),'-.');grid;
 xlabel('进化代数');
 ylabel('y');
 legend('解的变化','种群均值变化');
% 输出
[~,I]  = min(BestFitness);
obj_x = bs2rv(BestChrom,FieldD);
disp('对应x');
obj_x(I,:)
%fval
disp('最优值:');
BestFval
toc;
