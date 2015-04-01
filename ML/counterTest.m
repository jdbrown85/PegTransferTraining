
thresh = 1000;
window = 200;
overlap = 0;
func = @(x)sum(x.^2);

[c, loc, winds] = counter(d, thresh, window, overlap, func);

windsPlot = repmat(winds, 1,window - overlap)';

figure(1);
clf;
[ax, h1, h2] = plotyy(1:numel(d),d,1:numel(windsPlot),windsPlot(:));
set(ax(1), 'ylim', max(d)*[-1.1 1.1]);
set(ax(2), 'ylim', max(winds)*[-1.1 1.1]);
hold(ax(1), 'on')
hold(ax(2), 'on')
plot(ax(2),xlim, thresh*[1 1], 'k--')
plot(ax(2),loc, thresh*ones(size(loc)), 'rx')