function [modelB, model]= mean2Batch_LSTM_PPMI(modelB, model, seq)

len = size(seq,2);
 
 

modelB.areaLSTM.dWoigf = modelB.areaLSTM.dWoigf +  model.areaLSTM.dWoigf ./ len;
modelB.proMLP.dtheta0 = modelB.proMLP.dtheta0 +  model.proMLP.dtheta0 ./ len;