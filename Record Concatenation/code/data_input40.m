function [ patient_ID , patient_feature , feature_index ] = data_input40( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[8,9,10,13,15,16,17,18,19,20,21,22,24,25,26,27,28,29,30,31,32,33,35,36,38,42,44];
completionchoose=[2,0,0,0,0,0,0,0,2,1,2,0,0,2,1,0,0,2,1,0,2,0,2,0,2,0,0];
%%
[NUM,TXT,RAW]=xlsread(File);
%quantify
for n=1:length(NUM)
    %measurement unit transfer
    if isequal(RAW{n+1,39},'mg/dL')
    elseif isequal(RAW{n+1,39},'g/L')
        NUM(n,38)=NUM(n,38)*100;
    elseif isequal(RAW{n+1,39},'g/dL')
        NUM(n,38)=NUM(n,38)*1000;
    else
        NUM(n,38)=0/0;
    end
end
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
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{40}]];
end
end
