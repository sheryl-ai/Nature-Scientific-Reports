function [ patient_ID , patient_feature , feature_index ] = data_input( File , timechoose )
%读取数据，将病人ID(与时间有关)和初始的病人特征矩阵提取出来
%%
%%%%%%%%%%读取数据%%%%%%%%%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,9);
elseif timechoose==1
    patient_t=RAW(2:end,12);
else disp('请输入0或1');
end
patient_PRIMDIAG=NUM(:,7);
%%
%%%%%%%%%%时间数字化%%%%%%%%%%
patient_t=time2num(patient_t);
%%
%%%%%%%%%%将病人ID(与时间有关)提取出来%%%%%%%%%%
patient_ID0=[patient_n,patient_t];
patient_ID=unique(patient_ID0,'rows');
%%
%%%%%%%%%%将初始的病人特征矩阵提取出来%%%%%%%%%%
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
%%%%%%%%%%对缺失数据进行处理%%%%%%%%%%
del_row=[];
for n=1:length(patient_feature)%对缺失的数据进行处理
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
%%%%%%%%%%将特征列表写出来%%%%%%%%%%
feature_index{1,1}=RAW{1,7};
feature_index{2,1}=0;
feature_index{3,1}=0;
end

