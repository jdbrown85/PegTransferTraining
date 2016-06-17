% clear all; close all; clc;

function SelectFeaturePrint(folder,omit)

% folder = '3010151927';

if omit == 0 % no features removed
    filename = strcat('MLRun_',folder);
    fileomit = '';
elseif omit == 1 % PCA features removed
    filename = strcat('MLRunNoPCA_',folder);
    fileomit = 'NoPCA';
elseif omit == 2 % force features removed
    filename = strcat('MLRunNoForce_',folder);
    fileomit = 'NoForce';
elseif omit == 3 % PCA and force features removed
    filename = strcat('MLRunNoForcePCA_',folder);
    fileomit = 'NoForcePCA';
end

addpath(filename)


load(strcat('featuresMean',fileomit,folder,'.mat'))
load(strcat('SelectFeaturesMean',fileomit,folder,'.mat'));

[feature_vector, ratings, index] = featureVector(features);

gears = {'Depth Perception','Bimanual Dexterity','Efficiency','Force Sensitivity','Robotic Control'};

index = FeatNameCorrect(index);

%% Find the indices of the major feature groups by their names

TimeFeatsInd = find(not(cellfun('isempty', strfind(index,'Time'))));
ProdFeatsInd = find(not(cellfun('isempty', strfind(index,'Product'))));
PCFeatsInd = find(not(cellfun('isempty', strfind(index,'Principle'))));
ForceFeatsInd = find(not(cellfun('isempty', strfind(index,'Force'))));
ForceFeatsInd(ismember(ForceFeatsInd,ProdFeatsInd))=[];
AngleFeatsInd = find(not(cellfun('isempty', strfind(index,'Angle'))));
AngleFeatsInd(ismember(AngleFeatsInd,ProdFeatsInd))=[];
RateFeatsInd = find(not(cellfun('isempty', strfind(index,'Rate'))));
RateFeatsInd(ismember(RateFeatsInd,ProdFeatsInd))=[];
AccelFeatsInd = find(not(cellfun('isempty', strfind(index,'Vibration'))));
AccelFeatsInd(ismember(AccelFeatsInd,ProdFeatsInd))=[];


for i=1:5
    feats = sort(selectFeatures{i})';
    TimeFeatsBinR(i) = sum(ismember(feats,TimeFeatsInd));
    ProdFeatsBinR(i) = sum(ismember(feats,ProdFeatsInd));
    PCFeatsBinR(i) = sum(ismember(feats,PCFeatsInd));
    ForceFeatsBinR(i) = sum(ismember(feats,ForceFeatsInd));
    AngleFeatsBinR(i) = sum(ismember(feats,AngleFeatsInd));
    RateFeatsBinR(i) = sum(ismember(feats,RateFeatsInd));
    AccelFeatsBinR(i) = sum(ismember(feats,AccelFeatsInd));
end

HeatMapMatrixR = [TimeFeatsBinR;ForceFeatsBinR;AccelFeatsBinR;AngleFeatsBinR;RateFeatsBinR;ProdFeatsBinR]

norm = [size(selectFeatures{1},2),size(selectFeatures{2},2),size(selectFeatures{3},2),size(selectFeatures{4},2),size(selectFeatures{5},2)];

HeatMapMatrixRNorm = bsxfun(@rdivide,HeatMapMatrixR,norm)*100

f1 = CreateFig;
colormap(gray)
ax1 = axes('Parent',f1);
imagesc([1 5],[1 6],HeatMapMatrixRNorm,'Parent',ax1);
set(ax1,'XTick',[1 2 3 4 5],'YTick',[1 2 3 4 5 6],'XTickLabel',{'Depth Perception','Bimanual Dexterity',...
'Efficiency','Force Sensitivity','Robotic Control'},'YTickLabel',{'Time','Force','Acceleration','Orientation',...
'Velocity','Product'},'XTickLabelRotation',45,'YDir','reverse')
colorbar
PrintFig(f1,'RawFigs/ImportantFeatsReg','eps')
%% Count the number of features in each major feature group by their names
for i=1:5
    load(strcat('randForest500TreesRoundSubPart',fileomit,folder,'r',num2str(i),'.mat'))
    
    for j=1:5
        feats = models{j}.VarNames';
        feats = sort(FeatNameCorrect(feats));
        TimeFeatsInd = find(not(cellfun('isempty', strfind(feats,'Time'))));
        TimeFeatsBinC(i,j) = length(TimeFeatsInd);
        ProdFeatsInd = find(not(cellfun('isempty', strfind(feats,'Product'))));
        ProdFeatsBinC(i,j) = length(ProdFeatsInd);
        PCFeatsInd = find(not(cellfun('isempty', strfind(feats,'Principle'))));
        PCFeatsBinC(i,j) = length(PCFeatsInd);
        ForceFeatsInd = find(not(cellfun('isempty', strfind(feats,'Force'))));
        ForceFeatsInd(ismember(ForceFeatsInd,ProdFeatsInd))=[];
        ForceFeatsBinC(i,j) = length(ForceFeatsInd);
        AngleFeatsInd = find(not(cellfun('isempty', strfind(feats,'Angle'))));
        AngleFeatsInd(ismember(AngleFeatsInd,ProdFeatsInd))=[];
        AngleFeatsBinC(i,j) = length(AngleFeatsInd);
        RateFeatsInd = find(not(cellfun('isempty', strfind(feats,'Rate'))));
        RateFeatsInd(ismember(RateFeatsInd,ProdFeatsInd))=[];
        RateFeatsBinC(i,j) = length(RateFeatsInd);
        AccelFeatsInd = find(not(cellfun('isempty', strfind(feats,'Vibration'))));
        AccelFeatsInd(ismember(AccelFeatsInd,ProdFeatsInd))=[];
        AccelFeatsBinC(i,j) = length(AccelFeatsInd);
        
    end
end
    
HeatMapMatrixC = [mean(TimeFeatsBinC);mean(ForceFeatsBinC);mean(AccelFeatsBinC);mean(AngleFeatsBinC);mean(RateFeatsBinC);mean(ProdFeatsBinC)]

norm = [30 30 30 30 30];

HeatMapMatrixCNorm = bsxfun(@rdivide,HeatMapMatrixC,norm)*100

f2 = CreateFig;
colormap(gray)
ax2 = axes('Parent',f2);
imagesc([1 5],[1 6],HeatMapMatrixCNorm,'Parent',ax2)
set(ax2,'XTick',[1 2 3 4 5],'YTick',[1 2 3 4 5 6],'XTickLabel',{'Depth Perception','Bimanual Dexterity',...
'Efficiency','Force Sensitivity','Robotic Control'},'YTickLabel',{'Time','Force','Acceleration','Orientation',...
'Velocity','Product'},'XTickLabelRotation',45,'YDir','reverse')
colorbar
PrintFig(f2,'RawFigs/ImportantFeatsClass','eps')

end
%% Print important regression features in LaTex format for a table 
% fprintf('Regression Learner\n')
% for i=1:5
%     feats = sort(index(selectFeatures{i}))';
%     fprintf('\t\\item %s \n',gears{i})
%     fprintf('\t\t\\begin{enumerate}\n')
%     for j=1:length(feats)
%         fprintf('\t\t \\item %s \n',feats{j})
%     end
%     fprintf('\t\t\\end{enumerate}\n')
%     
% end
% fprintf('\n')
%% Print important classification features in LaTex format for a table 
% load(strcat('randForest500TreesRoundSubPart',run,'r1.mat'))
% 
% fprintf('Classification Learner\n')
% for i=1:5
%     feats = models{i}.VarNames';
%     feats = sort(FeatNameCorrect(feats));
%     fprintf('\t\\item %s \n',gears{i})
%     fprintf('\t\t\\begin{enumerate}\n')
%     for j=1:length(feats)
%         fprintf('\t\t \\item %s \n',feats{j})
%     end
%     fprintf('\t\t\\end{enumerate}\n')
% end