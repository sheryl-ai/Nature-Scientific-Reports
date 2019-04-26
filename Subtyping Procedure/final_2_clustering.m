clc;close all;clear;
%% load
load data_PPMI_multilabel 
Y(Y(:,1)==-1,1)=0;
m = size(Y,2);
task_type = ones(1,size(Y,2));
len_uni = zeros(1,m);
for i = 1:size(Y,2)
   unique_y = unique(Y(:,i));
   len_uni(i) = length(unique_y);
   if length(unique_y) == 2
       task_type(i) = 2;
   end
end
Y_binary = Y(:,task_type == 2)';
task_type = task_type';  
[n,d] = size(X);
uni_pat_no = unique_stat(patno);
n = length(uni_pat_no);
trainQueue = {};
y_pat = zeros(n,1);
record_baseline = [];
record_baseline_target = [];
record_end_target = [];
record_pg_rate = [];
record_pg_rate_x = [];
record_baseline_age = [];
record_baseline_gender = [];
record_gender_change = [];
record_age_span = [];
record_x_mean = [];
record_y_mean = [];
for i = 1:n
    idx = patno == uni_pat_no(i);
    Queue{i}.y = Y(idx,:);
    Queue{i}.time = timeTran(time(idx));
end
save Queue Queue
for i = 1:n
    idx = patno == uni_pat_no(i);
    trainQueue{i}.x = X(idx,:)';
    trainQueue{i}.y = Y(idx,:)';
    trainQueue{i}.time = time(idx);
    trainQueue{i}.age = age(idx);
    trainQueue{i}.gender = gender(idx,:);
    trainQueue{i}.baseline = trainQueue{i}.x(:,1)';
    trainQueue{i}.pg_rate = progression_rate(trainQueue{i}.time,trainQueue{i}.y');
    y_pat(i) = mode(Y(idx,1));    
    
    record_baseline = [record_baseline;trainQueue{i}.baseline];
    record_pg_rate = [record_pg_rate;trainQueue{i}.pg_rate];
    record_baseline_target = [record_baseline_target;trainQueue{i}.y(:,1)';];
    record_end_target = [record_end_target;trainQueue{i}.y(:,end)';];
    record_baseline_age = [record_baseline_age;trainQueue{i}.age(1)];
    [~,g] = max(trainQueue{i}.gender,[],2);
    record_baseline_gender = [record_baseline_gender;g(1)];
    record_gender_change = [record_gender_change;length(unique(g));];
    record_age_span = [record_age_span;trainQueue{i}.age(end) - trainQueue{i}.age(1)];
    record_x_mean = [record_x_mean;mean( trainQueue{i}.x',1)];
    record_y_mean = [record_y_mean;mean( trainQueue{i}.y',1)];
    record_pg_rate_x = [record_pg_rate_x;progression_rate(trainQueue{i}.time,trainQueue{i}.x');];
end
record_end_target = record_end_target(y_pat==1,:);
save record_end_target record_end_target
y = Y(:,1);

hSize = 32;
xSize = d;
opts.lambda = 1e-2;
opts.flag_adadelta = 1;
opts.epsilon0 = 1e-6;
opts.miniBatch = 10;
opts.EPS = 1e-6;
opts.task_type=task_type';
opts.p_adadelta = 0.95;
opts.maxIter = 1000;
load model_PPMI_hSize_32_NEW4

%% forward: embed features into hidden space
[loss,nmse,auc,nmse_poiss,score_vec,hQueue] = forword_LSTM_PPMI2( trainQueue ,model,opts);
%% Dynamic time warping 
w =4; % window width
X = [];
y_pat = [];
for i = 1:n
    y_pat(i) = hQueue{i}.y(1);
    X = [X;mean(hQueue{i}.x,1)];
end
dist = zeros(n);
for i = 1:n-1
    for j = i+1:n
        dist(i,j) =  dtw_c(hQueue{i}.x,hQueue{j}.x,w);
        dist(j,i) = dist(i,j);
    end
end
%% t-SNE: dimension reduction 
show_dim = 2;
c = tsne_d(dist, [], 8); %reduce dimension to 8 by t-SNE
c_save = c;
[u,c,sigma] = KLtran(c); %further reduce dimension to 2 or 3 by PCA
figure
hold on
if show_dim >= 3
h1 = plot3(c(y_pat==1,1),c(y_pat==1,2),c(y_pat==1,3),'*r');
h2 = plot3(c(y_pat==0,1),c(y_pat==0,2),c(y_pat==0,3),'*b');
else
h1 = plot(c(y_pat==1,1),c(y_pat==1,2),'*r');
h2 = plot(c(y_pat==0,1),c(y_pat==0,2),'*b');    
end
legend([h1 h2], 'PD', 'Control','Location','best')
c = c_save(y_pat==1,:);
 
%% clustering
eva_silhouette = evalclusters(c,'kmeans','silhouette','KList',[1:6]); %automatically decide K
[~,K] =max( eva_silhouette.CriterionValues);
idx_clustering = kmeans(c,K);
color_name = {'*r','*b','*g','*m','*k','*y','*c'};
[u,c,sigma] = KLtran(c);
figure
hold on
for i = 1:3
if show_dim >= 3
plot3(c(idx_clustering==i,1),c(idx_clustering==i,2),c(idx_clustering==i,3), color_name{i})
else
plot(c(idx_clustering==i,1),c(idx_clustering==i,2), color_name{i})  
end
end
title('PD clustering')
 
%% save 
 
trainQueue = trainQueue(find(y_pat==1));
record_baseline =  record_baseline(y_pat==1,:);
record_pg_rate = record_pg_rate(y_pat==1,:);
record_baseline_target = record_baseline_target(y_pat==1,:);
record_baseline_age = record_baseline_age(y_pat==1);
record_baseline_gender =  record_baseline_gender(y_pat==1,:);

save final_1_result idx_clustering  trainQueue record_baseline record_pg_rate feature_name feature_name_abnormal feature_name_category target_name record_baseline_target record_baseline_gender record_baseline_age c
 
