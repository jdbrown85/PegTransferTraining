function parseRatings(filename)
    
    load blockCorr.mat
    
    [num, txt, raw] = xlsread(filename);
    
    dataDir = 'TestData';
    subjectDirs = dir([dataDir '/Subject*']);
    
    for i = 1:length(subjectDirs)
        trialFiles = dir([dataDir '/' subjectDirs(i).name  '/*.mat']);
            for j = 1:length(trialFiles)
                disp(['Loading: ' trialFiles(j).name])
                load([dataDir '/' subjectDirs(i).name '/' trialFiles(j).name], 'rawData');
                
                if False % match between recorded answers and current trial name, else return NaN
                    respondent = []; %get ratings from txt
                    rating = []; %get ratings from num
                else
                    respondent = '';
                    rating = NaN(1,5);
                end
                
                save([dataDir '/' subjectDirs(i).name '/' trialFiles(j).name], 'rawData', 'respondent', 'rating');
            
            end
    end
    
end