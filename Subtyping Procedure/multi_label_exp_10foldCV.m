function model = multi_label_exp_10foldCV(Queue,task_type,c_set)



n = length(Queue);
d = size(Queue{1}.x,2); 
m = size(Queue{1}.y,2); 
 
K = 10;
idx = crossvalind('Kfold',n,K);
 

record_aAUC = [];

record_score = [];

for i_c = 1:length(c_set)
    disp([i_c length(c_set)])
    param_c = c_set(i_c);
  
    record_out = [];
    record_test = [];
    for i_cv = 1:K
        
        idx_test = idx == i_cv;
        idx_train = ~idx_test;
        
        trainQueue = Queue(idx_train);
        n_train = length(trainQueue);        
        data_train =  [];
        label_train = [];
        for i_sample = 1:n_train
            data_train = [data_train;trainQueue{i_sample}.x'];
            label_train = [label_train;trainQueue{i_sample}.y'];
        end
       
       
        testQueue = Queue(idx_test);
        n_test = length(testQueue);        
        data_test =  [];
        label_test = [];
        for i_sample = 1:n_test
            data_test = [data_test;testQueue{i_sample}.x'];
            label_test = [label_test;testQueue{i_sample}.y'];
        end
 
    
        model = multi_label_exp(data_train,label_train,task_type,param_c*ones(1,2));
        Mu = multi_label_exp_predict(data_test,label_test,model,task_type);


        
       record_test = [record_test;label_test];
       record_out = [record_out;Mu ];
    end
     
    [nmse,auc] = eval_exp(record_test,record_out,task_type);
    
%     auc = auc - nmse;
    
    record_score = [record_score;[nmse,auc]];
   
   disp([nmse,auc])
   
   record_aAUC(i_c) =  (auc);
   
end

figure;plot(record_score(:,1))
figure;plot(record_score(:,2))

[nmse,idx_1] = min(record_score(:,1));
[auc,idx_2] = max(record_score(:,2));
 
disp([nmse auc])
n_train = length(Queue);
data_train =  [];
label_train = [];
for i_sample = 1:n_train
    data_train = [data_train;Queue{i_sample}.x'];
    label_train = [label_train;Queue{i_sample}.y'];
end
model = multi_label_exp(data_train,label_train,task_type,c_set([idx_1 idx_2]));

end