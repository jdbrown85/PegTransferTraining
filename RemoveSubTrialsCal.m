function [Index,Subject] = RemoveSubTrialsCal(data,task,nCal)
%%%%% This function is used to select the trials that will be used for the
%%%%% calibration survery. Multiple calibration sets can be created using
%%%%% the variable nCal. The output Index contains the index of the trials
%%%%% in data, and Subject contains the subjects that have been selected
%%%%% (note each subject performed multiple trials of the given task)

Index = cell(1,nCal);
Subject = cell(1,nCal);

load subjectFam.mat % load subjectFam which contains the familiarity of each subject
subjectFam(:,1) = subjectFam(:,1)+2; % adjust the subject ID count to be consistent with data

for cal = 1:nCal;
    sub = [];  
   
    % find two subjects with a familiartiy of 1
    samp = subjectFam(subjectFam(:,2)==1,:); 
    sub = [sub;samp(randperm(length(samp),2),1)];

    % find three subjects with a familiarity of 2
    samp = subjectFam(subjectFam(:,2)==2,:); 
    sub = [sub;samp(randperm(length(samp),3),1)];

    % find three subjects with a familiarity of 3
    samp = subjectFam(subjectFam(:,2)==3,:); 
    sub = [sub;samp(randperm(length(samp),3),1)];

    % find two subjects with a familiarity of 4 
    samp = subjectFam(subjectFam(:,2)==4,:); 
    sub = [sub;samp(randperm(length(samp),2),1)];

    
    ind = false(length(data),1); % create logical array to store indices
    
    % Randomly select a trial from each subject in sub and store index in
    % ind
    for i = 1:length(sub)
        test = STBData('SavedData', 'task', task, 'subject', sub(i));
        trial = randi([1,3]);
        test = test(trial);
        for j = 1:length(data)
            if strcmp(test.filename,data(j).filename);
                ind(j) = true;
            end
        end
    end
    Index{cal} = ind;
    Subject{cal} = sub;
end

% Repeat process if the two calibrations have duplicate trials
while any((Index{1}+Index{2})==2)
    sub = [];  
   
    % find two subjects with a familiartiy of 1
    samp = subjectFam(subjectFam(:,2)==1,:); 
    sub = [sub;samp(randperm(length(samp),2),1)];

    % find three subjects with a familiarity of 2
    samp = subjectFam(subjectFam(:,2)==2,:); 
    sub = [sub;samp(randperm(length(samp),3),1)];

    % find three subjects with a familiarity of 3
    samp = subjectFam(subjectFam(:,2)==3,:); 
    sub = [sub;samp(randperm(length(samp),3),1)];

    % find two subjects with a familiarity of 4 
    samp = subjectFam(subjectFam(:,2)==4,:); 
    sub = [sub;samp(randperm(length(samp),2),1)];

    
    ind = false(length(data),1); % create logical array to store indices
    
    % Randomly select a trial from each subject in sub and store index in
    % ind
    for i = 1:length(sub)
        test = STBData('SavedData', 'task', task, 'subject', sub(i));
        trial = randi([1,3]);
        test = test(trial);
        for j = 1:length(data)
            if strcmp(test.filename,data(j).filename);
                ind(j) = true;
            end
        end
    end
    Index{cal} = ind;
    Subject{cal} = sub;
end
    