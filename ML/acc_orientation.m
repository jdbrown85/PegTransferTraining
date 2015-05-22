function [pitch, roll] = acc_orientation(acc1)

h  = fdesign.lowpass('Nb,Na,F3dB', 8, 8, 1, 100);
lp = design(h, 'butter');

accF = filtfilt(lp.sosMatrix,lp.ScaleValues, double(acc1(1:30:end,:)));
% accF = double(x.acc1(1:3:end,:));

accFn = accF./repmat(sqrt(sum(accF.^2,2)),1,3);

roll = atan2(accFn(:,2), accFn(:,3));
roll = filtfilt(lp.sosMatrix,lp.ScaleValues, double(roll));

pitch = atan2(-accFn(:,1), sqrt(sum(accFn(:,2:3).^2,2)));
pitch = filtfilt(lp.sosMatrix,lp.ScaleValues, double(pitch));