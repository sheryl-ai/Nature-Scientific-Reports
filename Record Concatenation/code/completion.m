function [ patient_feature  ] = completion( patient_ID , patient_feature , feature_index )
%�������е�ȱʧ���ֲ�ȫ
%%
%%%%%%%%%%������ȡ%%%%%%%%%%
[patient_n,p_n]=unique(patient_ID(:,1),'stable');
patient_amount=length(patient_n);
[patient_ID_amount,feature_amount]=size(patient_feature);
%%
%%%%%%%%%%����ȱ��ʱ�������û�������ȱֵ�ֵ%%%%%%%%%%
for n=1:patient_amount
    if patient_ID(p_n(n),2)==0
end

%%
