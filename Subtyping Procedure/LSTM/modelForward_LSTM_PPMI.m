function [ dataPool ] = modelForward_LSTM_PPMI( dataPool,model)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
% dataPool.areaMatrix.x = dataPool.yt_1;
% dataPool.areaMatrix.y = model.areaMatrix.theta0 * [dataPool.areaMatrix.x;1];
dataPool.wt_1 = dataPool.yt_1;

dataPool.areaLSTM.x = dataPool.wt_1;
[dataPool.areaLSTM, model.areaLSTM] = LSTMForward(dataPool.areaLSTM, model.areaLSTM);
dataPool.proMLP.x = [dataPool.areaLSTM.x*0;dataPool.areaLSTM.ht];
[dataPool.proMLP, model.proMLP] = multiLabelForward(dataPool.proMLP, model.proMLP);
dataPool.yt = dataPool.proMLP.y;

end

