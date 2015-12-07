clear all; close all; clc;

run = '3010151927';

load(strcat('featuresMean',run,'.mat'))
load(strcat('SelectFeaturesMean',run,'.mat'));

[feature_vector, ratings, index] = featureVector(features);

gears = {'Depth Perception','Bimanual Dexterity','Efficiency','Force Sensitivity','Robotic Control'};

index = FeatNameCorrect(index);

%%
fprintf('Regression Learner\n')
for i=1:5
    feats = sort(index(selectFeatures{i}))';
    fprintf('\t\\item %s \n',gears{i})
    fprintf('\t\t\\begin{enumerate}\n')
    for j=1:length(feats)
        fprintf('\t\t \\item %s \n',feats{j})
    end
    fprintf('\t\t\\end{enumerate}\n')
    
end
fprintf('\n')
%%
load(strcat('randForest500TreesRoundSubPart',run,'r1.mat'))

fprintf('Classification Learner\n')
for i=1:5
    feats = models{i}.VarNames';
    feats = sort(FeatNameCorrect(feats));
    fprintf('\t\\item %s \n',gears{i})
    fprintf('\t\t\\begin{enumerate}\n')
    for j=1:length(feats)
        fprintf('\t\t \\item %s \n',feats{j})
    end
    fprintf('\t\t\\end{enumerate}\n')
end