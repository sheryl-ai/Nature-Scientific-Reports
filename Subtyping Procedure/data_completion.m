clc;clear;close all

%% load
load data_PPMI
[n,d] = size(X);
sample_selection = ones(n,1); % select records that associated primary diagnosis == 1 or 17
sample_selection(time==0) = 0; 
uni_patno = unique(patno); % unique value of patient number (patno)
n_patient = length(uni_patno );
uni_y_num = zeros(n_patient,1);
age_start = zeros(n_patient,1); % age when patients participate into the data-set
age_span = zeros(n_patient,1); % age spanned over of the patients
gender_start = zeros(n_patient,1); % gender when patients participate into the data-set
gender_change = zeros(n_patient,1); % times that gender of patients has changed
avg_age_start = 61; %this value is estimated by the following procedure
cont = 0;
for i_pat = 1:n_patient    
    disp( [ i_pat n_patient])    
    id = uni_patno(i_pat);
    idx = find(patno==id);     
    y = Y(idx);
    omega_y = Omega_Y(idx);
    y = y(omega_y>0);    
    %fill missing entries in y       
    [Y(idx),Omega_Y(idx)] = comp_sub(Y(idx),Omega_Y(idx));     
    uni_y = unique(y);    
    uni_y_num(i_pat) = length(uni_y);    
    if ~(uni_y_num(i_pat)==1 && (uni_y==1||uni_y==17))
        sample_selection(idx) = 0;
        cont = cont  + 1;
    end
    %fill missing entries in x
    x = X(idx,:);    
    x_omega = Omega_X(idx,:);    
    for j = 1:d
        [x(:,j),x_omega(:,j)] = comp_sub(x(:,j),x_omega(:,j));            
    end
    X(idx,:) = x;
    Omega_X(idx,:) = x_omega;    
    %fill gender
    [gender(idx),Omega_gender(idx),gender_start(i_pat)] = comp_sub(gender(idx),Omega_gender(idx));
    gender_span(i_pat) = length(unique(gender(idx)));    
    %fill age     
    [age(idx),Omega_age(idx),age_start(i_pat),last] = comp_sub_age(age(idx),Omega_age(idx),time(idx),avg_age_start);
    age_span(i_pat) = last - age_start(i_pat); 
end
% avg_age_start = round(mean( age_start(age_start>0)));

%identify integer feature
flag_int = zeros(d,1);
uni_x_num = zeros(d,1);
for j = 1:d
   if visited(j)~=1
       continue
   end  
   x=X(:,j);
   x_omega = Omega_X(:,j);   
   uni_x = unique(x(x_omega>0));
   n_uni = length(uni_x);   
   flag = zeros(n_uni,1);
   for i_uni = 1:n_uni
      uni = uni_x(i_uni);
      if mod(uni,1) == 0
          flag(i_uni) = 1;
      end
   end
   if sum(flag) == n_uni
       flag_int(j) = 1;    
   end   
end
%sample selection
idx  = sample_selection>0;
X = X(idx,:);
Y = Y(idx);
patno = patno(idx);
time = time(idx);
age = age(idx);
gender = gender(idx);
Omega_X = Omega_X(idx,:);
Omega_Y = Omega_Y(idx);
Omega_patno = Omega_patno(idx);
Omega_time = Omega_time(idx);
Omega_age = Omega_age(idx);
Omega_gender = Omega_gender(idx);
n = size(X,1);
%If all entries of one feature of a patient are missing, we used the mean value of all observed values of this feature across the entire population to impute
record_value_fill = zeros(1,d);
record_fill_flag = ones(1,d);
for j = 1:d
   idx_missing = Omega_X(:,j)==0;
   if sum(idx_missing) == 0
       record_fill_flag(j) = 0;
       continue
   end
   if visited(j)==1 
       if flag_int(j)     
           value_fill = round(mean(X(~idx_missing,j)));
           X(idx_missing,j) = value_fill;
           Omega_X(idx_missing,j) =1 ;
       else            
           value_fill = mean(X(~idx_missing,j));
           X(idx_missing,j) = value_fill;
           Omega_X(idx_missing,j) =1 ;
       end
   else      
       value_fill = mode(X(~idx_missing,j));
       X(idx_missing,j) = value_fill;
       Omega_X(idx_missing,j) =1 ;       
   end
   record_value_fill(j) = value_fill;
end
%convert abnormal
cont_abnormal_thresh = 100; % if the abnormal entries of some features are rare, treat them as missing, do not add new dummy variables
cont_abnormal = zeros(1,d);
for j = 1:d
    cont_abnormal(j) = sum(X(:,j)==-1);
    if cont_abnormal(j) > 0  && cont_abnormal(j) <= cont_abnormal_thresh  
        idx_abnormal = X(:,j)==-1;
        X(idx_abnormal,j) = record_value_fill(j);
    end
end
X_abnormal = [];
feature_name_abnormal = {};
for j = 1:d
    cont_abnormal(j) = sum(X(:,j)==-1);
    if cont_abnormal(j) > cont_abnormal_thresh  
        idx_abnormal = X(:,j)==-1;
        if record_value_fill(j) == -1
            x = X(:,j);
            [uni_x,p] = unique_stat(x);
            [~,idx_uni] = sort(p,'descend');
            record_value_fill(j) = uni_x(idx_uni(2));                
        end        
        x  = double(X(:,j)==-1);
        X_abnormal = [X_abnormal  x];
%         feature_name_abnormal = [feature_name_abnormal sprintf('%s___ABNORMAL',feature_name{j})];
        feature_name_abnormal = [feature_name_abnormal sprintf('%s',feature_name{j})];
        X(idx_abnormal,j) = record_value_fill(j);
    end
end 
%categorical variables transfered to one hot variables
X_category = [];
feature_name_category = {};
for j = 1:d
     if record_type(j) == 2         
        x = full(sparse([1:n]',X(:,j),1)); 
        X_category = [X_category x];
        for jj = 1:size(x,2)
%              feature_name_category = [feature_name_category sprintf('%s___CATEGORICAL_%d',feature_name{j},jj)];
             feature_name_category = [feature_name_category sprintf('%s',feature_name{j},jj)];
        end
     end
end
feature_quant_flag = visited > 1;
idx = record_type ~= 2;
X = X(:,idx);
record_type = record_type(idx);
feature_name = feature_name(idx);
feature_quant_flag = feature_quant_flag(idx); 
%primary diagnosis of patients
unique_patno = unique(patno);
n_patient = length(unique_patno );
record_num_each_patient = zeros(n_patient,1);
y_patient = zeros(n_patient,1);
for i_pat = 1:n_patient 
    id = unique_patno(i_pat);
    idx =  (patno==id);
    record_num_each_patient(i_pat) = sum(idx);
    y_patient(i_pat) = mode(Y(idx));     
end
save('data_PPMI_final_2class.mat','X','Y','feature_name','X_abnormal','feature_name_abnormal','X_category','feature_name_category',...
    'patno','time','gender','age','unique_patno','record_num_each_patient','y_patient',...
    'record_input','record_output','record_type','feature_name','feature_quant_flag','-v7.3');