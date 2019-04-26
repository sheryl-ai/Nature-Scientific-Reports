clc;close all;clear;
%% load
load final_1_result
%% basic information
[uni,num,p] = unique_stat(idx_clustering);
disp('-------------------------------------------------')
for i = 1:length(uni)
disp(sprintf('number of patients in group %d = %d',uni(i),num(i))) 
end
disp('-------------------------------------------------')
for i = 1:length(uni)
disp(sprintf('mean age of patients in group %d = %.4f',i,mean(record_baseline_age(idx_clustering==i),1))) 
end
%% Hypothesis Testing: whether some feature are large only in one group?
tag_num = 15; %maximum number of features to show
tag_baseline = [];
[tag_baseline.big,tag_baseline.small] = tag_each_cluster(idx_clustering,record_baseline,tag_num,feature_name);
tag_pg_rate = [];
[tag_pg_rate.big,tag_pg_rate.small] = tag_each_cluster(idx_clustering,record_pg_rate,tag_num,target_name);
tag_baseline_target = [];
[tag_baseline_target.big,tag_baseline_target.small] = tag_each_cluster(idx_clustering,record_baseline_target,tag_num,target_name);
%% display
class_num = length(unique(idx_clustering));
disp(' ')
disp('******************************************************')
disp('Features at baseline: t = 0')
tmp =tag_baseline.big;  
for i = 1:class_num 
    disp(' ')
    disp('---------------------------')
    if isempty(tmp{i})|| isempty(tmp{i}) || ~isfield(tmp{i},'name')
        disp(sprintf('Group %d: no feature large only in group %d',i,i))   
        continue
    end
    disp(sprintf('Group %d: ',i))
    disp(sprintf('features that are large only in group %d',i))     
    disp(tmp{i}.name)
    disp(sprintf('mean values of features in group',i))
    disp(tmp{i}.value )
    disp('p value of each comparison:')
    disp(sprintf('\t%.2e',tmp{i}.pvalue) )
end
disp(' ')
disp('******************************************************')
disp('Targets at baseline: t = 0')
tmp =tag_baseline_target.big;
for i = 1:class_num 
    disp(' ')
    disp('---------------------------')
    if i>length(tmp) || isempty(tmp{i}) || ~isfield(tmp{i},'name')
        disp(sprintf('Group %d: no target that is large only in group %d',i,i))   
        continue
    end
    disp(sprintf('Group %d: ',i))
    disp(sprintf('targets large only in group %d: ',i))     
    disp(tmp{i}.name)
    disp(sprintf('mean values of targets in group',i))
    disp(tmp{i}.value )
    disp('p value of each comparison:')
    disp(sprintf('\t%.2e',tmp{i}.pvalue) )
end 
disp(' ') 
disp('******************************************************')
disp('Progression rate of target')
tmp =tag_pg_rate.big;
for i = 1:class_num 
    disp(' ')
    disp('---------------------------')
    if i>length(tmp) || isempty(tmp{i}) || ~isfield(tmp{i},'name')
        disp(sprintf('Group %d: no progression rate of target large only in group %d',i,i))   
        continue
    end
    disp(sprintf('Group %d: ',i))
    disp(sprintf('progression rates of targets that are large only in group %d: ',i))     
    disp(tmp{i}.name)
    disp(sprintf('mean values of progression rates of targets in group',i))
    disp(tmp{i}.value )
    disp('p value of each comparison:')
    disp(sprintf('\t%.2e',tmp{i}.pvalue) )
end

