
%SVM对线性不可分的数据进行处理
%在选择核函数时，尝试用linear以外的rbf,quadratic,polynomial等，观察获得的分类情况
%训练数据
train=[5 5;6 4;5 6;5 4;4 5;8 5;8 8;4 5;5 7;7 8;1 2;1 4;4 2;5 1.5;7 3;10 4;4 9;2 8;8 9;8 10];
%训练数据分类情况
group=[1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2];
%测试数据
test=[6 6;5.5 5.5;7 6;12 14;7 11;2 2;9 9;8 2;2 6;5 10;4 7;7 4];

%训练分类模型
svmModel = svmtrain(train,group,'kernel_function','rbf','showplot',true);
%分类
classification=svmclassify(svmModel,test,'Showplot',true);
