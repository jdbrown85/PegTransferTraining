clear all; close all; clc;

leaf = [25,25,15,25,15];
totResults = [];
nTrees = [100,500,1000]; 

tic
for j = 1:3
    for i = 1:5
        [b,c,results,maxIndex,postProb] = randomForestTrain(1,i,leaf(i),nTrees(j));
%         TotResults(i) = results{i};
%         results = [];
        toc
    end
    toc
end
toc