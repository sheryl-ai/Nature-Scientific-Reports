function [ dataPool,model] = modelBackward_LSTM_PPMI( dataPool,model)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
model.Js = model.Js + dataPool.proMLP.J;

[dataPool.proMLP, model.proMLP] = multiLabelBackward(dataPool.proMLP, model.proMLP);
model.proMLP.dtheta0 = model.proMLP.dtheta0 + model.proMLP.dJ_dtheta0;

dataPool.dJ_dwt_1 = dataPool.proMLP.dJ_dx(1:model.xSize);
dataPool.areaLSTM.dJ_dht = dataPool.proMLP.dJ_dx(model.xSize + 1:end);

dataPool.areaLSTM.dJ_dht = dataPool.areaLSTM.dJ_dht + dataPool.areaLSTM.dJ1_dht;
[dataPool.areaLSTM,model.areaLSTM] = LSTMBackward(dataPool.areaLSTM,model.areaLSTM);

model.areaLSTM.dWoigf = model.areaLSTM.dWoigf + model.areaLSTM.dJ_dWoigf; % accum

% dataPool.dJ_dwt_1 = dataPool.dJ_dwt_1 + dataPool.areaLSTM.dJ_dx(1:model.xSize);
% 
% dataPool.areaMatrix.dJ_dy = dataPool.dJ_dwt_1;
 

end