clc; clear all;
addpath SurveyResults

for j = 6:6
[~, ~, raw] = xlsread(strcat('STB_GEARS_Rnd',num2str(j),'.xls'));
ratedVideos = raw(3,strncmpi(raw(2,:), 'Video', 5));
Score = cell2mat(raw(3:end, strncmpi(raw(1,:), 'Q', 1)))';
Rater = raw(3:end, strcmpi(raw(2,:), 'Name'));
[y,i] = sort(Rater);
Ratings = Score(:,i');
% Ratings = csvread('STB_GEARS_Rnd1_JBRedo.csv',2,2)';
% 
% Ratings = Ratings(:,2:4);
% Ratings(:,[1,3])=Ratings(:,[3,1]);

% Ratings(1:6:length(Ratings),:)=[];


Gears1 = Ratings(1:5:end,:);
Gears2 = Ratings(2:5:end,:);
Gears3 = Ratings(3:5:end,:);
Gears4 = Ratings(4:5:end,:);
Gears5 = Ratings(5:5:end,:);

% Gears4(7:8,:) = [4 4;4 4];

xlswrite(strcat('Stats/GEARS_Rnd',num2str(j)),Ratings);
xlswrite(strcat('Stats/GEARS1_Rnd',num2str(j)),Gears1);
xlswrite(strcat('Stats/GEARS2_Rnd',num2str(j)),Gears2);
xlswrite(strcat('Stats/GEARS3_Rnd',num2str(j)),Gears3);
xlswrite(strcat('Stats/GEARS4_Rnd',num2str(j)),Gears4);
xlswrite(strcat('Stats/GEARS5_Rnd',num2str(j)),Gears5);

end
%%
clear all;
Gears1 = [];
Gears2 = [];
Gears3 = [];
Gears4 = [];
Gears5 = [];

for i = 1:6
    Gears1 = [Gears1;csvread(strcat('GEARS1_Rnd',num2str(i),'.csv'))];
    Gears2 = [Gears2;csvread(strcat('GEARS2_Rnd',num2str(i),'.csv'))];
    Gears3 = [Gears3;csvread(strcat('GEARS3_Rnd',num2str(i),'.csv'))];
    Gears4 = [Gears4;csvread(strcat('GEARS4_Rnd',num2str(i),'.csv'))];
    Gears5 = [Gears5;csvread(strcat('GEARS5_Rnd',num2str(i),'.csv'))];
end

xlswrite('Stats/GEARS1_RndAll',Gears1);
xlswrite('Stats/GEARS2_RndAll',Gears2);
xlswrite('Stats/GEARS3_RndAll',Gears3);
xlswrite('Stats/GEARS4_RndAll',Gears4);
xlswrite('Stats/GEARS5_RndAll',Gears5);