clearvars
load('results.mat')

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