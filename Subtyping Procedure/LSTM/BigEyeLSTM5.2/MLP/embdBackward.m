function [data, para] = embdBackward(data, para)

nBatch = size(data.x,2);

para.dJ_dtheta0 = data.dJ_dy*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_dy;