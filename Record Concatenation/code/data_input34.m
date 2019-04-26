function [ patient_ID , patient_feature , feature_index ] = data_input34( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[3,4];
completionchoose=[0,3];
%%
[NUM,TXT,RAW]=xlsread(File);
%quantify
for n=1:length(NUM)
    if isequal(RAW{n+1,4},'Yes')
       NUM(n,4)=1; 
    elseif isequal(RAW{n+1,4},'No')
        NUM(n,4)=0;
    elseif isequal(RAW{n+1,4},'NA')
        NUM(n,4)=2;
    else
        NUM(n,4)=0/0;
    end
end
%%%%%%%%%%%%%%
patient_n=NUM(:,1);
patient_t=RAW(2:end,2);
patient_feature_NEW=NUM(:,datanumber);
%%
patient_t=time2num(patient_t);
patient_ID_NEW=[patient_n,patient_t];
%%
[patient_ID, patient_feature]=p_merge(patient_ID,patient_ID_NEW,patient_feature,patient_feature_NEW);
%%
for n=1:length(datanumber)
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{34}]];
end
end

