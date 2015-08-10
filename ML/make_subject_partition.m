function [subTest,subTestInd,subTrain,subTrainInd] =  make_subject_partition(n)

if ~exist('subjectFam.mat','file')
    data = STBData('SavedData', 'task', 1);
    data = data(~cellfun(@(x)any(isnan(x(:))), {data.score}));
    
    for i = 1:length(data)
        subRaw(i,:) = (data(i).subj_id)-2;
    end
    subAct = unique(subRaw);    
    num = xlsread('DemographicSurvey.xls');
    subjectFam = [num(1:end, 5)-2,num(1:end, 11)];
    subjectFam = sortrows(subjectFam,1);
    subjectFam = subjectFam(subAct,:);
    save('subjectFam.mat','subjectFam','subRaw');
else
    load subjectFam.mat
end

subExcl = randperm(length(subjectFam),n);
while size(subExcl,2)<n
    subExcl = randperm(length(subjectFam),n);
end
subTest = subjectFam(ismember(subjectFam(:,1),subExcl),:);
subTestInd = ismember(subRaw,subExcl);
subTrain = subjectFam(~ismember(subjectFam(:,1),subExcl),:);
subTrainInd = ~ismember(subRaw,subExcl);
end

