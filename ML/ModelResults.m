function ModelResults(select,nTrees)
    clc;
    clearvars -except select nTrees

    filename1 = 'resultsSQRTLogPCARoundLOOCV';
    filename2 = strcat('randForestLearner',num2str(nTrees),'Trees.mat');
    if select
        filename1 = strcat(filename1,'Select');
    end

    load(strcat(filename1,'.mat'));
    
    pred = floor(pred);
    pred(pred<1) = 1;
    pred_val = floor(pred_val);
    pred_val(pred_val<1) = 1;
    
    IndThresh = 1;
    fprintf('Ensemble Metric Error: \n');
    fprintf('Depth Perception: ');
    check_err(pred(:,1), ratings(:,1), IndThresh);
    fprintf('Bimanual Dexterity: ');
    check_err(pred(:,2), ratings(:,2), IndThresh);
    fprintf('Efficiency: ');
    check_err(pred(:,3), ratings(:,3), IndThresh);
    fprintf('Force Sensitivity: ');
    check_err(pred(:,4), ratings(:,4), IndThresh);
    fprintf('Robotic Control: ');
    check_err(pred(:,5), ratings(:,5), IndThresh);

    fprintf('Final Error: \n');
    fprintf('Ensemble: ');
    check_err(pred_val, ratings_val, IndThresh);
    fprintf('Depth Perception: ');
    check_err(pred_val(:,1), ratings_val(:,1), IndThresh);
    fprintf('Bimanual Dexterity: ');
    check_err(pred_val(:,2), ratings_val(:,2), IndThresh);
    fprintf('Efficiency: ');
    check_err(pred_val(:,3), ratings_val(:,3), IndThresh);
    fprintf('Force Sensitivity: ');
    check_err(pred_val(:,4), ratings_val(:,4), IndThresh);
    fprintf('Robotic Control: ');
    check_err(pred_val(:,5), ratings_val(:,5), IndThresh);
    
    figure(1);clf;
    plot_pred(pred, ratings);

    figure(2);clf;
    plot_pred(pred_val, ratings_val);

    for i = 1:5
        near(1,i) = mean(abs(pred(:,i)-ratings(:,i)) <= 1);
        exact(1,i) = mean(abs(pred(:,i)-ratings(:,i)) == 0); 
        
        near_val(1,i) = mean(abs(pred_val(:,i)-ratings_val(:,i)) <= 1);
        exact_val(1,i) = mean(abs(pred_val(:,i)-ratings_val(:,i)) == 0); 
    end
    
    clearvars -except select nTrees near exact near_val exact_val
    filename2 = strcat('randForestLearner',num2str(nTrees),'Trees.mat');
    load(filename2)
    
    for i = 1:5
        [predClass{i},classifScore] = models{i}.predict(feature_vector(:,maxIndex{i})); 
        pred{i} = str2num(cell2mat(predClass{i}));

        [predClass_val{i},classifScore] = models{i}.predict(feature_vector_val(:,maxIndex{i})); 
        pred_val{i} = str2num(cell2mat(predClass_val{i}));
    end
    
    pred = cell2mat(pred);
    pred_val = cell2mat(pred_val);
    
    figure(3);clf;
    plot_pred(pred, ratings);

    figure(4);clf;
    plot_pred(pred_val, ratings_val);
    
    IndThresh = 1;
    fprintf('Ensemble Metric Error: \n');
    fprintf('Depth Perception: ');
    check_err(pred(:,1), ratings(:,1), IndThresh);
    fprintf('Bimanual Dexterity: ');
    check_err(pred(:,2), ratings(:,2), IndThresh);
    fprintf('Efficiency: ');
    check_err(pred(:,3), ratings(:,3), IndThresh);
    fprintf('Force Sensitivity: ');
    check_err(pred(:,4), ratings(:,4), IndThresh);
    fprintf('Robotic Control: ');
    check_err(pred(:,5), ratings(:,5), IndThresh);

    fprintf('Final Error: \n');
    fprintf('Ensemble: ');
    check_err(pred_val, ratings_val, IndThresh);
    fprintf('Depth Perception: ');
    check_err(pred_val(:,1), ratings_val(:,1), IndThresh);
    fprintf('Bimanual Dexterity: ');
    check_err(pred_val(:,2), ratings_val(:,2), IndThresh);
    fprintf('Efficiency: ');
    check_err(pred_val(:,3), ratings_val(:,3), IndThresh);
    fprintf('Force Sensitivity: ');
    check_err(pred_val(:,4), ratings_val(:,4), IndThresh);
    fprintf('Robotic Control: ');
    check_err(pred_val(:,5), ratings_val(:,5), IndThresh);
    
    for i = 1:5
        near(2,i) = mean(abs(pred(:,i)-ratings(:,i)) <= 1);
        exact(2,i) = mean(abs(pred(:,i)-ratings(:,i)) == 0); 
        
        near_val(2,i) = mean(abs(pred_val(:,i)-ratings_val(:,i)) <= 1);
        exact_val(2,i) = mean(abs(pred_val(:,i)-ratings_val(:,i)) == 0); 
    end
    
    figure(5)
    subplot(221);bar(near')
    subplot(223);bar(exact')
    subplot(222);bar(near_val')
    subplot(224);bar(exact_val')

end
  

%     for i = 1:5
%         scoreTrain1{i} = ratings(:,1)==i;
%         scoreTrain2{i} = ratings(:,2)==i;
%         scoreTrain3{i} = ratings(:,3)==i;
%         scoreTrain4{i} = ratings(:,4)==i;
%         scoreTrain5{i} = ratings(:,5)==i;
% 
%         predTrain1{i} = pred(scoreTrain1{i},1);
%         predTrain2{i} = pred(scoreTrain2{i},2);
%         predTrain3{i} = pred(scoreTrain3{i},3);
%         predTrain4{i} = pred(scoreTrain4{i},4);
%         predTrain5{i} = pred(scoreTrain5{i},5);
% 
%         muTrain1 = cellfun(@mean,predTrain1);
%         muTrain2 = cellfun(@mean,predTrain2);
%         muTrain3 = cellfun(@mean,predTrain3);
%         muTrain4 = cellfun(@mean,predTrain4);
%         muTrain5 = cellfun(@mean,predTrain5);
% 
%         sigTrain1 = cellfun(@std,predTrain1);
%         sigTrain2 = cellfun(@std,predTrain2);
%         sigTrain3 = cellfun(@std,predTrain3);
%         sigTrain4 = cellfun(@std,predTrain4);
%         sigTrain5 = cellfun(@std,predTrain5);
%         
%         scoreTest1{i} = ratings_val(:,1)==i;
%         scoreTest2{i} = ratings_val(:,2)==i;
%         scoreTest3{i} = ratings_val(:,3)==i;
%         scoreTest4{i} = ratings_val(:,4)==i;
%         scoreTest5{i} = ratings_val(:,5)==i;
% 
%         predTest1{i} = pred(scoreTest1{i},1);
%         predTest2{i} = pred(scoreTest2{i},2);
%         predTest3{i} = pred(scoreTest3{i},3);
%         predTest4{i} = pred(scoreTest4{i},4);
%         predTest5{i} = pred(scoreTest5{i},5);
% 
%         muTest1 = cellfun(@mean,predTest1);
%         muTest2 = cellfun(@mean,predTest2);
%         muTest3 = cellfun(@mean,predTest3);
%         muTest4 = cellfun(@mean,predTest4);
%         muTest5 = cellfun(@mean,predTest5);
% 
%         sigTest1 = cellfun(@std,predTest1);
%         sigTest2 = cellfun(@std,predTest2);
%         sigTest3 = cellfun(@std,predTest3);
%         sigTest4 = cellfun(@std,predTest4);
%         sigTest5 = cellfun(@std,predTest5);
% 
%         figure(1);clf;
%         plot((0:5),(0:5),'k')
%         hold on
%         errorbar(muTrain1,sigTrain1,'Color','r')
%         errorbar(muTest1,sigTest1,'Color','b')
% 
%         figure(2);clf;
%         plot((0:5),(0:5),'k')
%         hold on
%         errorbar(muTrain2,sigTrain2,'Color','r')
%         errorbar(muTest2,sigTest2,'Color','b')
% 
%         figure(3);clf;
%         plot((0:5),(0:5),'k')
%         hold on
%         errorbar(muTrain3,sigTrain3,'Color','r')
%         errorbar(muTest3,sigTest3,'Color','b')
% 
%         figure(4);clf;
%         plot((0:5),(0:5),'k')
%         hold on
%         errorbar(muTrain4,sigTrain4,'Color','r')
%         errorbar(muTest4,sigTest4,'Color','b')
% 
%         figure(5);clf;
%         plot((0:5),(0:5),'k')
%         hold on
%         errorbar(muTrain5,sigTrain5,'Color','r')
%         errorbar(muTest5,sigTest5,'Color','b')
% 
%    
%         [predClass{i},classifScore] = models{i}.predict(feature_vector(:,maxIndex{i})); 
%         pred{i} = str2num(cell2mat(predClass{i}));
% 
%         [predClass_val{i},classifScore] = models{i}.predict(feature_vector_val(:,maxIndex{i})); 
%         pred_val{i} = str2num(cell2mat(predClass_val{i}));
% 
% 
%         figure(1)
%         plot_pred(cell2mat(pred), ratings);
%         figure(2)
%         plot_pred(cell2mat(pred_val), ratings_val);
%     
%     end