function [data, para] = sigmoidForward2(data, para)

nBatch = size(data.x,2);

data.b1 = para.theta0*[data.x;ones(1,nBatch)];
data.y = sm(data.b1);