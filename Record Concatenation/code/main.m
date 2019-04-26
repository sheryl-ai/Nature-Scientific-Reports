clc;clear all;close all;
%% initialization
clc;clear all;close all;
disp(['Step 0:Initialize'])
timechoose=0;%selected as time variable. 0: ORIG_ENTRY (original data entry);1: SITE_APRV (Date site approved the data)
FileNumber=84;
leastnum=400;%select the variables that includes observed values of at least 400 patients
%% load
tic;
hwait=waitbar(0,'wait...');
disp(['Step 1:Data Input'])
Path_working='..\';
File=[Path_working,'data\Primary_Diagnosis.csv'];
[patient_ID,patient_feature,feature_index]=data_input(File,timechoose);
patient_amount=length(unique(patient_ID(:,1)));
%% process
disp(['Step 2:feature data Input'])
%load tables
tables=[6,7,9,11,13,14,16,17,18,20,21,22,23,24,25,26,27,28,30,31,32,33,34,37,38,39,40,41,42,43,44,45,46,47,48,49,52,53,55,...
       61,62,63,64,65,66,67,68,71,73,75,81,82,83,84];
steps=length(tables);
for n=1:steps
    waitbar(n/steps,hwait,[num2str(floor(n/steps*100)),'% loading No.',num2str(n),' table (Table ',num2str(tables(n)),')']);
    File=[Path_working,'data\datanumber\',num2str(tables(n)),'.csv'];
    disp(['No. ',num2str(tables(n)),' table'])
    use_function=str2func(['data_input',num2str(tables(n))]);
    [patient_ID,patient_feature,feature_index]=use_function(File,timechoose,patient_ID,patient_feature,feature_index);
end
waitbar(1,hwait,['done']);pause(0.1);
close(hwait);
test=[patient_ID,patient_feature];
toc;
%% select the variables that includes observed values of at least 400 patients
feature_amount=length(feature_index);
[patient_NO,p]=unique(patient_ID(:,1));
p(end+1,1)=length(patient_feature)+1;
feature_pn0=zeros(1,length(feature_index));
feature_pn=ones(patient_amount,length(feature_index));
for n=1:patient_amount
    for L=p(n):p(n+1)-1
        nozeros=find(isnan(patient_feature(L,:))==0);
        feature_pn0(nozeros)=feature_pn0(nozeros)+1;
        feature_pn(n,nozeros)=feature_pn(n,nozeros)*0;
    end
end
feature_pn=patient_amount-sum(feature_pn);
badfeature=find(feature_pn<leastnum);
patient_feature(:,badfeature)=[];
feature_index(:,badfeature)=[];
%% save 
data=[patient_ID,patient_feature];
if timechoose==0
    time='ORIG_ENTRY';
elseif timechoose==1
    time='SITE_APRV';
end
feature_index=[[{'PATNO'},{time};{1},{1};{[]},{[]}],feature_index];
%% transfer into excel file
% transfer into cell 
f=cell2mat(feature_index(2,:));
f=find(f==3);
[nn,mm]=size(data);
data=mat2cell(data,ones(1,nn),ones(1,mm));
data=[feature_index;data];
% transfer the data into the form before quantization
qdata=data(:,f);
qdata=back_quantization(qdata);
data(:,f)=qdata;
% save
xlswrite('data.xlsx',data);
 
 