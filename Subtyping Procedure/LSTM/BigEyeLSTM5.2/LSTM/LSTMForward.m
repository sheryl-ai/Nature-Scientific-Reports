function [data, para] = LSTMForward(data, para)

nBatch = size(data.x,2);

data.v = [data.ht_1;data.x;ones(1,nBatch)];
data.u = para.Woigf*data.v;

n = size(data.ht_1,1);

data.ot0 = data.u(1:n,:);
data.it0 = data.u(n+1:2*n,:);
data.gt0 = data.u(2*n+1:3*n,:);
data.ft0 = data.u(3*n+1:4*n,:);

data.ot = sm(data.ot0);
data.it = sm(data.it0);
data.gt = th(data.gt0);
data.ft = sm(data.ft0);

data.Ct = data.gt.*data.it + data.Ct_1.*data.ft;
data.Ct_ = th(data.Ct);
data.ht = data.Ct_.* data.ot;