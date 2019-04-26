function [dataPool, model] = dataPoolInitial_LSTM(model,flag_only_forward)
% load a blp to Initial
dataPool.areaLSTM.ht_1 = model.h0;
dataPool.areaLSTM.Ct_1 = model.c0;

dataPool.yt_1 = model.yt_1;
dataPool.proMLP.q_eq = rand(model.K,1);dataPool.proMLP.q_eq = dataPool.proMLP.q_eq./sum(dataPool.proMLP.q_eq);
dataPool.proMLP.q_neq = rand(model.K,1);dataPool.proMLP.q_neq = dataPool.proMLP.q_neq./sum(dataPool.proMLP.q_neq);

dataPool = modelForward_LSTM_PPMI(dataPool, model);

if ~flag_only_forward

model = clearSeqGradients_LSTM(model);
dataPool.areaLSTM.dJ1_dht = dataPool.areaLSTM.ht.*0; % get
dataPool.areaLSTM.dJ1_dCt = dataPool.areaLSTM.Ct.*0; % get
[dataPool, model] = modelBackward_LSTM_PPMI(dataPool, model);

end

end