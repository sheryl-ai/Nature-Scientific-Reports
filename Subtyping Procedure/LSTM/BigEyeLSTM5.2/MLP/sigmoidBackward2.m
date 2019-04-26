function [data, para] = sigmoidBackward2(data, para)

nBatch = size(data.x,2);

data.dJ_db1 = data.dJ_dy.*(1-data.y).*data.y;

para.dJ_dtheta0 = data.dJ_db1*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_db1;