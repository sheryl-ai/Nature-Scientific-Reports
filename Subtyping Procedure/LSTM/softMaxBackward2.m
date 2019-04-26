function [data, para] = softMaxBackward2(data, para)

nBatch = size(data.x,2);

data.dJ_dl = data.q_eq - data.y ;
 
para.dJ_dtheta0 = data.dJ_dl*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_dl;