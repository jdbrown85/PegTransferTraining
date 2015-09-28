load randForestLearner500Trees
%%
tic
for i = 1:5
    ind=find(ismember(index,models{i}.VarNames));
    [predClass_val{i},classifScore] = models{i}.predict(feature_vector_val(10,maxIndex{i})); 
    pred_val{i} = str2num(cell2mat(predClass_val{i}));
end
toc

%%
load resultsSQRTLogPCARoundLOOCVSelect0309151748
load Features
load SelectFeatures
load test_part.mat
test_part = subTestInd;
features_val = features(test_part);
[feature_vector, ratings] = featureVector(features);
[feature_val_vec, ratings_val] = featureVector(features_val);
%%
tic
for i = 1:5
        selectfeature_val_vec = feature_val_vec(1,selectFeatures{i});
        [X, muX, sigmaX] = zscore(feature_vector(:,selectFeatures{i}));
        Xtest = bsxfun(@rdivide,bsxfun(@minus, selectfeature_val_vec, muX), sigmaX); 
        Xtest(isnan(Xtest)) = 0;
        [pred_val1(:,i), accuracy, prob_estimates] = svmpredict(ratings_val(1,i), Xtest, models1{i},'-q');
        pred_val2(:,i) = cvglmnetPredict(models2{i}, Xtest, 'lambda_1se');
        pred_val3(:,i) = predict(models3{i}, Xtest);
        pred_val4(:,i) = predict(models4{i}, Xtest);
    end

    pred_val = (pred_val1 + pred_val2 + pred_val3 + pred_val4)/4;
toc