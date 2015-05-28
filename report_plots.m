clearvars;
close all;
load results
addpath ML
addpath matlab2tikz/

tikz = false;

tikz_options = {'height', '\figureheight', 'width', '\figurewidth', 'showInfo', false};
f1 = figure(1);clf;
plot_pred(pred, ratings)
f1.PaperUnits = 'inches';
f1.PaperPosition = [0 0 7 7];
f1.PaperPositionMode = 'manual';
print('IndGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f1, 'filename', 'IndGears.tikz', tikz_options{:});
end

f2 = figure(2);clf;
plot_pred(sum(pred,2), sum(ratings,2))
f2.PaperUnits = 'inches';
f2.PaperPosition = [0 0 7 5];
f2.PaperPositionMode = 'manual';
print('TotalGears','-depsc')
drawnow;
if tikz
matlab2tikz('figurehandle', f2, 'filename', 'TotalGears.tikz', tikz_options{:});
end

f3 = figure(3);clf;
plot_pred(pred_val, ratings_val)
f3.PaperUnits = 'inches';
f3.PaperPosition = [0 0 7 7];
f3.PaperPositionMode = 'manual';
print('IndValGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f3, 'filename', 'IndValGears.tikz', tikz_options{:});
end

f4 = figure(4);clf;
plot_pred(sum(pred_val,2), sum(ratings_val,2))
f4.PaperUnits = 'inches';
f4.PaperPosition = [0 0 7 5];
f4.PaperPositionMode = 'manual';
print('TotalValGears','-depsc')
drawnow;
if tikz
    matlab2tikz('figurehandle', f4, 'filename', 'TotalValGears.tikz', tikz_options{:});
end
