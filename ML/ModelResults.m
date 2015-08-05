function ModelResults(sqrt,log,pca,rounding,loocv,select)
    clc;
    clearvars -except sqrt log pca rounding loocv select

    filename = 'results';

    if sqrt
        filename = strcat(filename,'SQRT');
    end

    if log
        filename = strcat(filename,'Log');
    end

    if pca
        filename = strcat(filename,'PCA');
    end

    if rounding
        filename = strcat(filename,'Round');
    end

    if loocv
        filename = strcat(filename,'LOOCV');
    else
        filename = strcat(filename,'10Fold');
    end

    if select
        filename = strcat(filename,'Select');
    end

    load(strcat(filename,'.mat'));

    TotThresh = 3;
    fprintf('Total Err: \n');
    fprintf('Ensemble: ');
    check_err(pred, ratings, TotThresh);
    fprintf('SVR: ');
    check_err(pred1, ratings, TotThresh);
    fprintf('CVGLMNET: ');
    check_err(pred2, ratings, TotThresh);
    fprintf('Regression Tree: ');
    check_err(pred3, ratings, TotThresh);
    fprintf('KNN: ');
    check_err(pred4, ratings, TotThresh);

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
        scoreTrain1{i} = ratings(:,1)==i;
        scoreTrain2{i} = ratings(:,2)==i;
        scoreTrain3{i} = ratings(:,3)==i;
        scoreTrain4{i} = ratings(:,4)==i;
        scoreTrain5{i} = ratings(:,5)==i;

        predTrain1{i} = pred(scoreTrain1{i},1);
        predTrain2{i} = pred(scoreTrain2{i},2);
        predTrain3{i} = pred(scoreTrain3{i},3);
        predTrain4{i} = pred(scoreTrain4{i},4);
        predTrain5{i} = pred(scoreTrain5{i},5);

        muTrain1 = cellfun(@mean,predTrain1);
        muTrain2 = cellfun(@mean,predTrain2);
        muTrain3 = cellfun(@mean,predTrain3);
        muTrain4 = cellfun(@mean,predTrain4);
        muTrain5 = cellfun(@mean,predTrain5);

        sigTrain1 = cellfun(@std,predTrain1);
        sigTrain2 = cellfun(@std,predTrain2);
        sigTrain3 = cellfun(@std,predTrain3);
        sigTrain4 = cellfun(@std,predTrain4);
        sigTrain5 = cellfun(@std,predTrain5);
        
        scoreTest1{i} = ratings_val(:,1)==i;
        scoreTest2{i} = ratings_val(:,2)==i;
        scoreTest3{i} = ratings_val(:,3)==i;
        scoreTest4{i} = ratings_val(:,4)==i;
        scoreTest5{i} = ratings_val(:,5)==i;

        predTest1{i} = pred(scoreTest1{i},1);
        predTest2{i} = pred(scoreTest2{i},2);
        predTest3{i} = pred(scoreTest3{i},3);
        predTest4{i} = pred(scoreTest4{i},4);
        predTest5{i} = pred(scoreTest5{i},5);

        muTest1 = cellfun(@mean,predTest1);
        muTest2 = cellfun(@mean,predTest2);
        muTest3 = cellfun(@mean,predTest3);
        muTest4 = cellfun(@mean,predTest4);
        muTest5 = cellfun(@mean,predTest5);

        sigTest1 = cellfun(@std,predTest1);
        sigTest2 = cellfun(@std,predTest2);
        sigTest3 = cellfun(@std,predTest3);
        sigTest4 = cellfun(@std,predTest4);
        sigTest5 = cellfun(@std,predTest5);

        figure(1);clf;
        plot((0:5),(0:5),'k')
        hold on
        errorbar(muTrain1,sigTrain1,'Color','r')
        errorbar(muTest1,sigTest1,'Color','b')

        figure(2);clf;
        plot((0:5),(0:5),'k')
        hold on
        errorbar(muTrain2,sigTrain2,'Color','r')
        errorbar(muTest2,sigTest2,'Color','b')

        figure(3);clf;
        plot((0:5),(0:5),'k')
        hold on
        errorbar(muTrain3,sigTrain3,'Color','r')
        errorbar(muTest3,sigTest3,'Color','b')

        figure(4);clf;
        plot((0:5),(0:5),'k')
        hold on
        errorbar(muTrain4,sigTrain4,'Color','r')
        errorbar(muTest4,sigTest4,'Color','b')

        figure(5);clf;
        plot((0:5),(0:5),'k')
        hold on
        errorbar(muTrain5,sigTrain5,'Color','r')
        errorbar(muTest5,sigTest5,'Color','b')

    end
  end