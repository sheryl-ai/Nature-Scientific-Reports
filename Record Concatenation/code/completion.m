function [ patient_feature  ] = completion( patient_ID , patient_feature , feature_index )
%将特征中的缺失部分补全
%%
%%%%%%%%%%数据提取%%%%%%%%%%
[patient_n,p_n]=unique(patient_ID(:,1),'stable');
patient_amount=length(patient_n);
[patient_ID_amount,feature_amount]=size(patient_feature);
%%
%%%%%%%%%%患者缺少时间的项给该患者其余缺值项赋值%%%%%%%%%%
for n=1:patient_amount
    if patient_ID(p_n(n),2)==0
end

%%
