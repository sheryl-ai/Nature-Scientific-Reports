function [data, para] = embdForward(data, para)

nBatch = size(data.x,2);

data.y = para.theta0*[data.x;ones(1,nBatch)];