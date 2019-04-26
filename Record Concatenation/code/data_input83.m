function [ patient_ID , patient_feature , feature_index ] = data_input83( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[7,8,9,10,11:16];
completionchoose=[2,1,2,0,ones(1,6)];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,18);
elseif timechoose==1
    patient_t=RAW(2:end,21);
else disp('input 0 or 1');
end
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{83}]];
end
end

