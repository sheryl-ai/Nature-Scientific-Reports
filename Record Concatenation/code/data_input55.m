function [ patient_ID , patient_feature , feature_index ] = data_input55( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[7,8,10,11,12,13,14,15,17];
completionchoose=[0,0,3,3,3,3,3,3,3];
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
for n=1:length(NUM)
    if isequal(TXT{n+1,10},'ACT')
        patient_feature_NEW(n,3)=2;
    elseif isequal(TXT{n+1,10},'DAY')
        patient_feature_NEW(n,3)=3;
    elseif isequal(TXT{n+1,10},'MD')
        patient_feature_NEW(n,3)=4;
    elseif isequal(TXT{n+1,10},'MON')
        patient_feature_NEW(n,3)=5;
    end
    if isequal(TXT{n+1,11},'U')
        patient_feature_NEW(n,4)=100;
    end
    if isequal(TXT{n+1,12},'U')
        patient_feature_NEW(n,5)=100;
    end
    if isequal(TXT{n+1,13},'U')
        patient_feature_NEW(n,6)=100;
    end
    if isequal(TXT{n+1,14},'U')
        patient_feature_NEW(n,7)=100;
    end
    if isequal(TXT{n+1,15},'U')
        patient_feature_NEW(n,8)=100;
    end
    if isequal(TXT{n+1,17},'u')
        patient_feature_NEW(n,9)=100;
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{55}]];
end
end

