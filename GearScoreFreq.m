clear all; close all; clc
load features
load test_part.mat

test_part = subTestInd;

features_val = features(test_part);
features = features(~test_part);

[feature_vector, ratings, index] = featureVector(features);    
ratings = floor(ratings);

[feature_vector_val, ratings_val] = featureVector(features_val);    
ratings_val = floor(ratings_val);

ratings = floor(ratings);
ratings_val = floor(ratings_val);

a = unique(ratings);
b = unique(ratings_val);

Depth(:,1) = histc(ratings(:,1),a)/sum(histc(ratings(:,1),a))*100;
Biman(:,1) = histc(ratings(:,2),a)/sum(histc(ratings(:,2),a))*100;
Effic(:,1) = histc(ratings(:,3),a)/sum(histc(ratings(:,3),a))*100;
Force(:,1) = histc(ratings(:,4),a)/sum(histc(ratings(:,4),a))*100;
Robot(:,1) = histc(ratings(:,5),a)/sum(histc(ratings(:,5),a))*100;

% floor([Depth,Biman,Effic,Force,Robot])

Depth(:,2) = histc(ratings_val(:,1),b)/sum(histc(ratings_val(:,1),b))*100;
Biman(:,2) = histc(ratings_val(:,2),b)/sum(histc(ratings_val(:,2),b))*100;
Effic(:,2) = histc(ratings_val(:,3),b)/sum(histc(ratings_val(:,3),b))*100;
Force(:,2) = histc(ratings_val(:,4),b)/sum(histc(ratings_val(:,4),b))*100;
Robot(:,2) = histc(ratings_val(:,5),b)/sum(histc(ratings_val(:,5),b))*100;

% floor([Depth,Biman,Effic,Force,Robot])

for i=1:5
    fprintf('%d & %d/%d & %d/%d & %d/%d & %d/%d & %d/%d \\\\ \\hline \n',i,floor(Depth(i,:)),floor(Biman(i,:)),floor(Effic(i,:)),floor(Force(i,:)),floor(Robot(i,:)))
end