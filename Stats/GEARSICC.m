clc; clear all; close all;
addpath SurveyResults

for j = 1:12
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

for i = 1:12
    Gears1 = [Gears1;csvread(strcat('GEARS1_Rnd',num2str(i),'.csv'))];
    Gears2 = [Gears2;csvread(strcat('GEARS2_Rnd',num2str(i),'.csv'))];
    Gears3 = [Gears3;csvread(strcat('GEARS3_Rnd',num2str(i),'.csv'))];
    Gears4 = [Gears4;csvread(strcat('GEARS4_Rnd',num2str(i),'.csv'))];
    Gears5 = [Gears5;csvread(strcat('GEARS5_Rnd',num2str(i),'.csv'))];
end

% GEARS = [Gears1;Gears2;Gears3;Gears4;Gears5];
GEARS = Gears1+Gears2+Gears3+Gears4+Gears5;

[Gears1ICC, ~, ~, ~, ~, ~, ~] = ICC(Gears1(~any(isnan(Gears1),2),:), 'A-k', .05, 0)
[Gears2ICC, ~, ~, ~, ~, ~, ~] = ICC(Gears2(~any(isnan(Gears2),2),:), 'A-k', .05, 0)
[Gears3ICC, ~, ~, ~, ~, ~, ~] = ICC(Gears3(~any(isnan(Gears3),2),:), 'A-k', .05, 0)
[Gears4ICC, ~, ~, ~, ~, ~, ~] = ICC(Gears4(~any(isnan(Gears4),2),:), 'A-k', .05, 0)
[Gears5ICC, ~, ~, ~, ~, ~, ~] = ICC(Gears5(~any(isnan(Gears5),2),:), 'A-k', .05, 0)
[GearsICC, ~, ~, ~, ~, ~, ~] = ICC(GEARS(~any(isnan(GEARS),2),:), 'A-k', .05, 0)

fprintf('\n\\TextWrapCent{GEARS}{Domain} \\\\ \\hline\n')
fprintf('%s \t& %1.2f \\\\ \n','Depth Perception',Gears1ICC)
fprintf('%s \t& %1.2f \\\\ \n','Bimanual Dexterity',Gears2ICC)
fprintf('%s \t& %1.2f \\\\ \n','Efficiency',Gears3ICC)
fprintf('%s \t& %1.2f \\\\ \n','Force Sensitivity',Gears4ICC)
fprintf('%s \t& %1.2f \\\\ \n','Robotic Control',Gears5ICC)
fprintf('%s \t& %1.2f \\\\ \n','Overall',GearsICC)

xlswrite('Stats/GEARS1_RndAll',Gears1);
xlswrite('Stats/GEARS2_RndAll',Gears2);
xlswrite('Stats/GEARS3_RndAll',Gears3);
xlswrite('Stats/GEARS4_RndAll',Gears4);
xlswrite('Stats/GEARS5_RndAll',Gears5);