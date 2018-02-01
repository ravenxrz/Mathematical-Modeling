function [ classfication ] = SVM2_2( train,test )
%使用matlab自带的关于花的数据进行二分类实验（150*4），其中，每一行代表一朵花，
%共有150行（朵)，每一朵包含4个属性值（特征），即4列。且每1-50，51-100，101-150行的数据为同一类，分别为setosa青风藤类，versicolor云芝类，virginica锦葵类
%实验中为了使用svmtrain（只处理二分类问题）因此，将数据分为两类，51-100为一类，1-50和101-150共为一类
%实验先选用2个特征值，再选用全部四个特征值来进行训练模型，最后比较特征数不同的情况下分类精度的情况。

load fisheriris                       %下载数据包含：meas（150*4花特征数据）
                                      %和species（150*1 花的类属性数据）
meas=meas(:,1:4);                   %选取出数据前100行，前2列
train=[(meas(51:90,:));(meas(101:140,:))]; %选取数据中每类对应的前40个作为训练数据
test=[(meas(91:100,:));(meas(141:150,:))];%选取数据中每类对应的后10个作为测试数据
group=[(species(51:90));(species(101:140))];%选取类别标识前40个数据作为训练数据

%使用训练数据，进行SVM模型训练
svmModel = svmtrain(train,group,'kernel_function','rbf','showplot',true);
%使用测试数据，测试分类效果
classfication = svmclassify(svmModel,test,'showplot',true);

%正确的分类情况为groupTest，实验测试获得的分类情况为classfication
groupTest=[(species(91:100));(species(141:150))]; 
%计算分类精度
count=0;
for i=(1:20)
   if strcmp(classfication(i),groupTest(i))
      count=count+1;
   end
end
fprintf('分类精度为：%f\n' ,count/20);

end