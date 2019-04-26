function [loss,nmse,auc,nmse_poiss,score_vec] = forword_LSTM_PPMI( trainQueue,model,opts)

y_record_all = [];
true_record_all = [];
totalJs=0;
[bld, model] = dataPoolInitial_LSTM(model,1);
x_record_all = [];

for j = 1:length(trainQueue)

    seq_x = trainQueue{j}.x;
    seq_y = trainQueue{j}.y;        

    y_record = [];
    x_record = [];
    J=0;

    bld.yt_1 = seq_x(:,1) ;    
    bld.areaLSTM.ht_1 = model.h0;
    bld.areaLSTM.Ct_1 = model.c0;
    bld.proMLP.q_eq = seq_y(:,1);
    bld = modelForward_LSTM_PPMI(bld, model);
    y_record = [y_record bld.proMLP.y];   
    J = J + bld.proMLP.J;


    for i = 2:size(seq_x,2)
        bld(i).yt_1 = seq_x(:,i) ; 
        bld(i).areaLSTM.ht_1 = bld(i - 1).areaLSTM.ht; % get
        bld(i).areaLSTM.Ct_1 = bld(i - 1).areaLSTM.Ct; % get
        bld(i).proMLP.q_eq = seq_y(:,i) ; 
        bld(i) = modelForward_LSTM_PPMI(bld(i), model);
        y_record = [y_record bld(i).proMLP.y];     
        J = J + bld(i).proMLP.J;
    end
    y_record_all = [y_record_all y_record];
    true_record_all = [true_record_all seq_y];
    
    totalJs =  totalJs +  J/size(seq_x,2);
    
    for i = size(seq_x,2):-1:1             
        if i>1                  
        bld(i) = [];
        end
    end
    
end

loss = totalJs/length(trainQueue);

[nmse,auc,nmse_poiss,score_vec] = eval_exp(true_record_all',y_record_all',opts.task_type);
disp(sprintf('loss = %.4f, nmse = %.4f, aAUC = %.4f, auc prime = %.4f', loss  , nmse,auc,score_vec(1)))


end