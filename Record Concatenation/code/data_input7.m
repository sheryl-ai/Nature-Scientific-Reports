function [ patient_ID , patient_feature , feature_index ] = data_input7( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[2];
completionchoose=[0];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,1);
patient_feature_NEW=RAW(2:end,datanumber);
%%
patient_t=zeros(length(patient_n),1);
patient_ID_NEW=[patient_n,patient_t];
for n=1:length(patient_feature_NEW)
    if isequal(patient_feature_NEW{n},'Male');
        patient_feature_NEW{n}=1;
    else
        patient_feature_NEW{n}=0;
    end
end
patient_feature_NEW=cell2mat(patient_feature_NEW);
[patient_ID_NEW,p]=unique(patient_ID_NEW,'rows');
patient_feature_NEW=patient_feature_NEW(p,:);
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{7}]];
end
%%
if timechoose==0 
    patient_t=RAW(2:end,9);
elseif timechoose==1
    patient_t=RAW(2:end,13);
else disp('input 0 or 1');
end
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
patient_feature_NEW=ones(length(patient_t),1)*0/0;
patient_DIAGNOSIS=RAW(2:end,3);
for n=1:length(patient_DIAGNOSIS)
    if isequal(patient_DIAGNOSIS{n},'Control')
        patient_feature_NEW(n)=17;
    elseif isequal(patient_DIAGNOSIS{n},'PD')
        patient_feature_NEW(n)=1;
    elseif isequal(patient_DIAGNOSIS{n},'SWEDD')
        patient_feature_NEW(n)=97;
    end
end
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
for n=1:length(patient_feature)
    if isnan(patient_feature(n,1))
        patient_feature(n,1)=patient_feature(n,end);
    end
end
patient_feature=patient_feature(:,1:end-1);

end

