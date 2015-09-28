clear all; close all; clc; 

data = STBData('SavedData', 'task', 1, 'subject', 34);

file = data(2);

Acc(:,:,1)  = double(file.acc1);
Acc(:,:,2)  = double(file.acc2);
Acc(:,:,3)  = double(file.acc3);
Frc         = file.forces;
Plot_time   = file.plot_time;

AccX = [Acc(:,1,1),Acc(:,1,2),Acc(:,1,3)];
AccY = [Acc(:,2,1),Acc(:,2,2),Acc(:,2,3)];
AccZ = [Acc(:,3,1),Acc(:,3,2),Acc(:,3,3)];

FrcX = Frc(:,1);
FrcY = Frc(:,2);
FrcZ = Frc(:,3);

n = 4;
Ts = 1/3000;
Wn = 80*Ts/2;
[b,a] = butter(n,Wn,'low');
FrcX = filtfilt(b,a,double(FrcX));
FrcY = filtfilt(b,a,double(FrcY));
FrcZ = filtfilt(b,a,double(FrcZ));

% FrcY = sqrt(FrcXfilt.^2+FrcYfilt.^2);
% FrcX = FrcZfilt;

AccXzero = bsxfun(@minus, AccX, mean(AccX));
AccYzero = bsxfun(@minus, AccY, mean(AccY));
AccZzero = bsxfun(@minus, AccZ, mean(AccZ));

[Acc1Tot,trunc] = proj321_OA(AccXzero(:,1),AccYzero(:,1),AccZzero(:,1));
[Acc2Tot,trunc] = proj321_OA(AccXzero(:,2),AccYzero(:,2),AccZzero(:,2));
[Acc3Tot,trunc] = proj321_OA(AccXzero(:,3),AccYzero(:,3),AccZzero(:,3));

F1 = 100;
F2 = 750;
Fs = 3e3;
fHP = designfilt('bandpassfir','FilterOrder',20, ...
     'CutoffFrequency1',F1,'CutoffFrequency2',F2, ...
     'SampleRate',Fs);

acc1 = filtfilt(fHP,Acc1Tot)*9.81;
acc2 = filtfilt(fHP,Acc2Tot)*9.81;
acc3 = filtfilt(fHP,Acc3Tot)*9.81;

%%
width = 1;

h1=figure('Color',[1,1,1]);
fullscreen = get(0,'ScreenSize');
set(h1,'Position',[0 0 fullscreen(3) fullscreen(4)])
set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);

axes1 = axes('Parent',h1,'YTick',[floor(min(FrcX)) 0 ceil(max(FrcX))],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'OuterPosition',[0 5/6 1 1/6],...
    'FontSize',20);
xlim(axes1,[0 Plot_time(end)]); ylim(axes1,[floor(min(FrcX)) ceil(max(FrcX))])
hold(axes1,'all');

axes2 = axes('Parent',h1,'YTick',[floor(min(FrcY)) 0 ceil(max(FrcY))],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'OuterPosition',[0 4/6 1 1/6],...
    'FontSize',20);
xlim(axes2,[0 Plot_time(end)]); ylim(axes2,[floor(min(FrcY)) ceil(max(FrcY))])
hold(axes2,'all');

axes3 = axes('Parent',h1,'YTick',[floor(min(FrcZ)) 0 ceil(max(FrcZ))],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'OuterPosition',[0 3/6 1 1/6],...
    'FontSize',20);
xlim(axes3,[0 Plot_time(end)]); ylim(axes3,[floor(min(FrcZ)) ceil(max(FrcZ))])
hold(axes3,'all');

axes4 = axes('Parent',h1,'YTick',[floor(min(acc1)) 0 ceil(max(acc1))],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'OuterPosition',[0 2/6 1 1/6],...
    'FontSize',20);
xlim(axes4,[0 Plot_time(end)]); ylim(axes4,[floor(min(acc1)) ceil(max(acc1))])
hold(axes4,'all');

axes5 = axes('Parent',h1,'YTick',[floor(min(acc2)) 0 ceil(max(acc2))],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'OuterPosition',[0 1/6 1 1/6],...
    'FontSize',20);
xlim(axes5,[0 Plot_time(end)]); ylim(axes5,[floor(min(acc2)) ceil(max(acc2))]);
hold(axes5,'all');

axes6 = axes('Parent',h1,'YTick',[floor(min(acc3)) 0 ceil(max(acc3))],...
    'XTickLabel',{'0','','30','','60','','90','','120'},...
    'XTick',[0 15 30 45 60 75 90 105 120],...
    'OuterPosition',[0 0 1 1/6],...
    'FontSize',20);
xlim(axes6,[0 Plot_time(end)]); ylim(axes6,[floor(min(acc3)) ceil(max(acc3))])
% xlabel(axes4,'Time (s)')
hold(axes6,'all');

plot(Plot_time,FrcX,'Parent',axes1,'Color','b','LineStyle','-','Marker','none','LineWidth',width)
plot(Plot_time,FrcY,'Parent',axes2,'Color','b','LineStyle','-','Marker','none','LineWidth',width)
plot(Plot_time,FrcZ,'Parent',axes3,'Color','b','LineStyle','-','Marker','none','LineWidth',width)

plot(Plot_time(1:trunc),acc1,'Parent',axes4,'Color','b','LineStyle','-','Marker','none','LineWidth',width)
plot(Plot_time(1:trunc),acc2,'Parent',axes5,'Color','b','LineStyle','-','Marker','none','LineWidth',width)
plot(Plot_time(1:trunc),acc3,'Parent',axes6,'Color','b','LineStyle','-','Marker','none','LineWidth',width)

figure1 = 'RawFigs/STBSampDataPeg';
print(h1,'-depsc2',figure1); 


