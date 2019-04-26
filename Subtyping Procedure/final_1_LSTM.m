clc;close all;clear; 
%% load
load data_PPMI_multilabel  
Y(Y(:,1)==-1,1)=0;
[n,d] = size(X);
%% construct tranning data
uni_pat_no = unique_stat(patno);
n = length(uni_pat_no);
trainQueue = {}; %one element of queue corresponds to one patient
for i = 1:n
    idx = patno == uni_pat_no(i);
    trainQueue{i}.x = X(idx,:)';
    trainQueue{i}.y = Y(idx,:)';
end
%loss type of each label: 1 for squared loss, 2 for logistic loss
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
%hold out validation
trainQueue_save = trainQueue;
idx = randperm(n);          
train_ratio = 0.6;         %tranning : validation : testing = 6:2:2, patients in the validation set or testing set are not in the trainning set.
valid_ratio = 0.2;        
n_train = round(train_ratio *n);
n_valid = round(valid_ratio *n);
n_test = n - n_train - n_valid;
trainQueue = trainQueue_save(idx(1:n_train));idx_train = idx(1:n_train);idx(1:n_train) = [];
validQueue = trainQueue_save(idx(1:n_valid));idx_valid = idx(1:n_valid);idx(1:n_valid) = [];
testQueue = trainQueue_save(idx(1:n_test));idx_test = idx(1:n_test);idx(1:n_test) = [];
clear trainQueue_save
%options for LSTM
hSize = 32; %number of hidden units
xSize = d;  %feature dimension
opts.lambda = 1e-2; %L2 penalty
opts.flag_adadelta = 1; %optimization method: 1 for adadelta, 0 for SGD
opts.epsilon0 = 1e-6;   %learning rate
opts.miniBatch = 10;    %mini batch
opts.EPS = 1e-6;        
opts.task_type=task_type'; %loss type of each label: 1 for squared loss, 2 for logistic loss
opts.p_adadelta = 0.95;    %historical weights of adadelta
opts.maxIter = 1000;       %number of epoch 
opts.save_name = sprintf('PPMI_hSize_%d',hSize);
%% trainning
disp('train') 
[ model ] = createModel_LSTM_PPMI( xSize,hSize,m,task_type, Y_binary );
[ model ] = trainModel_LSTM_PPMI( trainQueue,validQueue,model,opts);
disp('test')
[loss,nmse,auc,nmse_poiss,score_vec] = forword_LSTM_PPMI( testQueue,model,opts); 