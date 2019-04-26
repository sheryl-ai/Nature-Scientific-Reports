function [ model ] = createModel_LSTM_PPMI( xSize,hSize,k,task_type, Y_binary )
model.hSize = hSize;
model.xSize = xSize;

%k 
model.K = k;
model.h0 = zeros(model.hSize,1);
model.c0 = zeros(model.hSize,1);
model.yt_1 = zeros(model.xSize,1);

init_coef = 1e-5;

model.areaLSTM.Woigf = init_coef*(rand(model.hSize * 4,model.xSize + model.hSize + 1) * 2 -1); 
%model.areaLSTM.Woigf(1:hSize,1:hSize) = model.areaLSTM.Woigf(1:hSize,1:hSize).*mat_mask;

%proMLP 
model.proMLP.theta0 = init_coef*(rand(k,model.xSize + model.hSize + 1) * 2 - 1);
model.proMLP.task_type = task_type;

n = size(Y_binary,2);
idx_pos = double(Y_binary==1);
idx_neg = double(Y_binary==0);
n_pos = sum(idx_pos,2);
n_neg = sum(idx_neg,2);
model.proMLP.w_pos = n./(2*n_pos);
model.proMLP.w_neg = n./(2*n_neg);

end