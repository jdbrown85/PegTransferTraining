%% support vector regression test (from Sarah) converted for the STB data
function [b,C,results,selectFeat,classifScore] = randomForestTrain(xVal,metric,leaf,nTrees)
%     rounding = 1;
%     xVal = 1;
%     metric = 1;
%     leaf = 10;
%     nTrees = 100;
    clearvars -except design xVal metric leaf nTrees; close all;
    file = strcat('randForestLearner',num2str(nTrees),'Trees.mat');
    if exist(file,'file')
        load(file)
    else

        if ~exist('SelectFeatures.mat','file')
            error('Quitting EnsembleTest. Please run FeatureSelection.m')
        else
            % If a features.mat file exists, load that instead
            disp('Loading Features...')
            load features.mat;
%             load SelectFeatures.mat;
        end

        % Load partition to split data into test and validation sets
        if xVal
            if exist('test_part.mat','file')
                load test_part.mat
                test_part = subTestInd;
            else
                [subTest,subTestInd,subTrain,subTrainInd] = make_subject_partition(4);
                test_part = subTestInd;
            end
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

        [feature_vector, ratings, index] = featureVector(features);    
        ratings = floor(ratings);
        
        [feature_vector_val, ratings_val] = featureVector(features_val);    
        ratings_val = floor(ratings_val);
    end
    
    

        % Build separate models for each grading metric
%         nMetric = size(ratings, 2)

    X = feature_vector;
    Y = ordinal(ratings(:,metric));
    rng(9876,'twister');
    savedRng = rng; % save the current RNG settings
    
%     C = [0 1 1.5 2 2.5;1 0 1 1.5 2; 1.5 1 0 1 1.5;2 1.5 1 0 1;2.5 2 1.5 1 0]; % cost matrix
    C = [0 1 2 3 4;1 0 1 2 3;2 1 0 1 2;3 2 1 0 1;4 3 2 1 0];
    
    if ~any(ismember(ratings(:,metric),1))
        C = C(2:end,2:end);
    end
  
    figure
    color = 'bgr';
    for ii = 1:length(leaf)
        % Reinitialize the random number generator, so that the
        % random samples are the same for each leaf size
        rng(savedRng);
        % Create a bagged decision tree for each leaf size and plot out-of-bag
        % error 'oobError'
        b = TreeBagger(nTrees,X,Y,'OOBPred','on','OOBVarImp','on','Prior','Empirical',...
                                 'MinLeaf',leaf(ii),'Cost',C);
        plot(b.oobError,color(ii));
        hold on;
    end

    xlabel('Number of grown trees');
    ylabel('Out-of-bag classification error');
    legtext = textscan(num2str(leaf),'%s');
    legend(legtext{1},'Location','NorthEast');
    title('Classification Error for Different Leaf Sizes');
    hold off;

    figure
    bar(b.OOBPermutedVarDeltaError);
    xlabel('Feature number');
    ylabel('Out-of-bag feature importance');
    title('Feature importance results');

    oobErrorFullX = b.oobError;
    
    if size(leaf,2)>1
        error('leaf has too many options')
    else

        [sortedValues,sortIndex] = sort(b.OOBPermutedVarDeltaError(:),'descend');
        maxIndex{metric} = sortIndex(1:30);
        selectFeat = index(maxIndex{metric});

        X = feature_vector(:,maxIndex{metric});
        rng(savedRng);
        b = TreeBagger(nTrees,X,Y,'OOBPred','on','Prior','Empirical',...
                                  'MinLeaf',leaf,'Cost',C);

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

        models{metric} = b;

        [predClass,classifScore] = b.predict(feature_vector_val(:,maxIndex{metric}));

        C = confusionmat(categorical(ratings_val(:,metric)),categorical(predClass),...
        'order',{'5' '4' '3' '2' '1'});
        Cperc = diag(sum(C,2))\C;

        results{metric} = str2num(char(predClass))-ratings_val(:,metric);
        
        save(file,'models','maxIndex','index','feature_vector','ratings','feature_vector_val','ratings_val','results')
    end
end
