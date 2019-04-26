function [data, para] = attForward(data, para)

nBatch = para.nBatch;
fDim = size(data.x,2)/nBatch;

data.Z2 = para.W1*[data.x; ones(size(data.x(1,:)))];
data.A2 = sm(data.Z2);

data.Z3c = para.W2*[data.A2;ones(size(data.A2(1,:)))];
data.Z3 = reshape(data.Z3c,[fDim, nBatch]);

ex = exp(data.Z3 - ones(fDim,1)*max(data.Z3));
data.alpha = ex./(ones(fDim,1)*sum(ex));

