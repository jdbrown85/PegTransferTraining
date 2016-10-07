function [vector, ratings, index] = featureVector(feats)
    
    fFields = sort(fields(feats)); %sort features in alphabetical order
    featFields = fFields(~strcmpi(fFields, 'gears') & ~strcmpi(fFields, 'fam')); %remove GEARS and fam from feature set
    all_feats = cell(1, 277);
    
    fieldCols = zeros(size(featFields));  %create a vector of zeros the same size as list of features in featFields
    vecRows = length(feats); %variable that contains the number of actual features
    
    for i = 1:length(featFields) 
        fieldCols(i) = length(feats(1).(featFields{i})); % counts the number of observations of each feature
    end

    vector = zeros(vecRows, sum(fieldCols));
    index{sum(fieldCols)} = '';
    col = 1;
%     raw_features = {'data(t).forces(:,1)','data(t).forces(:,2)','data(t).forces(:,3)','fMag',...
%             'acc1','acc1H','acc1L','acc2','acc2H','acc2L','acc3','acc3H','acc3L',...
%             'accProd','fAcc1Prod','fAcc2Prod',...
%             'r1', 'p1', 'r2', 'p2', 'r3', 'p3', ...
%             'diff(r1)', 'diff(p1)', 'diff(r2)', 'diff(p2)', 'diff(r3)', 'diff(p3)'};

      raw_features = {'X Forces','Y Forces','Z Forces','Force Magnitude',...
            'Right Tool Vibration (mid-freq)','Right Tool Vibration (high-freq)','Right Tool Vibration (low-freq)',...
            'Camera Vibration (mid-freq)','Camera Vibration (high-freq)','Camera Vibration (low-freq)',...
            'Left Tool Vibration (mid-freq)','Left Tool Vibration (high-freq)','Left Tool Vibration (low-freq)',...
            'Product: Left and Right Tool Vibration (high-freq)','Product: Right Tool Vibration (high-freq) and Force Magnitude','Product: Left Tool Vibration (high-freq) and Force Magnitude',...
            'Product: Left and Right Tool Vibration (mid-freq)','Product: Right Tool Vibration (mid-freq) and Force Magnitude','Product: Left Tool Vibration (mid-freq) and Force Magnitude',...
            'Product: Left and Right Tool Vibration (low-freq)','Product: Right Tool Vibration (low-freq) and Force Magnitude','Product: Left Tool Vibration (low-freq) and Force Magnitude',...
            'Right Tool Roll Angle', 'Right Tool Pitch Angle',... 
            'Camera Roll Angle', 'Camera Pitch Angle',... 
            'Left Tool Roll Angle', 'Left Tool Pitch Angle', ...
            'Right Tool Roll Rate', 'Right Tool Pitch Rate',... 
            'Camera Roll Rate', 'Camera Pitch Rate',... 
            'Left Tool Roll Rate', 'Left Tool Pitch Rate'};
        
    counter = 1;
    for i = 1:length(featFields)
        if strcmp(featFields{i}, 'total_time')
            all_feats{1, counter} = featFields{i};
            counter = counter + 1;
           continue 
        end
        if strcmp(featFields{i}, 'time')
            all_feats{1, counter} = featFields{i};
            counter = counter + 1;
            continue
        end
        if strcmp(featFields{i}, 'sqrt_total_time')
            all_feats{1, counter} = featFields{i};
            counter = counter + 1;
            continue
        end
        if strcmp(featFields{i}, 'sqrt_time')
            all_feats{1, counter} = featFields{i};
            counter = counter + 1;
            continue
        end
        if strcmp(featFields{i}, 'log_total_time')
            all_feats{1, counter} = featFields{i};
            counter = counter + 1;
            continue
        end
        if strcmp(featFields{i}, 'log_time')
            all_feats{1, counter} = 'log_time';
            counter = counter + 1;
            continue
        end
        if strcmp(featFields{i}, 'gears')
            continue
        end
        for j = 1:34
            all_feats{1, counter} = strcat(featFields{i}, '_', raw_features{j});
            counter = counter + 1;
        end
    end
    for i = 1:length(featFields)
        vector(:, col:col+fieldCols(i)-1) = [feats.(featFields{i})]';
        for j = 0:fieldCols(i)-1
            index{col+j} = sprintf([featFields{i} ' %s'], raw_features{j+1});
        end
        col = col+fieldCols(i);
    end
    all_feats =  all_feats(~cellfun('isempty', all_feats));
    %save('feats.mat', 'all_feats', 'raw_features')
    ratings = [feats.gears]';
end