clearvars

x = STBData('SavedData', 'subject',3,'task',1);
x = x(1);
h  = fdesign.lowpass('Nb,Na,F3dB', 8, 8, 1, 100);
lp = design(h, 'butter');

accF = filtfilt(lp.sosMatrix,lp.ScaleValues, double(x.acc1(1:30:end,:)));
% accF = double(x.acc1(1:3:end,:));

accFn = accF./repmat(sqrt(sum(accF.^2,2)),1,3);

roll = atan2(accFn(:,2), accFn(:,3));
roll = filtfilt(lp.sosMatrix,lp.ScaleValues, double(roll));

pitch = atan2(-accFn(:,1), sqrt(sum(accFn(:,2:3).^2,2)));
pitch = filtfilt(lp.sosMatrix,lp.ScaleValues, double(pitch));

roll = roll(1:20:end);
pitch = pitch(1:20:end);
t = x.plot_time(1:600:end);
[X,Y,Z] = cylinder(8,25);
Z = Z*500 - 250;
cyl = [X(:) Y(:) Z(:) ones(size(Z(:)))];
figure
clf
axis([-300 300 -300 300 -300 300]);
axis vis3d
grid on
hold on
view(90,0)

cylPlot = surf(X,Y,Z);

for i = 1:length(roll)
    H = eye(4);
    H(1:3,1:3) = makeR('x', roll(i))*makeR('y', pitch(i));
    cylR = H*cyl';
    x = reshape(cylR(1,:),2,numel(cylR(1,:))/2);
    y = reshape(cylR(2,:),2,numel(cylR(1,:))/2);
    z = reshape(cylR(3,:),2,numel(cylR(1,:))/2);

    set(cylPlot, 'xdata', x, 'ydata', y, 'zdata', z);
    pause(0.05);
    t(i)
end
