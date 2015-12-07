x = [.12,.08,.04,.4,.04,.08,.08,.16]*8
h1=figure('Color',[1,1,1]);
fullscreen = get(0,'ScreenSize');
set(h1,'Position',[0 0 fullscreen(3) fullscreen(4)])
set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);

pie(x)

figure1 = 'RawFigs/STBDemoPie';
print(h1,'-depsc2',figure1); 