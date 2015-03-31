clearvars

%% Loading Data

% Load all data stored in the SavedData folder into STBData array
data = STBData('SavedData');

% Load data for task #1
data = STBData('SavedData', 'task', 1);

% Load data for subject #3
data = STBData('SavedData', 'subject', 3);

% Load data for subject #3 doing task #1, optional arguments doesnt matter
data = STBData('SavedData', 'task', 1, 'subject', 3);

data = STBData('SavedData');
% Return array elements from subject #3
data.subject(3)

% Returns subject associated with that element
data(1).subject
data(1).subj_id

% Returns array elements for task #1
data.task(1)

% Can use both subject and task at same time (both of these work
data.subject(3).task(1)
data.task(1).subject(3)

% List methods associated with STBData
methods(data)

%% Plotting
clearvars
% Plot forces, moments, and accelerations
data(1).plotForces
% Can also give a range (same for all plotting functions)
data(1).plotForces([0 1])

% Plot moments
data(1).plotMoments

%Plot accelerometer data
data(1).plotAcc

%Plot single accelerometer
data(1).plotAcc(1)

%% Generating Surveys
clearvars;
% Load task #1 data
data = STBData('SavedData', 'task', 1);

% Generate 10-trial partitions for survey
part = make_xval_partition(numel(data), ceil(numel(data)/10));

% Generate surveys
for survey = unique(part)
    genSurvey(data(part == survey), sprintf('Survey%02d.txt', survey));
end