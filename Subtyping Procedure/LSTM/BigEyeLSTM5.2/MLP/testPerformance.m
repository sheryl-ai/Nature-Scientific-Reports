gpuDevice(3);

para.theta0 = gpuArray(single(rand(2000,2001)));
para.theta1 = gpuArray(single(rand(1000,2001)));

data.x = gpuArray(single(rand(2000,20)));
data.dJ_dy = data.y;

% test forward
while 1
    [data, para] = tanhForward2(data, para);
    [data, para] = tanhBackward2(data, para);
end


%%

nBatch = size(data.x,2);
[data.x;ones(1,nBatch)];

