function [ patient_ID , patient_feature , feature_index ] = data_input82( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[7,11,14];
completionchoose=[0,3,2];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,15);
elseif timechoose==1
    patient_t=RAW(2:end,18);
else disp('input 0 or 1');
end
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
for n=1:length(NUM)
    if isequal(TXT{n+1,11},'N')
        patient_feature_NEW(n,3)=2;
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{82}]];
end
end

