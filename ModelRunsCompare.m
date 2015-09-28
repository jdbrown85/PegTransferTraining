runs = {'2309150016','2309150047','2309151123','2309151220','2309151324'}

exact_reg = zeros(length(runs),5);
exact_class = zeros(length(runs),5);
near_reg = zeros(length(runs),5);
near_class = zeros(length(runs),5);

for i = 1:length(runs)
    
    [exact_reg(i,:),exact_class(i,:),near_reg(i,:),near_class(i,:)] = ModelResults(1,1,500,runs{i},0);
    
end

save(strcat('ModelRunsCompare',num2str(datestr(now, 'ddmmyyHHMM')),'.mat'),...
    'runs','exact_reg','exact_class','near_reg','near_class');
   

%%

exact_reg = exact_reg*100;
exact_clas = exact_class*100;
near_reg = near_reg*100;
near_class = near_class*100;

%%
mean(exact_reg)
mean(exact_class)
mean(near_reg)
mean(near_class)

std(exact_reg)
std(exact_class)
std(near_reg)
std(near_class)
