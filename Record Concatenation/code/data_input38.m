function [ patient_ID , patient_feature , feature_index ] = data_input38( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[8,9,12,14,15,16,17,18,19,21,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,52,53,54,55,56,57,58,59,60];
completionchoose=[2,0,0,2,2,0,0,0,2,0,2,2,0,0,2,2,0,0,0,2,0,2,0,0,2,2,0,0,0,2,0,2,0,2,1,1,2,1,1,2,1,1];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,48);
elseif timechoose==1
    patient_t=RAW(2:end,51);
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
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{38}]];
end
end

