function [ patient_ID , patient_feature , feature_index ] = data_input22( File , timechoose , patient_ID ,patient_feature , feature_index)

%%
datanumber=[7:14,16:19,21:26,28:32,34:38,40:45,47:60];
completionchoose=[zeros(1,42),3,0,0,3,3,3];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,61);
elseif timechoose==1
    patient_t=RAW(2:end,64);
else disp('input 0 or 1');
end
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
for n=1:length(NUM)
    if isequal(TXT{n+1,55},'N')
        patient_feature_NEW(n,43)=2;
    end
    if isequal(TXT{n+1,58},'N')
        patient_feature_NEW(n,46)=2;
    end
    if isequal(TXT{n+1,59},'N')
        patient_feature_NEW(n,47)=2;
    end
    if isequal(TXT{n+1,60},'n')
        patient_feature_NEW(n,48)=2;
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{22}]];
end
end

