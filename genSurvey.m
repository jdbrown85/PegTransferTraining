function genSurvey(data, filename)

% Delete and remake file
% filename = '10Trial2.txt';
if exist(filename, 'file')
    system(['rm ' filename]);
end
system(['touch ' filename]);
% Open file in append mode
f = fopen(filename, 'a+');

% Load base block from file
baseSurvey = fileread('qualtricsBaseBlock.txt'); 

% Load saved data to link to youtube
% data = STBData('SavedData');
% data = survey;
% Add header
fprintf(f, '[[AdvancedFormat]]\n\n');
for i = 1:length(data)
    trialname = data(i).filename(end-21:end-4);   
    fprintf(f, baseSurvey, trialname, i, data(i).youtube_short);
end
