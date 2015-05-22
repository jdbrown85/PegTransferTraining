%% support vector regression test (from Sarah) converted for the STB data

clearvars;
addpath('lib');
addpath('glmnet_matlab');

if ~exist('features.mat','file')
    data = STBData('SavedData', 'task', 1);
    data = data(~cellfun(@(x)any(isnan(x(:))), {data.score}));
    
    num = xlsread('DemographicSurvey.xls');
    subjects = num(1:end, 5);
    fam = num(1:end, 11);
    
    for i = 1:length(data)
        data(i).fam = fam(subjects==data(i).subj_id);
    end
    
    data = data(~cellfun(@isempty, {data.score}));
    
    disp('Extracting Features...')
    features = staticFeatures(data);
    save('features.mat', 'features');
else
    disp('Loading Features...')
    load features.mat;
    features = features(~cellfun(@isempty,{features.gears}));
end
load test_part.mat
%% obtain feature and rating matrices
features_val = features(test_part);
features = features(~test_part);
n = length(features);
% n = 20;
part = make_xval_partition(length(features), n);

preds = [];
[feature_vector, ratings] = featureVector(features);
ratings = round(ratings);

% feature_vector = feature_vector(:, var(feature_vector) > 0.001);
k = 10;
for fold = 1:n
    fprintf('Fold %03d: ', fold);

    feature_train = feature_vector(part ~= fold,:);
    ratings_train = ratings(part ~= fold,:);
    
    %% standardize data for svr
    [X, muX, sigmaX] = zscore(feature_train);  

%     Xpca = X*coefs;
    
    % Build separate models for each grading metric
    nMetric = size(ratings, 2);
    models = cell(1,nMetric);

    opt = glmnetSet;
    opt.alpha = 1;
    for i = 1:nMetric;
        fprintf('Metric %d ...', i);
        y = ratings_train(:,i); 
        models1{i} = svmtrain(y, X, '-s 3 -t 0 -q'); 
        models2{i} = cvglmnet(X,y, 'gaussian',opt);
        models3{i} = fitrtree(X, y);
        models4{i} = fitcknn(X,y,'NumNeighbors',3);
        fprintf(repmat('\b', 1, 12));
    end

    %% predict labels for test data
    feature_test = feature_vector(part == fold,:);
    ratings_test = ratings(part == fold,:);

    Xtest = bsxfun(@rdivide,bsxfun(@minus, feature_test, muX), sigmaX); 
    Xtest(isnan(Xtest)) = 0;
    
%     disp('Making Prediction');
    predictions = zeros(size(feature_test,1), nMetric); 
    for i = 1:nMetric
        [predicted_label1, accuracy, prob_estimates] = svmpredict(ratings_test(:,i), Xtest, models1{i},'-q');
        predicted_label2 = cvglmnetPredict(models2{i}, Xtest, 'lambda_1se');
        predicted_label3 = predict(models3{i}, Xtest);
        predicted_label4 = predict(models4{i}, Xtest);
        predictions1(:,i) = predicted_label1;
        predictions2(:,i) = predicted_label2;
        predictions3(:,i) = predicted_label3;
        predictions4(:,i) = predicted_label4;
    end
    pred1(part == fold,:) = predictions1;
    pred2(part == fold,:) = predictions2;
    pred3(part == fold,:) = predictions3;
    pred4(part == fold,:) = predictions4;
    fprintf(repmat('\b', 1, 10));
    predictions1 = [];
    predictions2 = [];
    predictions3 = [];
    predictions4 = [];
    predictions5 = [];
end

pred = (pred1 + pred2 + pred3 + pred4)/4;
pred(isnan(pred)) = 1;

fprintf('Total Err: \n');
fprintf('Ensemble: ');
check_err(pred, ratings);
fprintf('SVR: ');
check_err(pred1, ratings);
fprintf('CVGLMNET: ');
check_err(pred2, ratings);
fprintf('Regression Tree: ');
check_err(pred3, ratings);
fprintf('KNN: ');
check_err(pred4, ratings);

fprintf('Ensemble Metric Error: \n');
fprintf('Depth Perception: ');
check_err(pred(:,1), ratings(:,1));
fprintf('Bimanual Dexterity: ');
check_err(pred(:,2), ratings(:,2));
fprintf('Efficiency: ');
check_err(pred(:,3), ratings(:,3));
fprintf('Force Sensitivity: ');
check_err(pred(:,4), ratings(:,4));
fprintf('Robotic Control: ');
check_err(pred(:,5), ratings(:,5));

[feature_val_vec, ratings_val] = featureVector(features_val);
[X, muX, sigmaX] = zscore(feature_vector);  
for i = 1:nMetric;
    y = ratings(:,i); 
    models1{i} = svmtrain(y, X, '-s 3 -q'); 
    models2{i} = cvglmnet(X, y, 'gaussian', opt);
    models3{i} = fitrtree(X, y);
    models4{i} = fitcknn(X,y,'NumNeighbors',3);
end

Xtest = bsxfun(@rdivide,bsxfun(@minus, feature_val_vec, muX), sigmaX); 
Xtest(isnan(Xtest)) = 0;

for i = 1:nMetric
    [pred_val1(:,i), accuracy, prob_estimates] = svmpredict(ratings_val(:,i), Xtest, models1{i},'-q');
    pred_val2(:,i) = cvglmnetPredict(models2{i}, Xtest, 'lambda_1se');
    pred_val3(:,i) = predict(models3{i}, Xtest);
    pred_val4(:,i) = predict(models4{i}, Xtest);
end

pred_val = (pred_val1 + pred_val2 + pred_val3 + pred_val4)/4;
pred_val(isnan(pred_val)) = 1;

fprintf('Final Error: \n');
fprintf('Ensemble: ');
check_err(pred_val, ratings_val);
fprintf('Depth Perception: ');
check_err(pred_val(:,1), ratings_val(:,1));
fprintf('Bimanual Dexterity: ');
check_err(pred_val(:,2), ratings_val(:,2));
fprintf('Efficiency: ');
check_err(pred_val(:,3), ratings_val(:,3));
fprintf('Force Sensitivity: ');
check_err(pred_val(:,4), ratings_val(:,4));
fprintf('Robotic Control: ');
check_err(pred_val(:,5), ratings_val(:,5));

figure(1);clf;
plot_pred(pred, ratings);

figure(2);clf;
plot_pred(pred_val, ratings_val);

save('results.mat', 'ratings', 'ratings_val', ...
    'pred_val', 'pred_val1', 'pred_val2', 'pred_val3', 'pred_val4',...
    'pred', 'pred1', 'pred2', 'pred3', 'pred4');
%% PCA Check
% 
% [~, score] = pca(feature_vector);
% r = round(mean(ratings,2));
% figure(2);clf;
% 
% hold on
% colormap lines
% for i = 1:5
%     scatter(score(r==i, 2), score(r==i, 3));
% end
