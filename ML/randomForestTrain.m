%% support vector regression test (from Sarah) converted for the STB data
function [b,C,results] = randomForestTrain(design,xVal,metric,leaf,nTrees)
%     rounding = 1;
%     xVal = 1;
%     metric = 1;
%     leaf = 10;
%     nTrees = 100;
    clearvars -except design xVal metric leaf nTrees; close all;

    if ~exist('SelectFeatures.mat','file')
        error('Quitting EnsembleTest. Please run FeatureSelection.m')
    else
        % If a features.mat file exists, load that instead
        disp('Loading Features...')
        load features.mat;
        load SelectFeatures.mat;
    end

    % Load partition to split data into test and validation sets
    if xVal
        [subTest,subTestInd,subTrain,subTrainInd] = make_subject_partition(4);
        test_part = subTestInd
    else
        if exist('test_part.mat','file')
                load test_part.mat
            else
                test_part = make_xval_partition(length(features), 10);
                test_part = test_part == 10;
        end
    end
    
    % Split dataset into testing and validation
    features_val = features(test_part);
    features = features(~test_part);

    % Create xval partition for testing set
   
    [feature_vector, ratings] = featureVector(features);    
    ratings = round(ratings);
    
    

        % Build separate models for each grading metric
%         nMetric = size(ratings, 2)

    X = feature_vector;
    Y = ordinal(ratings(:,metric));
    rng(9876,'twister');
    savedRng = rng; % save the current RNG settings

    if design   
        figure
        color = 'bgr';
        for ii = 1:length(leaf)
            % Reinitialize the random number generator, so that the
            % random samples are the same for each leaf size
            rng(savedRng);
            % Create a bagged decision tree for each leaf size and plot out-of-bag
            % error 'oobError'
            b = TreeBagger(nTrees,X,Y,'OOBPred','on','OOBVarImp','on','Prior','Uniform',...
                                     'CategoricalPredictors',size(feature_vector,2),...
                                     'MinLeaf',leaf(ii));
            plot(b.oobError,color(ii));
            hold on;
        end
            
            xlabel('Number of grown trees');
            ylabel('Out-of-bag classification error');
            legend({'10', '15', '20'},'Location','NorthEast');
            title('Classification Error for Different Leaf Sizes');
            hold off;

            figure
            bar(b.OOBPermutedVarDeltaError);
            xlabel('Feature number');
            ylabel('Out-of-bag feature importance');
            title('Feature importance results');

            oobErrorFullX = b.oobError;

            [sortedValues,sortIndex] = sort(b.OOBPermutedVarDeltaError(:),'descend');
            maxIndex = sortIndex(1:30);

            X = feature_vector(:,maxIndex);
            rng(savedRng);
            b = TreeBagger(nTrees,X,Y,'OOBPred','on','Prior','Uniform',...
                                      'CategoricalPredictors',length(maxIndex),...
                                      'MinLeaf',leaf);

            oobErrorX246 = b.oobError;

            figure
            plot(oobErrorFullX,'b');
            hold on;
            plot(oobErrorX246,'r');
            xlabel('Number of grown trees');
            ylabel('Out-of-bag classification error');
            legend({'All features', 'Select Features'},'Location','NorthEast');
            title('Classification Error for Different Sets of Predictors');
            hold off;

            b = b.compact;
    end


    [feature_vector_val, ratings_val] = featureVector(features_val);    
    ratings_val = round(ratings_val);
    [predClass,classifScore] = b.predict(feature_vector_val(:,maxIndex));

    C = confusionmat(categorical(ratings_val(:,metric)),categorical(predClass),...
    'order',{'5' '4' '3' '2' '1'})
    Cperc = diag(sum(C,2))\C
    
    results = abs(str2num(char(predClass))-ratings_val(:,metric));

%             model = TreeBagger(nTrees, X, Y, 'Prior', 'Empirical','OOBPred','On','OOBVarImp','On');
%             
%             figure(i)
%             oobErrorBaggedEnsemble = oobError(model{i});
%             plot(oobErrorBaggedEnsemble)
%             xlabel 'Number of grown trees';
%             ylabel 'Out-of-bag classification error';
% 
%             
%             
%             predicted_label = predict(model{i},X);
%             ErrTrain(:,i) = error(model{i},X,ratings(:,i));
%             Pred(:,i) = predicted_label;
%             
%             fprintf(repmat('\b', 1, 12));
            
%         end
% 
%     [feature_val_vec, ratings_val] = featureVector(features_val);
% 
%     if rounding
%         ratings_val = round(ratings_val);
%     end
% %     
%     for i = 1:nMetric
%         if FeatSel
%             selectfeature_val_vec = feature_val_vec(:,selectFeatures{i});
%             [X, muX, sigmaX] = zscore(feature_vector(:,selectFeatures{i}));
%         else
%             selectfeature_val_vec = feature_val_vec;
%             [X, muX, sigmaX] = zscore(feature_vector);
%         end
%         Xtest = bsxfun(@rdivide,bsxfun(@minus, selectfeature_val_vec, muX), sigmaX); 
%         Xtest(isnan(Xtest)) = 0;
%         Pred_val(:,i) = predict(model{i},Xtest);
%         Err_val(:,i) = error(model{i},Xtest,ratings_val(:,i));
%     end

% 
%     save(strcat('resultsSQRTLogPCA',fileround,fileloocv,'Select.mat'), 'ratings', 'ratings_val', ...
%         'pred_val', 'pred_val1', 'pred_val2', 'pred_val3', 'pred_val4',...
%         'pred', 'pred1', 'pred2', 'pred3', 'pred4');
end
