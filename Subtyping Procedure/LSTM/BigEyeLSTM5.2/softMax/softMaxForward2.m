function [data, para] = softMaxForward2(data, para)

nBatch = size(data.x,2);

data.l = para.theta0*[data.x;ones(1,nBatch)];

l0 = [data.l;zeros(1,nBatch)];
l1 = l0 - ones(size(l0,1),1)*max(l0);

ex = exp(l1);
data.y = ex./(ones(size(ex,1),1)*sum(ex)) + single(1e-40);

data.J = sum(data.q.*log(data.y));