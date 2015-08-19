
clearvars;
addpath('LIBSVM');
addpath('glmnet_matlab');

if ~exist('features.mat','file')
    if ~exist('data')
        data = STBData('SavedData', 'task', 1);
        data = data(~cellfun(@(x)any(isnan(x(:))), {data.score}));
    end
    
    num = xlsread('DemographicSurvey.xls');
    subjects = num(1:end, 5);
    fam = num(1:end, 11);
    
    for i = 1:length(data)
        data(i).fam = fam(subjects==data(i).subj_id);
    end
    
    data = data(~cellfun(@isempty, {data.score}));
    
    disp('Extracting Features...')
    features = staticFeatures(data);
    features = featurePCA(features);
    save('features.mat', 'features');
else
    disp('Loading Features...')
    load features.mat;
    features = features(~cellfun(@isempty,{features.gears}));
end

preds = [];
kept_pred = [];
final_idx = {};
final_index = {};
[feature_vector, ratings, index] = featureVector(features);
% ratings = floor(ratings);
% % ratings = round(ratings);
% ratings = sum(ratings,2);

for metric = 1:size(ratings, 2) % runs the feature selection for each metric
    features_test = feature_vector; %initializes the set of features to test to be the entire set
    features_kept = []; %initializes the features to keep to 0
    index_test = index;
    index_kept = {};
    kept_idx = zeros(size(features_test,2),1); %initializes the variable to hold the index of kept features
    j = 1;
    lastErr = 100; %initialize the last error to be the max 100%
    for f = 1:size(feature_vector,2) %iterates through the entire set of features
        err = zeros(size(features_test,2),1); %initializes the error vector
        for i = 1:size(features_test,2) %iterates through the number of features being tested
            pred = svmXval([features_kept features_test(:,i)], ratings(:,metric)); %trains the SVM model using the kept features and a new feature
            err(i) = norm(pred- ratings(:,metric),1); %computes the error in the prediction 
        end
        [minErr, idx] = min(err); %finds the minimum error and which index it occurs at 
        features_kept = [features_kept features_test(:,idx)]; %stores the features that minimized the error
        index_kept = [index_kept index_test{idx}];
        features_test(:,idx) = []; %remove kept features from features that still need testing
        index_test(idx) = [];
        kept_idx(j) = idx; %stores the index of the kept features 
        j = j+1;
        
        if minErr > lastErr %stops program if error stops decreasing with new features
            break
        end
        lastErr = minErr; %stores current minimum error for comparison on next iteration
        disp(f);
    end

    kept_idx(j:end) = [];
    final_idx{end+1} = kept_idx;
    final_index{end+1} = index_kept';
    kept_pred(:,metric) = svmXval(features_kept, ratings(:,metric));
end

for i=1:length(final_index)
    metric_index = [];
    for j=1:length(final_index{i})
        metric_index(j) = find(strcmp(final_index{i}{j},index));
    end
    total_index{i} = metric_index;
end
selectFeatures = total_index;
save('SelectFeatures.mat','selectFeatures')

