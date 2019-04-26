function [ patient_ID , patient_feature , feature_index ] = data_input27( File , timechoose , patient_ID ,patient_feature , feature_index)

%%
datanumber=[7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41];
completionchoose=[zeros(1,18)];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,43);
elseif timechoose==1
    patient_t=RAW(2:end,46);
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
     feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{27}]];
end
end

