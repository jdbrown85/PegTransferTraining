! python UtilityScripts/retrieveYoutube.py

f = fopen('youtube.txt');
videos = textscan(f, '%s %s', 'whitespace',',');
for i = 1:length(videos{1})
    videos{1}{i}([10 16])= '-';
    videos{1}{i}([7 13])= '_';
end


dataDir = 'SavedData';
subjectDirs = dir([dataDir '/Subject*']);
problemFiles = {};
for i = 1:length(subjectDirs)
    trialFiles = dir([dataDir '/' subjectDirs(i).name  '/*.mat']);
        for j = 1:length(trialFiles)
            load([dataDir '/' subjectDirs(i).name '/' trialFiles(j).name], 'youtube_short');
            try
                youtube_short = videos{2}{strncmpi(videos{1}, trialFiles(j).name,18)}; 
                youtube = ['youtu.be/' youtube_short];
                save([dataDir '/' subjectDirs(i).name '/' trialFiles(j).name], 'youtube','youtube_short', '-append');
            catch
                disp(['Problem with ' trialFiles(j).name]);
                problemFiles{end+1} = trialFiles(j).name;
            end
        end
end