%% support vector regression test (from Sarah) converted for the STB data

clearvars;
addpath('LIBSVM');
addpath('glmnet_matlab');

if ~exist('features.mat','file')

    % Load data for all subjects and trials, task #1
    data = STBData('SavedData', 'task', 1);

    % Remove any trials that has errors in reading score (bug should be fixed)
    data = data(~cellfun(@(x)any(isnan(x(:))), {data.score}));
    
    % Add demographic survey familiarity data into data obj
    num = xlsread('DemographicSurvey.xls');
    subjects = num(1:end, 5);
    fam = num(1:end, 11);
    
    for i = 1:length(data)
        data(i).fam = fam(subjects==data(i).subj_id);
    end
    
    % Remove any trials that have not been scored yet
    data = data(~cellfun(@isempty, {data.score}));
    
    % Extract features from data obj, use oldStaticFeatures to get Sara's
    disp('Extracting Features...')
    features = staticFeatures(data);

    % Save features into .mat so you don't have to do this every time
    save('features.mat', 'features');
else
    % If a features.mat file exists, load that instead
    disp('Loading Features...')
    load features.mat;
    features = features(~cellfun(@isempty,{features.gears}));
end

% Load partition to split data into test and validation sets
if exist('test_part.mat','file')
    load test_part.mat
else
    test_part = make_xval_partition(length(features), 10);
    test_part = test_part == 10;
end

% Split dataset into testing and validation
features_val = features(test_part);
features = features(~test_part);

% Create xval partition for testing set
n = length(features);
n = 10;
part = make_xval_partition(length(features), n);

preds = [];
[feature_vector, ratings] = featureVector(features);
ratings = round(ratings);

for fold = 1:n
    fprintf('Fold %03d: ', fold);

    feature_train = feature_vector(part ~= fold,:);
    ratings_train = ratings(part ~= fold,:);
    
    %% standardize data for svr
    [X, muX, sigmaX] = zscore(feature_train);  
    
    % Build separate models for each grading metric
    nMetric = size(ratings, 2);
    models = cell(1,nMetric);

    for i = 1:nMetric;
        fprintf('Metric %d ...', i);
        y = ratings_train(:,i); 
        % LIBSVM SVR
        models1{i} = svmtrain(y, X, '-s 3 -t 2 -q'); 
        % Elastic net using GLMNET
        models2{i} = cvglmnet(X,y, 'gaussian');
        % Regression tree
        models3{i} = fitrtree(X, y);
        % KNN 
        models4{i} = fitcknn(X,y,'NumNeighbors',3);
        fprintf(repmat('\b', 1, 12));
    end

    % split out testing trials
    feature_test = feature_vector(part == fold,:);
    ratings_test = ratings(part == fold,:);

    % Standardize training data
    Xtest = bsxfun(@rdivide,bsxfun(@minus, feature_test, muX), sigmaX); 
    Xtest(isnan(Xtest)) = 0;
    
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

% Average predictions together
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

% Run entire testing dataset against validation set
[feature_val_vec, ratings_val] = featureVector(features_val);
[X, muX, sigmaX] = zscore(feature_vector);  
for i = 1:nMetric;
    y = ratings(:,i); 
    models1{i} = svmtrain(y, X, '-s 3 -q'); 
    models2{i} = cvglmnet(X, y, 'gaussian');
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

