function [ patient_ID , patient_feature , feature_index ] = data_input33( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[4,6,7,9,10];
completionchoose=[2,2,2,0,0];
%%
[NUM,TXT,RAW]=xlsread(File);
%quantify
for n=1:length(NUM)
    %measurement unit transfer
    if isequal(RAW{n+1,8},'MBq')
       NUM(n,7)=NUM(n,7)/37; 
    end    
    if isequal(RAW{n+1,10},'Yes')
       NUM(n,10)=1; 
    else
        NUM(n,10)=0;
    end
end
patient_n=NUM(:,1);
if timechoose==0
    patient_t=RAW(2:end,3);
elseif timechoose==1
    patient_t=RAW(2:end,5);
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
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{33}]];
end
end

