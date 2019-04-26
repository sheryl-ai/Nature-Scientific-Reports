function [data, para] = attBackward(data, para)

nBatch = para.nBatch;
fDim = size(data.x,2)/nBatch;

data.dJ_dZ3 = (data.dJ_dalpha - ones(fDim,1)*sum(data.alpha.*data.dJ_dalpha)).*data.alpha;
data.dJ_dZ3c = reshape(data.dJ_dZ3, [1,numel(data.dJ_dZ3)]);

para.dJ_dW2 = data.dJ_dZ3c*[data.A2;ones(size(data.A2(1,:)))]'./nBatch;
data.dJ_dA2 = para.W2(:,1:end-1)'*data.dJ_dZ3c;

data.dJ_dZ2 = data.dJ_dA2.*data.A2.*(1-data.A2);

para.dJ_dW1 = data.dJ_dZ2*[data.x; ones(size(data.x(1,:)))]'./nBatch;
data.dJ_dx = para.W1(:,1:end-1)'*data.dJ_dZ2;




