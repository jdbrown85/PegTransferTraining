%%%%% This function compares the prediction results from the 5 training/test
%%%%% splits for both the regression and classification learners

% folder = '3010151927';

function ModelRunsCompare(folder,omit,saving)

for i = 1:5
    runs{i} = strcat(folder,'r',num2str(i));
end

addpath('Stats')
addpath('ICC')

%%

if omit == 0 % no features removed
    filename = strcat('MLRun_',folder,'/ModelRunsCompare',folder,'.mat');
    fileomit = '';
elseif omit == 1 % PCA features removed
    filename = strcat('MLRunNoPCA_',folder,'/ModelRunsNoPCACompare',folder,'.mat');
    fileomit = 'NoPCA';
elseif omit == 2 % force features removed
    filename = strcat('MLRunNoForce_',folder,'/ModelRunsNoForceCompare',folder,'.mat');
    fileomit = 'NoForce';
elseif omit == 3 % PCA and force features removed
    filename = strcat('MLRunNoForcePCA_',folder,'/ModelRunsNoForcePCACompare',folder,'.mat');
    fileomit = 'NoForcePCA';
end


%%

exact_reg = zeros(length(runs),5); % initialize regression exact accuracy vector 
exact_class = zeros(length(runs),5); % initialize classification exact accuracy vector
near_reg = zeros(length(runs),5); % initialize regression within 1 accuracy vector
near_class = zeros(length(runs),5); % initialize classificiation within 1 accuracy vector
prec_reg = zeros(5,5,length(runs)); % initialize regression precision vector
prec_class = zeros(5,5,length(runs)); % initialize classification precision vector
rec_reg = zeros(5,5,length(runs)); % initialize regression recall vector
rec_class = zeros(5,5,length(runs)); % initialize classification recall vector
f1_reg = zeros(5,5,length(runs)); % initialize regression F1 vector
f1_class = zeros(5,5,length(runs)); % initialize classification F1 vector
pe_reg = zeros(5,5,length(runs)); % initialize regression PE (TP+FN) vector 
pe_class = zeros(5,5,length(runs)); % initialize classification PE (TP+FN) vector


%%

if saving
    for i = 1:length(runs)   
        [exact_reg(i,:),exact_class(i,:),near_reg(i,:),near_class(i,:),...
        prec_reg(:,:,i),prec_class(:,:,i),rec_reg(:,:,i),rec_class(:,:,i),...
        f1_reg(:,:,i),f1_class(:,:,i),pe_reg(:,:,i),pe_class(:,:,i)] = ModelResultsRound(1,1,500,runs{i},1,folder,omit);    
    end
    
    save(filename,'runs','exact_reg','exact_class','near_reg','near_class',...
        'prec_reg','prec_class','rec_reg','rec_class','f1_reg','f1_class','pe_reg','pe_class');
else
    load(filename)
end
   

%%
exact_reg = exact_reg*100;
exact_class = exact_class*100;
near_reg = near_reg*100;
near_class = near_class*100;
% prec_reg = prec_reg*100;
% prec_clas = prec_class*100;
% rec_reg = rec_reg*100;
% rec_class = rec_class*100;
%%
exact_reg_avg = mean(exact_reg);
exact_class_avg = mean(exact_class);
near_reg_avg = mean(near_reg);
near_class_avg = mean(near_class);

exact_reg_std = std(exact_reg);
exact_class_std = std(exact_class);
near_reg_std = std(near_reg);
near_class_std = std(near_class);

prec_reg_avg = nanmean(prec_reg,3);
prec_class_avg = nanmean(prec_class,3);
rec_reg_avg = nanmean(rec_reg,3);
rec_class_avg = nanmean(rec_class,3);
f1_reg_avg = nanmean(f1_reg,3);
f1_class_avg = nanmean(f1_class,3);
pe_reg_avg = nanmean(pe_reg,3);
pe_class_avg = nanmean(pe_class,3);

prec_reg_std = nanstd(prec_reg,0,3);
prec_class_std = nanstd(prec_class,0,3);
rec_reg_std = nanstd(rec_reg,0,3);
rec_class_std = nanstd(rec_class,0,3);
f1_reg_std = nanstd(f1_reg,0,3);
f1_class_std = nanstd(f1_class,0,3);
pe_reg_std = nanstd(pe_reg,0,3);
pe_class_std = nanstd(pe_class,0,3);

prec_reg_avgavg = nanmean(prec_reg_avg,1);
prec_class_avgavg = nanmean(prec_class_avg,1);
rec_reg_avgavg = nanmean(rec_reg_avg,1);
rec_class_avgavg = nanmean(rec_class_avg,1);
f1_reg_avgavg = nanmean(f1_reg_avg,1);
f1_class_avgavg = nanmean(f1_class_avg,1);

prec_reg_stdstd = nanstd(prec_reg_std,0,1);
prec_class_stdstd = nanstd(prec_class_std,0,1);
rec_reg_stdstd = nanstd(rec_reg_std,0,1);
rec_class_stdstd = nanstd(rec_class_std,0,1);
f1_reg_stdstd = nanstd(f1_reg_std,0,1);
f1_class_stdstd = nanstd(f1_class_std,0,1);



%%
%%%%% Print exact accuary in Latex table format
gears = {'Depth Perception','Bimanual Dexterity','Efficiency','Force Sensitivity','Robotic Control'};
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %2.1f$\\pm$%2.1f\\%% \t& %2.1f$\\pm$%2.1f\\%% \\\\ \n',gears{i},exact_reg_avg(i),exact_reg_std(i),exact_class_avg(i),exact_class_std(i))
end

%%%%% Print accuracy within one in Latex table format
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& \\TextWrapCent{Regression}{Learner} \t& \\TextWrapCent{Classification}{Learner}\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %2.1f$\\pm$%2.1f\\%% \t& %2.1f$\\pm$%2.1f\\%% \\\\ \n',gears{i},near_reg_avg(i),near_reg_std(i),near_class_avg(i),near_class_std(i))
end

%%%%% Print Precision Recall F1 in Latex table format for Regression &
%%%%% Classification
fprintf('\n\\multicolumn{4}{c}{Regression}\\\\ \\hline')
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& Precision \t& Recall \t& $F_1$\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',...
        gears{i},prec_reg_avgavg(i),prec_reg_stdstd(i),rec_reg_avgavg(i),rec_reg_stdstd(i),f1_reg_avgavg(i),f1_reg_stdstd(i))
end
fprintf('\\hline')
fprintf('\n\\multicolumn{4}{c}{Classification}\\\\ \\hline')
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& Precision \t& Recall \t& $F_1$\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',...
        gears{i},prec_class_avgavg(i),prec_class_stdstd(i),rec_class_avgavg(i),rec_class_stdstd(i),f1_class_avgavg(i),f1_class_stdstd(i))
end

%%%%% Print F1 Latex table format for Regression and Classification for all
%%%%% GEARS scores
fprintf('\n\\multicolumn{6}{c}{Regression}\\\\ \\hline')
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& Rating=1 \t& Rating=2 \t& Rating=3 \t& Rating=4 \t& Rating=5\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',...
        gears{i},f1_reg_avg(1,i),f1_reg_std(1,i),f1_reg_avg(2,i),f1_reg_std(2,i),f1_reg_avg(3,i),...
                 f1_reg_std(3,i),f1_reg_avg(4,i),f1_reg_std(4,i),f1_reg_avg(5,i),f1_reg_std(5,i))
end
fprintf('\\hline')
fprintf('\n\\multicolumn{6}{c}{Classification}\\\\ \\hline')
fprintf('\n\\TextWrapCent{GEARS}{Domain} \t& Rating=1 \t& Rating=2 \t& Rating=3 \t& Rating=4 \t& Rating=5\\\\ \\hline\n')
for i = 1:5
    fprintf('%s \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \t& %1.2f$\\pm$%1.2f \\\\ \n',...
        gears{i},f1_class_avg(1,i),f1_class_std(1,i),f1_class_avg(2,i),f1_class_std(2,i),f1_class_avg(3,i),...
                 f1_class_std(3,i),f1_class_avg(4,i),f1_class_std(4,i),f1_class_avg(5,i),f1_class_std(5,i))
end

%%
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
        RegTestAll = [RegTestAll;csvread(strcat('GearsRegAll',fileomit,runs{i},'.csv'))];
        ClassTestAll = [ClassTestAll;csvread(strcat('GearsClassAll',fileomit,runs{i},'.csv'))];
        JeremyTestAll = [JeremyTestAll;csvread(strcat('GearsJeremyAll',fileomit,runs{i},'.csv'))];
        for j = 1:5
            RegTestInd{j} = [RegTestInd{j};csvread(strcat('GearsReg',fileomit,num2str(j),runs{i},'.csv'))];
            ClassTestInd{j} = [ClassTestInd{j};csvread(strcat('GearsClass',fileomit,num2str(j),runs{i},'.csv'))];
            JeremyTestInd{j} = [JeremyTestInd{j};csvread(strcat('GearsJeremy',fileomit,num2str(j),runs{i},'.csv'))];
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
for k = 1:1        
%    

    for i = 1:length(runs)
        RegTestIndSum = [];
        ClassTestIndSum = [];
        JeremyTestIndSum = [];
        RegTestAll = csvread(strcat('GearsRegAll',fileomit,runs{i},'.csv'));
        ClassTestAll = csvread(strcat('GearsClassAll',fileomit,runs{i},'.csv'));
        JeremyTestAll = csvread(strcat('GearsJeremyAll',fileomit,runs{i},'.csv'));
        
%         RegTestAll = [JeremyTestAll,RegTestAll(:,3)];
%         ClassTestAll = [JeremyTestAll,ClassTestAll(:,3)];
        
        [rGearsRegAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(RegTestAll, IccType{k}, .05, 0);
        [rGearsClassAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(ClassTestAll, IccType{k}, .05, 0);
        [rGearsJeremyAll(i,k), ~, ~, ~, ~, ~, ~] = ICC(JeremyTestAll, IccType{k}, .05, 0);
        
        
        for j = 1:5
            RegTestInd = csvread(strcat('GearsReg',fileomit,num2str(j),runs{i},'.csv'));
            ClassTestInd = csvread(strcat('GearsClass',fileomit,num2str(j),runs{i},'.csv'));
            JeremyTestInd = csvread(strcat('GearsJeremy',fileomit,num2str(j),runs{i},'.csv'));
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

disp(pe_reg_avg')
disp(pe_class_avg')


end

