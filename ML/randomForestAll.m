function randomForestAll(rounding,TrainTest,folder,nRuns)
close all; clc;
clearvars -except rounding TrainTest folder nRuns
leaf = [25,25,15,25,15];
% totResults = [];
% nTrees = [100,500,1000]; 
nTrees = 500;
% rounding = 1;
% TrainTest = 1;
for i = 1:nRuns
%     if i == 1
%         time = folder;
%     else
%         time = datestr(now, 'ddmmyyHHMM');
%     end
    time = strcat(folder,'r',num2str(i));
    tic
    for j = 1:length(nTrees)
        for k = 1:5
            [b,c,results,maxIndex,postProb] = randomForestTrainRound(rounding,TrainTest,k,leaf(k),nTrees(j),time,folder);
    %         [b,c,results,maxIndex,postProb] = randomForestTrain(rounding,TrainTest,i,leaf(i),nTrees(j),time);
    %         TotResults(i) = results{i};
    %         results = [];
            toc
        end
        toc
    end
    toc

    ensembleTestSelectFeaturesRoundCVPart(rounding,TrainTest,1,time,folder)
    % ensembleTestSelectFeaturesCVPart(rounding,TrainTest,1,time)
end