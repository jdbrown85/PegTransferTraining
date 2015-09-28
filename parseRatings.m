function parseRatings(ratingFile, dataDir)
%%PARSERATINGS parses .xls file created from .csv downloaded from qualtics 
% website
%   This only works with surveys generated using genSurvey.m
%   If there are errors loading files, try regenerating the lookup.mat file using
%   makeLookup.m in UtilityScripts

    if nargin == 1
        dataDir = 'SavedData';
    end
    load([dataDir '/lookup.mat']);

    [~, ~, raw] = xlsread(ratingFile);
    ratedVideos = raw(3,strncmpi(raw(2,:), 'Video', 5));
    newScore = cell2mat(raw(3:end, strncmpi(raw(1,:), 'Q', 1)));
%     newRater = raw(3:end, strcmpi(raw(2,:), 'ResponseID'));
    newRater = raw(3:end, strcmpi(raw(2,:), 'Name'));
    [y,i] = sort(newRater);
    newScore = newScore(i,:);
    newRater = y;
    for i = 1:length(ratedVideos)
        try
            matVars = whos('-file', lookup(ratedVideos{i}));
            
            if any(strcmpi({matVars.name}, 'rater'))
                load(lookup(ratedVideos{i}), 'score', 'rater');
            else
                score = [];
                rater = {};
            end
            
            score = [score; newScore(~ismember(newRater, rater),(1:5)+(i-1)*5)];
            rater = cat(1,rater, newRater{~ismember(newRater, rater)});
            
            save(lookup(ratedVideos{i}), 'score', 'rater', '-append');
        catch ME
            disp(['Trouble with Video' num2str(i)]);
            disp(ME.message)
        end
    end
    
end