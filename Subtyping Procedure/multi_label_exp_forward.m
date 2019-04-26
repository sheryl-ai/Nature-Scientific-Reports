function [nmse,auc] = multi_label_exp_forward(model,testQueue)

n_test = length(testQueue);        
data_test =  [];
label_test = [];
for i_sample = 1:n_test
    data_test = [data_test;testQueue{i_sample}.x'];
    label_test = [label_test;testQueue{i_sample}.y'];
end
Mu = multi_label_exp_predict(data_test,label_test,model,task_type);
[nmse,auc] = eval_exp(label_test,Mu,task_type);

end