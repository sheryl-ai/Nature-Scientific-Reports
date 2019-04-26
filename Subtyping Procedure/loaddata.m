clc;clear;close all
 
%% load data
Y =  readtable('data.xlsx');
[n,m] = size(Y); 
load data_PPMI_codelist.mat
feature_part = xlsread('data_feature_partition.xlsx');
[~,feature_name] = xlsread('data_feature_name.xlsx');
%% process 
visited = ones(1,m); %0: features to be abandoned; 1:  features that do not need quantization, which may be countinous or count variable; 2: features that need quantization, but do not have 'N's or 'U's or are not of string type; 3: features features that need quantization, and have 'N's or 'U's or may be of string type
X = zeros(n,m); %data
Omega = ones(n,m); %observed entries
record_input_all =  cell(m); %value range of variables
record_output_all = cell(m); %value range of codes. All variables are coded to numerical values.
record_type = zeros(1,m); 
for j = 1:m
    %abandon some useless feature
    if ( ~(ismember(feature_name{j},name_2) || ismember(feature_name{j},name_3) || ismember(feature_name{j},name_m)) )  && feature_part(j) == 3
         visited(j) = 0;
         continue
    end    
    %abandon the feature with name of 'PAG_NAME' : I think it is useless
    if strcmp(feature_name{j},'PAG_NAME')
        visited(j) = 0;
        continue
    end    
    record_input = []; %value range of input variables
    record_output= []; %value range of output variables 
    %% features that do not need quantization, which may be gaussian or poisson
    if ~(ismember(feature_name{j},name_2) || ismember(feature_name{j},name_3) || ismember(feature_name{j},name_m))       
        visited(j) = 1;        
        a = table2array(Y(:,j));
        idx_nan = isnan(a);
        X(~idx_nan,j) = a(~idx_nan);
        Omega(idx_nan,j) = 0;
    end    
    %% features that need quantization
    if  (ismember(feature_name{j},name_2) || ismember(feature_name{j},name_3) || ismember(feature_name{j},name_m))            
        if ~iscell(Y{1,j}) %features that do not have 'N's or 'U's or are not of string type  ****************************************************************     
            visited(j) = 2;            
            a = table2array(Y(:,j));
            idx_nan = isnan(a);
            X(~idx_nan,j) = a(~idx_nan);
            Omega(idx_nan,j) = 0; 
            unique_value = unique(a(~idx_nan));
            if length(unique_value)<=1
                visited(j) = 0;
                continue
            end                  
            if ismember(feature_name{j},name_2) %features that are supposed to have 2 unique values 
                if length(unique_value)== 2
                    idx0 = a == unique_value(1);
                    idx1 = a == unique_value(2);
                    X(~idx_nan & idx0,j) = 0;
                    X(~idx_nan & idx1,j) = 1;                    
                    record_input = [unique_value(1) unique_value(2)];
                    record_output = [0 1];                    
                else
                    n_uni = length(unique_value);
                    num = zeros(n_uni,1);
                    for i_uni = 1:n_uni
                        num(i_uni) = sum(a == unique_value(i_uni));
                    end
                    [num,idx_ratio_uni] = sort(num,'descend');
                    idx0 = a == unique_value(idx_ratio_uni(1));
                    idx1 = a == unique_value(idx_ratio_uni(2));
                    X(~idx_nan & idx0,j) = 0;
                    X(~idx_nan & idx1,j) = 1;
                    idx_outlier = a ~= unique_value(idx_ratio_uni(1)) & a ~= unique_value(idx_ratio_uni(2)); % treat outlier as missing: I checked all the cases with outliers including cases below and I find that outlier records are rare, so can be treated as missing.
                    X(idx_outlier,j) = 0;
                    Omega(idx_outlier,j) = 0;                    
                    record_input = [unique_value(idx_ratio_uni)];
                    record_output = [0 1 NaN*ones(1,sum(idx_outlier))];                    
                end                
                record_type(j) = 1; %1.binary;2.category;3.gaussian     
            elseif ismember(feature_name{j},name_3)   %features that are supposed to have 3 unique values                   
                [~,loc] = ismember(feature_name{j},name_3);                
                cont = 1;flag_fix = 0; 
                if type_3(loc) == 1 %binary, code as 0 or 1
                    cont = 0; flag_fix = 1;
                elseif type_3(loc) == 2 %categorical, code as 1,2,...,number of value
                    cont = 1; flag_fix = 1;
                end
                record_type(j) = type_3(loc);                 
                record_input= [];
                record_output = [];
                for i_code = 1:3
                    flag_nan = 0;
                    if value_range_3_code{loc}{i_code} == 'U' %missing
                        output  = 0;
                        flag_nan = 1;
                    elseif value_range_3_code{loc}{i_code} == 'N'%abnormal
                        output  = -1;
                    else
                        if flag_fix
                           output = cont;
                           cont = cont + 1;
                        else
                           output = str2double(value_range_3_code{loc}{i_code});
                        end
                    end
                    input = str2double(value_range_3{loc}{i_code});
                    record_input = [record_input input];
                    if flag_nan
                        record_output = [record_output NaN];
                    else
                        record_output = [record_output output];
                    end                   
                    idx_tmp = a == input;
                    X(~idx_nan & idx_tmp,j) = output;
                    if flag_nan
                        Omega(idx_tmp,j) = 0;
                    end
                end                
                outlier = ismember(unique_value,record_input); %treat outlier value as missing                
                idx_outlier = find(outlier==0);                
                for i_outlier = 1:length(idx_outlier)
                   j_outlier = idx_outlier(i_outlier);
                   idx_tmp = a == unique_value(j_outlier);
                    X(~idx_nan & idx_tmp,j) = 0;
                    Omega(idx_tmp,j) = 0;
                end                             
            elseif ismember(feature_name{j},name_m)%features that are supposed to have more than 3 unique values                    
                [~,loc] = ismember(feature_name{j},name_m);
                cont = 1;flag_fix = 0; 
                if type_m(loc) == 1  
                    cont = 0; flag_fix = 1;
                elseif type_m(loc) == 2  
                    cont = 1; flag_fix = 1;
                end                
                if strcmp(feature_name{j},'PRIMDIAG')
                    flag_fix = 0;
                end                
                record_type(j) = type_m(loc);                 
                record_input= [];
                record_output = [];
                for i_code = 1:length(value_range_m_code{loc})
                    flag_nan = 0;
                    if value_range_m_code{loc}{i_code} == 'U'
                        output  = 0;
                        flag_nan = 1;
                    elseif value_range_m_code{loc}{i_code} == 'N'
                        output  = -1;
                    else
                        if flag_fix
                           output = cont;
                           cont = cont + 1;
                        else
                            output = str2double(value_range_m_code{loc}{i_code});
                        end
                    end
                    input = str2double(value_range_m{loc}{i_code});
                    record_input = [record_input input];
                    if flag_nan
                        record_output = [record_output NaN];
                    else
                        record_output = [record_output output];
                    end                    
                    idx_tmp = a == input;
                    X(~idx_nan & idx_tmp,j) = output;
                    if flag_nan
                        Omega(idx_tmp,j) = 0;
                    end                        
                end                
                outlier = ismember(unique_value,record_input);
                idx_outlier = find(outlier==0);
                for i_outlier = 1:length(idx_outlier)
                   j_outlier = idx_outlier(i_outlier);
                   idx_tmp = a == unique_value(j_outlier);
                    X(~idx_nan & idx_tmp,j) = 0;
                    Omega(idx_tmp,j) = 0;
                end
            end
        else  %features that may have 'N's or 'U's or may be of string type ****************************************************************                
            visited(j) = 3; 
            a =  Y(:,j) ;
            idx_nan = ones(n,1);
            aa = cell(n,1);
            unique_value = {'start','end'};
            cont_uni = 1;
            for i = 1:n
                if ~strcmp(a{i,1}{1},'')
                    idx_nan(i) = 0;
                    aa{i} = a{i,1}{1};
                    
                    if cont_uni == 1
                        unique_value{cont_uni} = aa{i};
                        cont_uni = cont_uni+ 1;
                    elseif ~ismember(aa{i},unique_value)
                        unique_value{cont_uni} = aa{i};  
                        cont_uni = cont_uni+ 1;
                    end
                    
                end                    
            end
            idx_nan = idx_nan > 0;             
            idx_nan_num = find(idx_nan==0);
            Omega(idx_nan,j) = 0;             
            if isempty(idx_nan_num) || strcmp(feature_name{j},'DXYREST')
                visited(j) = 0;
                continue
            end                
            %features that are supposed to have 2 unique values
            if ismember(feature_name{j},name_2)
                for ii = 1:length(idx_nan_num)
                   i = idx_nan_num(ii);
                   if strcmp(aa{i},'n')|| strcmp(aa{i},'N')
                       X(i,j) = 0;
                       Omega(i,j) = 0; 
                   elseif strcmp(aa{i},'0')
                       X(i,j) = 0;
                   elseif strcmp(aa{i},'1')
                       X(i,j) = 1;
                   end
                end
                record_input = {0 1 'n'};
                record_output = [0 1 NaN];
                record_type(j) = 1;                
            %features that are supposed to have 3 unique values    
            elseif ismember(feature_name{j},name_3)  
                [~,loc] = ismember(feature_name{j},name_3); 
                cont = 1;flag_fix = 0; 
                if type_3(loc) == 1 
                    cont = 0; flag_fix = 1;
                elseif type_3(loc) == 2
                    cont = 1; flag_fix = 1;
                end
                record_type(j) = type_3(loc);                 
                record_input= {};
                record_output = [];
                for i_code = 1:3
                    flag_nan = 0;
                    if value_range_3_code{loc}{i_code} == 'U'
                        output  = 0;
                        flag_nan = 1;
                    elseif value_range_3_code{loc}{i_code} == 'N'
                        output  = -1;
                    else
                        if flag_fix
                           output = cont;
                           cont = cont + 1;
                        else
                           output = str2double(value_range_3_code{loc}{i_code});
                        end
                    end
                    input =  value_range_3{loc}{i_code} ;
                    record_input = [record_input input];
                    if flag_nan
                        record_output = [record_output NaN];
                    else
                        record_output = [record_output output];
                    end                   
                    for ii = 1:length(idx_nan_num)
                        i = idx_nan_num(ii);
                        if strcmp(aa{i},input)
                           X(i,j) = output;
                           if flag_nan
                                Omega(i,j) = 0; 
                           end                        
                        end
                    end                    
                end                
                outlier = zeros(length(unique_value),1);                
                for i_outlier = 1:length(unique_value)
                   if ismember(unique_value{i_outlier},record_input)
                       outlier(i_outlier) = 1;
                   end
                end                 
                idx_outlier = find(outlier==0);
                for i_outlier = 1:length(idx_outlier)
                   j_outlier = idx_outlier(i_outlier);
                   outlier_value =  unique_value{j_outlier};
                    for ii = 1:length(idx_nan_num)
                        i = idx_nan_num(ii);
                        if strcmp(aa{i},outlier_value)
                           X(i,j) = 0;
                           Omega(i,j) = 0;          
                        end
                    end
                end                                
            elseif ismember(feature_name{j},name_m)  %features that are supposed to have more than 3 unique values
                [~,loc] = ismember(feature_name{j},name_m);                
                cont = 1;flag_fix = 0; 
                if type_m(loc) == 1 
                    cont = 0; flag_fix = 1;
                elseif type_m(loc) == 2
                    cont = 1; flag_fix = 1;
                end
                record_type(j) = type_m(loc);                 
                record_input= {};
                record_output = [];
                for i_code = 1:length(value_range_m_code{loc})
                    flag_nan = 0;
                    if value_range_m_code{loc}{i_code} == 'U'
                        output  = 0;
                        flag_nan = 1;
                    elseif value_range_m_code{loc}{i_code} == 'N'
                        output  = -1;
                    else
                        if flag_fix
                           output = cont;
                           cont = cont + 1;
                        else
                           output = str2double(value_range_m_code{loc}{i_code});
                        end
                    end
                    input =  value_range_m{loc}{i_code} ;
                    record_input = [record_input input];
                    if flag_nan
                        record_output = [record_output NaN];
                    else
                        record_output = [record_output output];
                    end                   
                    for ii = 1:length(idx_nan_num)
                        i = idx_nan_num(ii);
                        if strcmp(aa{i},input)
                           X(i,j) = output;
                           if flag_nan
                                Omega(i,j) = 0; 
                           end                        
                        end
                    end                    
                end                
                outlier = zeros(length(unique_value),1);                
                for i_outlier = 1:length(unique_value)
                   if ismember(unique_value{i_outlier},record_input)
                       outlier(i_outlier) = 1;
                   end
                end                 
                idx_outlier = find(outlier==0);
                for i_outlier = 1:length(idx_outlier)
                   j_outlier = idx_outlier(i_outlier);
                   outlier_value =  unique_value{j_outlier};
                    for ii = 1:length(idx_nan_num)
                        i = idx_nan_num(ii);
                        if strcmp(aa{i},outlier_value)
                           X(i,j) = 0;
                           Omega(i,j) = 0;          
                        end
                    end
                end
            end            
        end
    end
    record_input_all{j} = record_input;
    record_output_all{j} = record_output; 
end
%% process age and gender
%age
idx_age = [];
for j = 1:m
   a = strfind(feature_name{j},'AGE_');
   if ~isempty(a)
       idx_age = [idx_age j];
%        disp(feature_name{j})
%        figure
%        hist(X(Omega(:,j)>0,j))
%        title(feature_name{j})
   end
end
x = X(:,idx_age);
omega = Omega(:,idx_age);
age = weighted_mode(x,omega); % I  use the weighted mode method to output the age data to abtain the minimum number of missing
Omega_age = double(age>0);
visited(idx_age) = 0;
%gender
idx_gender = [];
for j = 1:m
   a = strfind(feature_name{j},'GENDER');
   if ~isempty(a)
       idx_gender = [idx_gender j];
%        disp(feature_name{j})
%        figure
%        hist(X(Omega(:,j)>0,j))
%        title(feature_name{j})       
%        disp(record_input_all{j})
%        disp(record_output_all{j})       
   end
end
x = X(:,idx_gender);
gender = x(:,3); % the third GENDER has all three type and minimum number of missing (792)
Omega_gender = double(gender > 0);
visited(idx_gender) = 0;

%deleted feature
% for j = 1:m    
%    if visited(j)==0 
%        disp(feature_name{j})
%    end
% end
Y = X(:,3);
patno = X(:,1);
time = X(:,2);   
Omega_Y = Omega(:,3);
Omega_patno = Omega(:,1);
Omega_time = Omega(:,2);
visited([3 1 2]) = 0;
%% save
idx = visited > 0;
X = X(:,idx);
Omega_X = Omega(:,idx);
record_input  =  record_input_all(idx) ;
record_output = record_output_all(idx) ;
record_type = record_type(idx);
feature_name = feature_name(idx);
feature_classify = feature_part(idx);
visited = visited(idx);
save('data_PPMI.mat','X','Y','Omega_X','Omega_Y',...
    'patno','time','gender','age','Omega_patno','Omega_time','Omega_gender','Omega_age',...
    'record_input','record_output','record_type','feature_name','feature_classify','visited','-v7.3');