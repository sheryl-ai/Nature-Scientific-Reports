clc;clear;close all
%% decide the type of all the features coded in the Code_List.csv. Type: 1.binary  2.categorical 3.gaussian (countinous)
%% load
Y = readtable('Code_List.csv');
Y = Y{:,:};
Y = Y(:,1:end);
[n,m] = size(Y);
Y_1 = {};
Y_2 = {};
Y_3 = {};
Y_m = {};
name_1 = {};
name_2 = {};
name_3 = {};
name_m = {};
value_range_3 = {};
value_range_m = {};
value_range_3_code = {};
value_range_m_code = {};
flag_3 = [];
flag_m = [];
type_3 = [];
type_m = [];
it_1 = 1;
it_2 = 1;
it_3 = 1;
it_m = 1;
visited = zeros(n,1);
%% process
while sum(visited) < n    
idx = find(visited==0,1);
y = Y(idx,:);
visited(idx) = 1;    
for i = 2:n
   if visited(i)
       continue
   end
   if strcmp(Y{i,2},y{1,2}) && strcmp(Y{i,1},y{1,1})
       y = [y;Y(i,:)];
       visited(i) = 1;
   end
end
if size(y,1) == 1
   Y_1 = [Y_1;y];
   name_1{it_1} = y{1,2};
   it_1 = it_1 + 1;
elseif size(y,1) == 2
   Y_2 = [Y_2;y];
   name_2{it_2} = y{1,2};
   it_2 = it_2 + 1;
elseif size(y,1) == 3
   disp([sum(visited) numel(visited)])    
   Y_3 = [Y_3;y];
   name_3{it_3} = y{1,2};
   value_range_3{it_3} = y(:,4);
   value_range_3_code{it_3} = value_range_3{it_3};
   disp(y(:,4:5))
   type_3(it_3) = input('type: 1.binary  2.category 3.gaussian\n');
   flag_missing = input('need to code missing? 0:No  1:Yes\n');
   if flag_missing
       idx_nan = input('which should be coded as missing?\n');
       for i_nan = 1:length(idx_nan)
           j_nan = idx_nan(i_nan);
            value_range_3_code{it_3}{j_nan} = 'U';
       end
   end
   flag_abnormal = input('need to code abnormal? 0:No  1:Yes\n');
   if flag_abnormal
       idx_abn = input('which should be coded as abnormal?\n');
       for i_abn = 1:length(idx_abn)
           j_abn = idx_abn(i_abn);
            value_range_3_code{it_3}{j_abn} = 'N';
       end
   end
   flag_3= [flag_3;[flag_missing flag_abnormal]];
%    disp(value_range_3{it_3})
%    disp(value_range_3_code{it_3})
   it_3 = it_3 + 1;
else   
   disp([sum(visited) numel(visited)])    
   Y_m = [Y_m;y];
   name_m{it_m} = y{1,2};
   value_range_m{it_m} = y(:,4);
   value_range_m_code{it_m} = value_range_m{it_m};
   disp(y(:,4:5))
   type_m(it_m) = input('type: 1.binary  2.category 3.gaussian\n');
   flag_missing = input('need to code missing? 0:No  1:Yes\n');
   if flag_missing
       idx_nan = input('which should be coded as missing?\n');
       for i_nan = 1:length(idx_nan)
           j_nan = idx_nan(i_nan);
            value_range_m_code{it_m}{j_nan} = 'U';
       end
   end
   flag_abnormal = input('need to code abnormal? 0:No  1:Yes\n');
   if flag_abnormal
       idx_abn = input('which should be coded as abnormal?\n');
       for i_abn = 1:length(idx_abn)
           j_abn = idx_abn(i_abn);
            value_range_m_code{it_m}{j_abn} = 'N';
       end
   end   
   flag_m = [flag_m;[flag_missing flag_abnormal]];
%    disp(value_range_m{it_m})
%    disp(value_range_m_code{it_m})
   it_m = it_m + 1;
end
end   
save('data_PPMI_codelist.mat','Y_1','Y_2','Y_3','Y_m','name_1','name_2','name_3','name_m',...
    'value_range_3','value_range_3_code','value_range_m','value_range_m_code','flag_3','flag_m','type_3','type_m');