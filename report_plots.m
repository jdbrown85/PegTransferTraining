clearvars;
close all;
load results
addpath ML
addpath matlab2tikz/
mkdir('report_figures')
tikz = true;

tikz_options = {'height', '\figureheight', 'width', '\figurewidth', 'showInfo', false};
f1 = figure(1);clf;
plot_pred(pred, ratings)
f1.PaperUnits = 'inches';
f1.PaperPosition = [0 0 7 7];
f1.PaperPositionMode = 'manual';
print('report_figures/IndGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f1, 'filename', 'report_figures/IndGears.tikz', tikz_options{:});
end

f2 = figure(2);clf;
plot_pred(sum(pred,2), sum(ratings,2))
f2.PaperUnits = 'inches';
f2.PaperPosition = [0 0 7 5];
f2.PaperPositionMode = 'manual';
print('report_figures/TotalGears','-depsc')
drawnow;
if tikz
matlab2tikz('figurehandle', f2, 'filename', 'report_figures/TotalGears.tikz', tikz_options{:});
end

f3 = figure(3);clf;
plot_pred(pred_val, ratings_val)
f3.PaperUnits = 'inches';
f3.PaperPosition = [0 0 7 7];
f3.PaperPositionMode = 'manual';
print('report_figures/IndValGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f3, 'filename', 'report_figures/IndValGears.tikz', tikz_options{:});
end

f4 = figure(4);clf;
plot_pred(sum(pred_val,2), sum(ratings_val,2))
f4.PaperUnits = 'inches';
f4.PaperPosition = [0 0 7 5];
f4.PaperPositionMode = 'manual';
print('report_figures/TotalValGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f4, 'filename', 'report_figures/TotalValGears.tikz', tikz_options{:});
end

fprintf('Total Err: \n');
fprintf('Ensemble: ');
check_err(sum(pred,2), sum(ratings,2));
fprintf('SVR: ');
check_err(sum(pred1,2), sum(ratings,2));
fprintf('CVGLMNET: ');
check_err(sum(pred2,2), sum(ratings,2));
fprintf('Regression Tree: ');
check_err(sum(pred3,2), sum(ratings,2));
fprintf('KNN: ');
check_err(sum(pred4,2), sum(ratings,2));