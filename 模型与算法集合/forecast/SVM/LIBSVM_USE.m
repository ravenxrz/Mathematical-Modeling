% This code just simply run the SVM on the example data set "heart_scale",
% which is scaled properly. The code divides the data into 2 parts
% train: 1 to 200
% test: 201:270
% Then plot the results vs their true class. In order to visualize the high
% dimensional data, we apply MDS to the 13D data and reduce the dimension
% to 2D

clear
clc
close all

% read the data set
[heart_scale_label, heart_scale_inst] = libsvmread('heart_scale');
[N,D] = size(heart_scale_inst);

% Determine the train and test index
trainIndex = zeros(N,1); trainIndex(1:200) = 1;
testIndex = zeros(N,1); testIndex(201:N) = 1;
trainData = heart_scale_inst(trainIndex==1,:);
trainLabel = heart_scale_label(trainIndex==1,:);
testData = heart_scale_inst(testIndex==1,:);
testLabel = heart_scale_label(testIndex==1,:);

% Train the SVM
model = svmtrain(trainLabel, trainData, '-c 1 -g 0.07 -b 1');
% Use the SVM model to classify the data
[predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 1'); % run the SVM model on the test data



% ================================
% ===== Showing the results ======
% ================================

% Assign color for each class
% colorList = generateColorList(2); % This is my own way to assign the color...don't worry about it
colorList = prism(100);

% true (ground truth) class
trueClassIndex = zeros(N,1);
trueClassIndex(heart_scale_label==1) = 1; 
trueClassIndex(heart_scale_label==-1) = 2;
colorTrueClass = colorList(trueClassIndex,:);
% result Class
resultClassIndex = zeros(length(predict_label),1);
resultClassIndex(predict_label==1) = 1; 
resultClassIndex(predict_label==-1) = 2;
colorResultClass = colorList(resultClassIndex,:);

% Reduce the dimension from 13D to 2D
distanceMatrix = pdist(heart_scale_inst,'euclidean');
newCoor = mdscale(distanceMatrix,2);

% Plot the whole data set
x = newCoor(:,1);
y = newCoor(:,2);
patchSize = 30; %max(prob_values,[],2);
colorTrueClassPlot = colorTrueClass;
figure; scatter(x,y,patchSize,colorTrueClassPlot,'filled');
title('whole data set');

% Plot the test data
x = newCoor(testIndex==1,1);
y = newCoor(testIndex==1,2);
patchSize = 80*max(prob_values,[],2);
colorTrueClassPlot = colorTrueClass(testIndex==1,:);
figure; hold on;
scatter(x,y,2*patchSize,colorTrueClassPlot,'o','filled'); 
scatter(x,y,patchSize,colorResultClass,'o','filled');
% Plot the training set
x = newCoor(trainIndex==1,1);
y = newCoor(trainIndex==1,2);
patchSize = 30;
colorTrueClassPlot = colorTrueClass(trainIndex==1,:);
scatter(x,y,patchSize,colorTrueClassPlot,'o');
title('classification results');