clc;close all;clear;
%% Write down the mean values of significant features, targets and target progression rates of all the three groups
%% load
load final_1_result 
load record_end_target
n = length(trainQueue);
for i = 1:n
    trainQueue{i}.y = trainQueue{i}.y';
end
%% Features at baseline: t = 0  
[~,~,t] = xlsread('feature_baseline_name.xlsx');
report = cell(length(t),4); 
for j = 1:length(t)
    name = t{j};
    [flag,loc] = ismember(name,feature_name);
    if flag == 0
        [flag,loc] = ismember(name,target_name);
        report{j,1} = name;
        for i = 1:3
          report{j,1+i} = mean(record_baseline_target(idx_clustering==i,loc),1);
        end
    end
    report{j,1} = name;
    for i = 1:3
      report{j,1+i} = mean(record_baseline(idx_clustering==i,loc),1);
    end
end
xlswrite('feature_baseline_number.xls',report);
%% Targets at baseline: t = 0  
[~,~,t] = xlsread('target_baseline_name.xlsx');
report = cell(length(t),4); 
for j = 1:length(t)
    name = t{j};
    [flag,loc] = ismember(name,target_name);
    report{j,1} = name;    
    for i = 1:3
      report{j,1+i} = mean(record_baseline_target(idx_clustering==i,loc),1);
    end
end
xlswrite('target_baseline_number.xls',report);
%% Targets progression rate
[~,~,t] = xlsread('target_progression_name.xlsx');
report = cell(length(t),4); 
for j = 1:length(t)
    name = t{j};
    [flag,loc] = ismember(name,target_name);
    report{j,1} = name;
    for i = 1:3
      report{j,1+i} = mean(record_pg_rate(idx_clustering==i,loc),1);
    end
end
xlswrite('target_progression_number.xls',report);
%% Targets that have high progression rates at baseline: t = 0
[~,~,t] = xlsread('target_progression_name.xlsx');
report = cell(length(t),4); 
for j = 1:length(t)
    name = t{j};
    [flag,loc] = ismember(name,target_name);
    report{j,1} = name;
    for i = 1:3
      report{j,1+i} = mean(record_baseline_target(idx_clustering==i,loc),1);
    end
end
xlswrite('target_progression_baseline_number.xls',report);
%% Targets that have high progression rates at the end: t = end
[~,~,t] = xlsread('target_progression_name.xlsx');
report = cell(length(t),4); 
for j = 1:length(t)
    name = t{j};
    [flag,loc] = ismember(name,target_name);
    report{j,1} = name;
    for i = 1:3
      report{j,1+i} = mean(record_end_target(idx_clustering==i,loc),1);
    end
end
xlswrite('target_progression_end_number.xls',report);