function [ patient_ID , patient_feature ] =p_merge( patient_ID , patient_ID_NEW , patient_feature , patient_feature_NEW)
%merge patient of different time
%% delete new patient
patient=unique(patient_ID(:,1));
SIZE=size(patient_feature);
SIZE2=size(patient_feature_NEW);
m=1;
p=[];
for n=1:length(patient_ID_NEW)
    if length(find(patient==patient_ID_NEW(n,1)))>0
        p(m)=n;m=m+1;
    end
end
patient_ID_NEW=patient_ID_NEW(p,:);
patient_feature_NEW=patient_feature_NEW(p,:);
%% merge
patient_ID1=[patient_ID;patient_ID_NEW];
patient_ID=unique(patient_ID1,'stable','rows');
[patient_ID,p_total]=sortrows(patient_ID);
patient_feature=[patient_feature;ones(length(patient_ID)-SIZE(1),SIZE(2))*0/0];
patient_feature=patient_feature(p_total,:);
%% add new features
patient_feature=[patient_feature,ones(length(patient_feature),SIZE2(2))*0/0];
for n=1:length(patient_feature_NEW)
        p=find(ismember(patient_ID,patient_ID_NEW(n,:),'rows')==1);
        patient_feature(p,(SIZE(2)+1):end)=patient_feature_NEW(n,:);
end
end

