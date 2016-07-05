data = STBData('SavedData', 'task', 2);
%%
% CreateFig
for i = 1:length(data)
    
%     data(i).plotForces
    if any(max(abs(data(i).moments)) > 1)
        fprintf(strcat('STB Data (',num2str(data(i).index),') Subject: ',num2str(data(i).subj_id),' Task: ', num2str(data(i).task_id),'\n'))
    end
%     data(i).plotMom
%     pause
%     cla
    
end
    