function [ patient_ID , patient_feature , feature_index ] = data_input( File , timechoose )
%��ȡ���ݣ�������ID(��ʱ���й�)�ͳ�ʼ�Ĳ�������������ȡ����
%%
%%%%%%%%%%��ȡ����%%%%%%%%%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,9);
elseif timechoose==1
    patient_t=RAW(2:end,12);
else disp('������0��1');
end
patient_PRIMDIAG=NUM(:,7);
%%
%%%%%%%%%%ʱ�����ֻ�%%%%%%%%%%
patient_t=time2num(patient_t);
%%
%%%%%%%%%%������ID(��ʱ���й�)��ȡ����%%%%%%%%%%
patient_ID0=[patient_n,patient_t];
patient_ID=unique(patient_ID0,'rows');
%%
%%%%%%%%%%����ʼ�Ĳ�������������ȡ����%%%%%%%%%%
patient_feature=zeros(length(patient_ID),1);
for n=1:length(patient_ID0)
    for m=1:length(patient_ID)
        if isequal(patient_ID(m,:),patient_ID0(n,:))
           p=m;break;      
        end
    end
    patient_feature(m)=patient_PRIMDIAG(n);
end
%%
%%%%%%%%%%��ȱʧ���ݽ��д���%%%%%%%%%%
del_row=[];
for n=1:length(patient_feature)%��ȱʧ�����ݽ��д���
    if isnan(patient_feature(n))
        if patient_ID(n,1)==patient_ID(n-1,1)
           patient_feature(n)=patient_feature(n-1);
        elseif patient_ID(n,1)==patient_ID(n+1,1)
           patient_feature(n)=patient_feature(n+1);
        else 
           del_row=[del_row,n];
        end
    end
end
 patient_ID(del_row,:)=[];
 patient_feature(del_row,:)=[];
%%
%%%%%%%%%%�������б�д����%%%%%%%%%%
feature_index{1,1}=RAW{1,7};
feature_index{2,1}=0;
feature_index{3,1}=0;
end

