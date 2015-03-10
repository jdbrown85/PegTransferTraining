function parseRatings(ratingFile, dataDir)
    
    if nargin == 1
        dataDir = 'SavedData';
    end
    load([dataDir '/lookup.mat']);

    [~, ~, raw] = xlsread(ratingFile);
    ratedVideos = raw(3,strncmpi(raw(2,:), 'Video', 5));
    newScore = cell2mat(raw(3:end, strncmpi(raw(1,:), 'Q', 1)));
    newRater = raw(3:end, strcmpi(raw(1,:), 'Name'));

    for i = 1:length(ratedVideos)
        try
            matVars = whos('-file', lookup(ratedVideos{i}));
            
            if any(strcmpi({matVars.name}, 'rater')) 
                load(lookup(ratedVideos{i}), 'score', 'rater');
            else
                score = [];
                rater = [];
            end
            
            score = [score; newScore(:,(1:5)+(i-1)*5)];
            rater = [rater; newRater];
            save(lookup(ratedVideos{i}), 'score', 'rater', '-append');
        catch
            disp(['Trouble with Video' num2str(i)]);
        end
    end
    
end