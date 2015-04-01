function [vector, ratings] = featureVector(feats)
    
    fFields = sort(fields(feats));
    featFields = fFields(~strcmpi(fFields, 'gears'));
    
    fieldCols = zeros(size(featFields));
    vecRows = length(feats);
    
    for i = 1:length(featFields) 
        fieldCols(i) = length(feats(1).(featFields{i}));
    end

    vector = zeros(vecRows, sum(fieldCols));

    col = 1;
    for i = 1:length(featFields)
        vector(:, col:col+fieldCols(i)-1) = [feats.(featFields{i})]';
        col = col+fieldCols(i);
    end
    
    ratings = [feats.gears]';
end