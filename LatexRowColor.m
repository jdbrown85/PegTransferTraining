clear all; clc

for i = 1:5
    RegTime(:,:,i)  = rand(2,3)>.4;
    ClassTime(:,:,i) = rand(2,3)>.4;
end

data = RegTime;
row_names = {'Total','Active'};
% col_names = {'Raw','$\sqrt{}$','$\log$'};
col_names = {'DP','BD','E','FS','RC'};


col_name_str = '';
for j = 1:size(data,2)
    for k = 1:size(col_names,2)
        col_name_str = [col_name_str, sprintf('%s &',col_names{k})];
    end
end

col_name_str = [col_name_str(1:end-1), '\\ \hline \hline'];
fprintf(' & %s\n', col_name_str);

for i = 1:size(data,1)
    row_name = [row_names{i}];
    to_write = '';
    for k = 1:size(data,3)
        for j = 1:size(data,2)
            if RegTime(i,j,k) || ClassTime(i,j,k)
                to_write = [to_write,sprintf(' & b \\cellcolor[gray]{0.3}')];
%             elseif RegTime(i,j,k)
%                 to_write = [to_write,sprintf(' & r \\cellcolor[gray]{0.6}')];
%             elseif ClassTime(i,j,k)
%                 to_write = [to_write,sprintf(' & c\\cellcolor[gray]{0.9}')];
            else
                to_write = [to_write,sprintf(' & n ')];
            end
        end
    end
    to_write = [to_write, '\\ '];
    % fprintf(out_file, '%s%s\n', row_name, to_write);
    fprintf('%s%s\n', row_name, to_write);    
end
              
                