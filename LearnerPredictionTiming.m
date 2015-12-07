function LearnerPredictionTiming(rounding,TrainTest,nTrees,time,folder)
    rounding = 1; TrainTest = 1; nTrees = 500; time = '3010151927r1'; folder = '3010151927';
    close all;
    clearvars -except rounding TrainTest nTrees time icc folder
    
    if rounding == 0
        fileround = 'Med';
        load(strcat('featuresMed',folder));
    elseif rounding == 1
        fileround = 'Round';
        load(strcat('SelectFeaturesMean',folder));
    end
    
    if TrainTest == 0
        filepart = 'CVPart';
        filename3 = strcat('cvpart',time,'.mat');
    elseif TrainTest == 1
        filepart = 'SubPart';
        filename3 = strcat('test_part',time,'.mat');
    end

    filename1 = strcat('RegEnsembleSelect',fileround,filepart,time,'.mat');
    filename2 = strcat('randForest',num2str(nTrees),'Trees',fileround,filepart,time,'.mat');
   
    load(filename3);
    testData = subTest(:,1)+2;
    tic
    data = STBData('SavedData', 'task', 1,'subject',testData(1)); 
    features = staticFeatures(data(1),rounding);
    features = featurePCA(features);
    [feature_val_vec, ratings_val] = featureVector(features);
    toc
    
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
    
%     if TrainTest == 0
%         for i = 1:5
%             test_part = test(cvpart{i});
%             features_test = features(test_part);
%             features_train = features(~test_part);
%             [~, rate_train] = featureVector(features_train);
%             [~, rate_test] = featureVector(features_test);
%             ratings_train(:,i) = rate_train(:,i);
%             ratings_test(:,i) = rate_test(:,i);
%         end
%     elseif TrainTest == 1
%         test_part = subTestInd;
%         features_test = features(test_part);
%         features_train = features(~test_part);
%         [~, ratings_train] = featureVector(features_train);
%         [~, ratings_test] = featureVector(features_test);
%     end
% 
% %     if select
% %         filename1 = strcat(filename1,'Select');
% %     end
% 
% %     load(strcat(filename1,'.mat'));
%     load(filename1)
%     
%     pred_reg_train = round(pred_train);
%     pred_reg_train(pred_reg_train<1) = 1;
%     pred_reg_test = round(pred_test);
%     pred_reg_test(pred_reg_test<1) = 1;
%     
%     figure(1);clf;
%     plot_pred(pred_reg_train, ratings_train);
% 
%     figure(2);clf;
%     plot_pred(pred_reg_test, ratings_test);
%     
%     
%     load(filename2)
%     
%     clear pred_train pred_test
%     
%     for i = 1:5
%         if TrainTest == 0
%             test_part = test(cvpart{i});
%             features_test = features(test_part);
%             features_train = features(~test_part);
%             [feature_vector_train, ~] = featureVector(features_train);
%             [feature_vector_test, ~] = featureVector(features_test);
%         elseif TrainTest == 1
%             test_part = subTestInd;
%             features_test = features(test_part);
%             features_train = features(~test_part);
%             [feature_vector_train, ~] = featureVector(features_train);
%             [feature_vector_test, ~] = featureVector(features_test);
%         end
%         
%         [predClass_train{i},classifScore] = models{i}.predict(feature_vector_train(:,maxIndex{i})); 
%         pred_train{i} = str2num(cell2mat(predClass_train{i}));
% 
%         [predClass_test{i},classifScore] = models{i}.predict(feature_vector_test(:,maxIndex{i})); 
%         pred_test{i} = str2num(cell2mat(predClass_test{i}));
%     end
    





% load randForestLearner500Trees
% %%
% tic
% for i = 1:5
%     ind=find(ismember(index,models{i}.VarNames));
%     [predClass_val{i},classifScore] = models{i}.predict(feature_vector_val(10,maxIndex{i})); 
%     pred_val{i} = str2num(cell2mat(predClass_val{i}));
% end
% toc
% 
% %%
% load resultsSQRTLogPCARoundLOOCVSelect0309151748
% load Features
% load SelectFeatures
% load test_part.mat
% test_part = subTestInd;
% features_val = features(test_part);
% [feature_vector, ratings] = featureVector(features);
% [feature_val_vec, ratings_val] = featureVector(features_val);
% %%
% tic
% for i = 1:5
%         selectfeature_val_vec = feature_val_vec(1,selectFeatures{i});
%         [X, muX, sigmaX] = zscore(feature_vector(:,selectFeatures{i}));
%         Xtest = bsxfun(@rdivide,bsxfun(@minus, selectfeature_val_vec, muX), sigmaX); 
%         Xtest(isnan(Xtest)) = 0;
%         [pred_val1(:,i), accuracy, prob_estimates] = svmpredict(ratings_val(1,i), Xtest, models1{i},'-q');
%         pred_val2(:,i) = cvglmnetPredict(models2{i}, Xtest, 'lambda_1se');
%         pred_val3(:,i) = predict(models3{i}, Xtest);
%         pred_val4(:,i) = predict(models4{i}, Xtest);
%     end
% 
%     pred_val = (pred_val1 + pred_val2 + pred_val3 + pred_val4)/4;
% toc