clc; clear ;close all
load data_PPMI_final_2class 
feature_name = [feature_name feature_name_abnormal feature_name_category];
csv_list = dir('data/*.csv');
study_doc = {'Code_List.csv','Data_Dictionary.csv'};
flag_mat = zeros(length(csv_list),length(feature_name));
csv_list_name = {};
for i = 1:length(csv_list)    
    disp(i)
    tic   
    filename = csv_list(i).name;    
    csv_list_name{i} = filename;    
    if ismember(filename,study_doc)
        continue
    end    
    filename = sprintf('data/%s', filename);    
    [~,~,T] = xlsread(filename);    
    field_name = T(1,:);    
    flag_mat(i,:) = ismember(feature_name,field_name);
    toc
end
save inverted_index_mat flag_mat csv_list_name