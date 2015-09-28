clear all; close all; clc;

load Features
load SelectFeatures
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
load randForestLearner500Trees

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