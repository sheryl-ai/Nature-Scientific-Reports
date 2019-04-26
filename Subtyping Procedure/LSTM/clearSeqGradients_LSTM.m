function [model] = clearSeqGradients_LSTM(model)

model.Js = 0;
 

model.areaLSTM.dWoigf = model.areaLSTM.Woigf .* 0;
model.proMLP.dtheta0 = model.proMLP.theta0 .* 0;