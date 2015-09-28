function randomForestAll(rounding,TrainTest)
close all; clc;
clearvars -except rounding TrainTest
leaf = [25,25,15,25,15];
totResults = [];
% nTrees = [100,500,1000]; 
nTrees = 500;
% rounding = 1;
% TrainTest = 1;

tic
time = datestr(now, 'ddmmyyHHMM');
for j = 1:length(nTrees)
    for i = 1:5
        [b,c,results,maxIndex,postProb] = randomForestTrain(rounding,TrainTest,i,leaf(i),nTrees(j),time);
%         TotResults(i) = results{i};
%         results = [];
        toc
    end
    toc
end
toc

ensembleTestSelectFeaturesCVPart(rounding,TrainTest,1,time)