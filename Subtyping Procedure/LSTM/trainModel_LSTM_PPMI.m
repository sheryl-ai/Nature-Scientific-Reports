function [ model ] = trainModel_LSTM_PPMI( trainQueue,validQueue,model,opts)
%UNTITLED6 Summary of this function goes here
%   trainQueue: 
%   model: 

%bld: 
[bld, model] = dataPoolInitial_LSTM(model,0);
modelB = clearBatchGradients_LSTM(model);
count = 0;
miniBatch = opts.miniBatch;
epsilon = opts.epsilon0 / miniBatch;
update_count = 0;
 
loss_best = -inf;

% tic
for a = 1:opts.maxIter
    totalJs = 0;
    idx = randperm(length(trainQueue));
    trainQueue = trainQueue(idx);
    
    y_record_all = [];
    true_record_all = [];
    for j = 1:length(trainQueue)
 
        seq_x = trainQueue{j}.x;
        seq_y = trainQueue{j}.y;        
 
        y_record = [];
        bld.yt_1 = seq_x(:,1) ;         
        bld.areaLSTM.ht_1 = model.h0;
        bld.areaLSTM.Ct_1 = model.c0;
        bld.proMLP.q_eq = seq_y(:,1);
        bld = modelForward_LSTM_PPMI(bld, model);
        y_record = [y_record bld.proMLP.y];   
         
        
        for i = 2:size(seq_x,2)
            bld(i).yt_1 = seq_x(:,i) ; 
            bld(i).areaLSTM.ht_1 = bld(i - 1).areaLSTM.ht; % get
            bld(i).areaLSTM.Ct_1 = bld(i - 1).areaLSTM.Ct; % get
            bld(i).proMLP.q_eq = seq_y(:,i) ; 
            bld(i) = modelForward_LSTM_PPMI(bld(i), model);
            y_record = [y_record bld(i).proMLP.y];            
        end
        y_record_all = [y_record_all y_record];
        true_record_all = [true_record_all seq_y];        
        %clear
        model = clearSeqGradients_LSTM(model);
        i = size(seq_x,2);
        bld(i).areaLSTM.dJ1_dht = bld(1).areaLSTM.ht.*0; % get
        bld(i).areaLSTM.dJ1_dCt = bld(1).areaLSTM.Ct.*0; % get
                 
        %BP
        for i = size(seq_x,2):-1:1
            [bld(i), model] = modelBackward_LSTM_PPMI(bld(i), model);
            % 
            if i>1
            bld(i-1).areaLSTM.dJ1_dht = bld(i).areaLSTM.dJ_dht_1; % get
            bld(i-1).areaLSTM.dJ1_dCt = bld(i).areaLSTM.dJ_dCt_1; % get              
            bld(i) = [];
            end
        end
          
        
        %modelB
        [modelB, model]= mean2Batch_LSTM_PPMI(modelB, model, seq_y);
        count = count + 1;
        if isnan(model.Js) == 1, disp('NaN'); pause; end
        
        if count == miniBatch
            %miniBatch
            update_count = update_count + 1;
            if update_count == 1
                model_E_g_2 = [];          
                model_E_g_2.areaLSTM.Woigf = model.areaLSTM.dWoigf .*0 ;
                model_E_g_2.proMLP.theta0 =   model.proMLP.dtheta0.*0;
                model_E_dx_2 = [];          
                model_E_dx_2.areaLSTM.Woigf = model.areaLSTM.dWoigf .*0 ;
                model_E_dx_2.proMLP.theta0 =   model.proMLP.dtheta0.*0;
            end
             
            [model,model_E_g_2,model_E_dx_2] = updateModel_LSTM( model,modelB,epsilon,model_E_g_2,model_E_dx_2, opts);
            modelB = clearBatchGradients_LSTM(model);
            count = 0;
        end
        totalJs =  totalJs +  model.Js/size(seq_x,2);
    end
    modelName = sprintf('model_%s.mat',opts.save_name); 
    [loss,nmse,auc,nmse_poiss,score_vec] = forword_LSTM_PPMI( validQueue,model,opts);
    if  auc-nmse>=loss_best
        loss_best = auc-nmse;
        save(modelName,'model','-v7.3');
    end
end

end

