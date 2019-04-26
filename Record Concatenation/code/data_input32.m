function [ patient_ID , patient_feature , feature_index ] = data_input32( File , timechoose , patient_ID ,patient_feature , feature_index)

%%
datanumber=[5,7:10,12,14,17:30,32];
completionchoose=[3,zeros(1,21)];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,34);
elseif timechoose==1
    patient_t=RAW(2:end,37);
else disp('input 0 or 1');
end
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
load PAG_NAME_code;
for n=1:length(patient_t)
    if isnan(RAW{n+1,1})~=1
        patient_feature_NEW(n,1)=find(ismember(PAG_NAME_code,RAW(n+1,5))==1);
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{32}]];
end
end

