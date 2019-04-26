function [ patient_ID , patient_feature , feature_index ] = data_input9( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[1];
completionchoose=[1];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,2);
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=zeros(length(patient_n),1);
patient_ID_NEW=[patient_n,patient_t];
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{9}]];
end
end

