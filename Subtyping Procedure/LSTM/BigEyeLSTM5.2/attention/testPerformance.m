gpuDevice(3);

para.W1 = gpuArray(single(rand(1000,1001)));
para.W2 = gpuArray(single(rand(1,1001)));

data.nBatch = 20;
data.x = gpuArray(single(rand(1000,data.nBatch*30)));
data.dJ_dalpha = data.alpha;

% test forward
while 1
    [data, para] = attForward(data, para);
    [data, para] = attBackward(data, para);
end


%%

nBatch = size(data.x,2);
[data.x;ones(1,nBatch)];

