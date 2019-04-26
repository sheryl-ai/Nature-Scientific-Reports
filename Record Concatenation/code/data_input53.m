function [ patient_ID , patient_feature , feature_index ] = data_input53( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[7,9];
completionchoose=[zeros(1,18)];
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,10);
elseif timechoose==1
    patient_t=RAW(2:end,13);
else disp('input 0 or 1');
end
%%
patient_t=time2num(patient_t);
patient_ID_NEW0=[patient_n,patient_t];
%%
ACTVSPECNO=ones(length(NUM),1)*0/0;
for n=1:length(ACTVSPECNO)
    if isnan(RAW{n+1,8})~=1
       ACTVSPECNO(n)=length(find(RAW{n+1,8}==','))+1;
    end
end
patient_ID_NEW=unique(patient_ID_NEW0,'rows');
patient_feature_NEW0=[NUM(:,datanumber(1)),ACTVSPECNO,NUM(:,datanumber(2))];
patient_feature_NEW=ones(length(patient_ID_NEW),18)*0/0;
for n=1:length(NUM)
    for m=1:length(patient_ID_NEW)
        if isequal(patient_ID_NEW(m,:),patient_ID_NEW0(n,:))
            QUESTNO=NUM(n,6);
            patient_feature_NEW(m,QUESTNO*3-2:QUESTNO*3)=patient_feature_NEW0(n,:);
            break;
        end
    end
end
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
feature_index_NEW=[{'QUEST1ACTVOFT'},{'QUEST1ACTVSPEC'},{'QUEST1HRDAYFRQ'},{'QUEST2ACTVOFT'},{'QUEST2ACTVSPEC'},{'QUEST2HRDAYFRQ'},{'QUEST3ACTVOFT'},{'QUEST3ACTVSPEC'},{'QUEST3HRDAYFRQ'},{'QUEST4ACTVOFT'},{'QUEST4ACTVSPEC'},{'QUEST4HRDAYFRQ'},{'QUEST5ACTVOFT'},{'QUEST5ACTVSPEC'},{'QUEST5HRDAYFRQ'},{'QUEST6ACTVOFT'},{'QUEST6ACTVSPEC'},{'QUEST6HRDAYFRQ'}];
for n=1:length(feature_index_NEW)
    feature_index=[feature_index,[{feature_index_NEW{n}};{completionchoose(n)};{53}]];
end
end

