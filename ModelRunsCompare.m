folder = '3010151927';

for i = 1:5
    runs{i} = strcat(folder,'r',num2str(i));
end

addpath('Stats')
addpath('ICC')

exact_reg = zeros(length(runs),5);
exact_class = zeros(length(runs),5);
near_reg = zeros(length(runs),5);
near_class = zeros(length(runs),5);

for i = 1:length(runs)
    
    [exact_reg(i,:),exact_class(i,:),near_reg(i,:),near_class(i,:)] = ModelResultsRound(1,1,500,runs{i},1,folder);
    
end

save(strcat('MLRun_',folder,'/ModelRunsCompare',folder,'.mat'),...
    'runs','exact_reg','exact_class','near_reg','near_class');
   

%%

exact_reg = exact_reg*100;
exact_class = exact_class*100;
near_reg = near_reg*100;
near_class = near_class*100;

%%
exact_reg_avg = mean(exact_reg);
exact_class_avg = mean(exact_class);
near_reg_avg = mean(near_reg);
near_class_avg = mean(near_class);

exact_reg_std = std(exact_reg);
exact_class_std = std(exact_class);
near_reg_std = std(near_reg);
near_class_std = std(near_class);

gears = {'Depth Perception','Bimanual Dexterity','Efficiency','Force Sensitivity','Robotic Control'};
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %2.1f$\\pm$%2.1f\\%% \t& %2.1f$\\pm$%2.1f\\%% \\\\ \n',gears{i},exact_reg_avg(i),exact_reg_std(i),exact_class_avg(i),exact_class_std(i))
end

fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %2.1f$\\pm$%2.1f\\%% \t& %2.1f$\\pm$%2.1f\\%% \\\\ \n',gears{i},near_reg_avg(i),near_reg_std(i),near_class_avg(i),near_class_std(i))
end



h1=figure('Color',[1,1,1]);
fullscreen = get(0,'ScreenSize');
set(h1,'Position',[0 0 fullscreen(3) fullscreen(4)])
set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);
barweb([exact_reg_avg;exact_class_avg]',[exact_reg_std;exact_class_std]')
figure1 = 'RawFigs/ExactAccuracy';
print(h1,'-depsc',figure1)

h2=figure('Color',[1,1,1]);
fullscreen = get(0,'ScreenSize');
set(h2,'Position',[0 0 fullscreen(3) fullscreen(4)])
set(h2,'PaperOrientation','landscape');
set(h2,'PaperUnits','normalized');
set(h2,'PaperPosition', [0 0 1 1]);
barweb([near_reg_avg;near_class_avg]',[near_reg_std;near_class_std]')
figure2 = 'RawFigs/NearAccuracy';
print(h2,'-depsc',figure2)

%%
IccType = {'A-k','A-1'};
for k = 1:2        
    RegTestAll=[];
    ClassTestAll = [];
    JeremyTestAll = [];
    RegTestInd = cell(1,5);
    ClassTestInd = cell(1,5);
    JeremyTestInd = cell(1,5);

    for i = 1:length(runs)
        RegTestAll = [RegTestAll;csvread(strcat('GearsRegAll',runs{i},'.csv'))];
        ClassTestAll = [ClassTestAll;csvread(strcat('GearsClassAll',runs{i},'.csv'))];
        JeremyTestAll = [JeremyTestAll;csvread(strcat('GearsJeremyAll',runs{i},'.csv'))];
        for j = 1:5
            RegTestInd{j} = [RegTestInd{j};csvread(strcat('GearsReg',num2str(j),runs{i},'.csv'))];
            ClassTestInd{j} = [ClassTestInd{j};csvread(strcat('GearsClass',num2str(j),runs{i},'.csv'))];
            JeremyTestInd{j} = [JeremyTestInd{j};csvread(strcat('GearsJeremy',num2str(j),runs{i},'.csv'))];
        end
    end

    fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner} \t& \\TextWrapCent{Non-Expert}{Rater}\\\\ \\hline\n')

    [rGearsRegAll, ~, ~, ~, ~, ~, ~] = ICC(RegTestAll, IccType{k}, .05, 0);
    [rGearsClassAll, ~, ~, ~, ~, ~, ~] = ICC(ClassTestAll, IccType{k}, .05, 0);
    [rGearsJeremyAll, ~, ~, ~, ~, ~, ~] = ICC(JeremyTestAll, IccType{k}, .05, 0);

    for i = 1:5
        [rGearsRegInd, ~, ~, ~, ~, ~, ~] = ICC(RegTestInd{i}, IccType{k}, .05, 0);
        [rGearsClassInd, ~, ~, ~, ~, ~, ~] = ICC(ClassTestInd{i}, IccType{k}, .05, 0);
        [rGearsJeremyInd, ~, ~, ~, ~, ~, ~] = ICC(JeremyTestInd{i}, IccType{k}, .05, 0);
        fprintf('%s \t& %1.2f \t& %1.2f \t& %1.2f \\\\ \n',gears{i},rGearsRegInd,rGearsClassInd,rGearsJeremyInd)
    end

    fprintf('%s \t& %1.2f \t& %1.2f \t& %1.2f \\\\ \n','Overall',rGearsRegAll,rGearsClassAll,rGearsJeremyAll)
end

%% Calculates the ICC for all five runs and runs descriptive statistics

IccType = {'A-k','A-1'};
rGearsRegAll = [];
rGearsClassAll = [];
rGearsJeremyAll = [];
rGearsRegInd = cell(1,5);
rGearsClassInd = cell(1,5);
rGearsJeremyInd = cell(1,5);
for k = 1:2        
%    

    for i = 1:length(runs)
        RegTestIndSum = [];
        ClassTestIndSum = [];
        JeremyTestIndSum = [];
        RegTestAll = csvread(strcat('GearsRegAll',runs{i},'.csv'));
        ClassTestAll = csvread(strcat('GearsClassAll',runs{i},'.csv'));
        JeremyTestAll = csvread(strcat('GearsJeremyAll',runs{i},'.csv'));
        
%         RegTestAll = [JeremyTestAll,RegTestAll(:,3)];
%         ClassTestAll = [JeremyTestAll,ClassTestAll(:,3)];
        
        [rGearsRegAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(RegTestAll, IccType{k}, .05, 0);
        [rGearsClassAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(ClassTestAll, IccType{k}, .05, 0);
        [rGearsJeremyAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(JeremyTestAll, IccType{k}, .05, 0);
        
        
        for j = 1:5
            RegTestInd = csvread(strcat('GearsReg',num2str(j),runs{i},'.csv'));
            ClassTestInd = csvread(strcat('GearsClass',num2str(j),runs{i},'.csv'));
            JeremyTestInd = csvread(strcat('GearsJeremy',num2str(j),runs{i},'.csv'));
            [rGearsRegInd{j}(i,k), ~, ~, ~, ~, ~, ~] = ICC(RegTestInd, IccType{k}, .05, 0);
            [rGearsClassInd{j}(i,k), ~, ~, ~, ~, ~, ~] = ICC(ClassTestInd, IccType{k}, .05, 0);
            [rGearsJeremyInd{j}(i,k), ~, ~, ~, ~, ~, ~] = ICC(JeremyTestInd, IccType{k}, .05, 0);
            
            RegTestIndSum(:,:,j) = RegTestInd;
            ClassTestIndSum(:,:,j) = ClassTestInd;
            JeremyTestIndSum(:,:,j) = JeremyTestInd;
        end
            [rGearsRegIndSum(i,k), ~, ~, ~, ~, ~, ~] = ICC(sum(RegTestIndSum,3), IccType{k}, .05, 0);
            [rGearsClassIndSum(i,k), ~, ~, ~, ~, ~, ~] = ICC(sum(ClassTestIndSum,3), IccType{k}, .05, 0);
            [rGearsJeremyIndSum(i,k), ~, ~, ~, ~, ~, ~] = ICC(sum(JeremyTestIndSum,3), IccType{k}, .05, 0);
    end
    
    %%%%% Including only Learnerss 
    % Range and Median   
    fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
    for j = 1:5
        fprintf('%s \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \\\\ \n',gears{j},min(rGearsRegInd{j}(:,k)),max(rGearsRegInd{j}(:,k)),median(rGearsRegInd{j}(:,k)),...
            min(rGearsClassInd{j}(:,k)),max(rGearsClassInd{j}(:,k)),median(rGearsClassInd{j}(:,k)))
    end
    fprintf('%s \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \\\\ \n','Overall',min(rGearsRegAll(:,k)),max(rGearsRegAll(:,k)),median(rGearsRegAll(:,k)),...
        min(rGearsClassAll(:,k)),max(rGearsClassAll(:,k)),median(rGearsClassAll(:,k)))
    fprintf('%s \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \\\\ \n','Overall',min(rGearsRegIndSum(:,k)),max(rGearsRegIndSum(:,k)),median(rGearsRegIndSum(:,k)),...
        min(rGearsClassIndSum(:,k)),max(rGearsClassIndSum(:,k)),median(rGearsClassIndSum(:,k)))
    
    % Mean and Std
    fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
    for j = 1:5
        fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',gears{j},mean(rGearsRegInd{j}(:,k)),std(rGearsRegInd{j}(:,k)),...
            mean(rGearsClassInd{j}(:,k)),std(rGearsClassInd{j}(:,k)))
    end
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n','Overall',mean(rGearsRegAll(:,k)),std(rGearsRegAll(:,k)),...
        mean(rGearsClassAll(:,k)),std(rGearsClassAll(:,k)))
    
    
    %%%% Including (Non-Expert) Rater
    % Range and Median
    fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner} \t& \\TextWrapCent{Non-Expert}{Rater}\\\\ \\hline\n')
    for j = 1:5
        fprintf('%s \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \\\\ \n',gears{j},min(rGearsRegInd{j}(:,k)),max(rGearsRegInd{j}(:,k)),median(rGearsRegInd{j}(:,k)),...
            min(rGearsClassInd{j}(:,k)),max(rGearsClassInd{j}(:,k)),median(rGearsClassInd{j}(:,k)),...
            min(rGearsJeremyInd{j}(:,k)),max(rGearsJeremyInd{j}(:,k)),median(rGearsJeremyInd{j}(:,k)))
    end
    fprintf('%s \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \t& %1.2f-%1.2f (%1.2f) \\\\ \n','Overall',min(rGearsRegAll(:,k)),max(rGearsRegAll(:,k)),median(rGearsRegAll(:,k)),...
        min(rGearsClassAll(:,k)),max(rGearsClassAll(:,k)),median(rGearsClassAll(:,k)),...
        min(rGearsJeremyAll(:,k)),max(rGearsJeremyAll(:,k)),median(rGearsJeremyAll(:,k)))
    
    % Mean and Std
    fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner} \t& \\TextWrapCent{Non-Expert}{Rater}\\\\ \\hline\n')
    for j = 1:5
        fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',gears{j},mean(rGearsRegInd{j}(:,k)),std(rGearsRegInd{j}(:,k)),...
            mean(rGearsClassInd{j}(:,k)),std(rGearsClassInd{j}(:,k)),mean(rGearsJeremyInd{j}(:,k)),std(rGearsJeremyInd{j}(:,k)))
    end
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n','Overall',mean(rGearsRegAll(:,k)),std(rGearsRegAll(:,k)),...
        mean(rGearsClassAll(:,k)),std(rGearsClassAll(:,k)),mean(rGearsJeremyAll(:,k)),std(rGearsJeremyAll(:,k)))
    
    
    
end

