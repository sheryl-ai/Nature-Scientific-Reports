function [data, para] = softMaxBackward2(data, para,flag_eq)

nBatch = size(data.x,2);

if flag_eq
    data.dJ_dl = data.q_eq(1:end-1,:) - data.y(1:end-1,:);
else
    data.dJ_dl = - data.q_neq(1:end-1,:) + data.y(1:end-1,:);
end


para.dJ_dtheta0 = data.dJ_dl*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_dl;