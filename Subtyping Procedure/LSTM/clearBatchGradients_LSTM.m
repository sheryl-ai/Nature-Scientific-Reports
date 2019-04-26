function modelB = clearBatchGradients_LSTM(model)

modelB = model;
 
modelB.areaLSTM.dWoigf = modelB.areaLSTM.Woigf .* 0;
modelB.proMLP.dtheta0 = modelB.proMLP.theta0 .* 0;