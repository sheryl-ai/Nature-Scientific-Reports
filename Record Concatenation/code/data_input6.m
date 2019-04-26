function [ patient_ID , patient_feature , feature_index ] = data_input6( File , timechoose , patient_ID ,patient_feature , feature_index)
%%
datanumber=[7:36,38,39,40,41,42];
completionchoose=[zeros(1,30),0,0,1,0,2];
[last_ID,last_feature_num]=size(patient_feature);
%%
[NUM,TXT,RAW]=xlsread(File);
patient_n=NUM(:,3);
if timechoose==0
    patient_t=RAW(2:end,43);
elseif timechoose==1
    patient_t=RAW(2:end,46);
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
    feature_index=[feature_index,[RAW{1,datanumber(n)};{completionchoose(n)};{6}]];
end
%%
%%%%%%%%%%one hot%%%%%%%%%%
BJLOTCHOOSE=ones(length(patient_feature),1)*0/0;
BJLOT=ones(length(patient_feature),15)*0/0;
for n=1:length(patient_feature)
    if isnan(patient_feature(n,last_feature_num+1))~=1
       BJLOTCHOOSE(n)=1;
       BJLOT(n,:)=patient_feature(n,last_feature_num+[1:15]*2-1);
    elseif isnan(patient_feature(n,last_feature_num+2))~=1
       BJLOTCHOOSE(n)=0;
       BJLOT(n,:)=patient_feature(n,last_feature_num+[1:15]*2); 
    end
end
feature_index_NEW=[{'BJLOTCHOOSE'},{'BJLOT1/2'},{'BJLOT3/4'},{'BJLOT5/6'},{'BJLOT7/8'},{'BJLOT9/10'},{'BJLOT11/12'},{'BJLOT13/14'},{'BJLOT15/16'},{'BJLOT17/18'},{'BJLOT19/20'},{'BJLOT21/22'},{'BJLOT23/24'},{'BJLOT25/26'},{'BJLOT27/28'},{'BJLOT29/30'};{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0},{0};{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6},{6}];
patient_feature=[patient_feature(:,1:last_feature_num),BJLOTCHOOSE,BJLOT,patient_feature(:,last_feature_num+31:end)];
feature_index=[feature_index(:,1:last_feature_num),feature_index_NEW,feature_index(:,last_feature_num+31:end)];
