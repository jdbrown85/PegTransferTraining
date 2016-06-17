%%%%% Performs the training and testing for both the regression and
%%%%% classification models 

%%%%% This version omits some features

function randomForestAllOF(rounding,TrainTest,folder,nRuns,omit)
close all; clc;
clearvars -except rounding TrainTest folder nRuns omit
leaf = [25,25,15,25,15];
nTrees = 500;
for i = 1:nRuns

    time = strcat(folder,'r',num2str(i));
    tic
    for j = 1:length(nTrees)
        for k = 1:5
            [b,c,results,maxIndex,postProb] = randomForestTrainRoundOF(rounding,TrainTest,k,leaf(k),nTrees(j),time,folder,omit);
        end
        toc
    end
    toc

    ensembleTestSelectFeaturesRoundCVPartOF(rounding,TrainTest,1,time,folder,omit)
end