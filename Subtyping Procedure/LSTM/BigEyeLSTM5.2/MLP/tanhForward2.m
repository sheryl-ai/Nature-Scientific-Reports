function [data, para] = tanhForward2(data, para)

nBatch = size(data.x,2);

data.b1 = para.theta0*[data.x;ones(1,nBatch)];
data.y = th(data.b1);