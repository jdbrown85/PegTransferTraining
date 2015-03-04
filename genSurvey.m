clearvars

% Delete and remake file
filename = 'MatlabTest.txt';
system(['rm ' filename]);
system(['touch ' filename]);
% Open file in append mode
f = fopen(filename, 'a+');

% Load base block from file
baseSurvey = fileread('qualtricsBaseBlock.txt'); 

% Load saved data to link to youtube
data = STBData('SavedData', 'task', 1, 'subject', 3);

% Add header
fprintf(f, '[[AdvancedFormat]]\n\n');
for i = 1:length(data)
    trialname = data(i).filename(end-21:end-4);   
    fprintf(f, baseSurvey, trialname, i, data(i).youtube_short);
end
