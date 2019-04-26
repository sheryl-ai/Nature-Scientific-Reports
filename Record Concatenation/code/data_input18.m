function [ patient_ID , patient_feature , feature_index ] = data_input18( File , timechoose , patient_ID ,patient_feature , feature_index)

%%
datanumber=[6,7,8,9,11];
completionchoose=[1,3,1,3,0];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,21);
elseif timechoose==1
    patient_t=RAW(2:end,24);
else disp('input 0 or 1');
end
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
load CONDCAT_code;
load DXYREST_code;
for n=1:length(patient_t)
    patient_feature_NEW(n,2)=find(ismember(CONDCAT_code,RAW(n+1,7))==1);
    if isnan(RAW{n+1,9})~=1
        patient_feature_NEW(n,4)=find(ismember(DXYREST_code,RAW(n+1,9))==1);
    end
    if NUM(n,8)>2016 || NUM(n,8)<1900
        NUM(n,8)=0/0;
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{18}]];
end
end

