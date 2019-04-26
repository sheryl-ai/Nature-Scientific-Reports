function [data, para] = tanhBackward(data, para)

nBatch = size(data.x,2);

data.dJ_db2 = data.dJ_dy.*(1-data.y.^2);

para.dJ_dtheta1 = data.dJ_db2*[data.d1;ones(1,nBatch)]'./nBatch;
data.dJ_dd1 = para.theta1(:,1:end-1)'*data.dJ_db2;

data.dJ_db1 = data.dJ_dd1.*(1-data.d1.^2);

para.dJ_dtheta0 = data.dJ_db1*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_db1;