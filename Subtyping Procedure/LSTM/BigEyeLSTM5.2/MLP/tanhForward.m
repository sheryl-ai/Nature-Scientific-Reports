function [data, para] = tanhForward(data, para)

nBatch = size(data.x,2);

data.b1 = para.theta0*[data.x;ones(1,nBatch)];
data.d1 = th(data.b1);

data.b2 = para.theta1*[data.d1;ones(1,nBatch)];
data.y = th(data.b2);