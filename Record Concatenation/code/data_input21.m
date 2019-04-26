function [ patient_ID , patient_feature , feature_index ] = data_inpu21( File , timechoose , patient_ID ,patient_feature , feature_index)
%读取表21中的数据
%%
datanumber=[3,4,5,6];
completionchoose=[2,2,2,2];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,1);
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=zeros(length(patient_n),1);
patient_ID_NEW=[patient_n,patient_t];
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{21}]];
end
end

