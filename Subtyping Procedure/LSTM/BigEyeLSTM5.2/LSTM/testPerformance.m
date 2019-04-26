gpuDevice(3);

para.Woigf = gpuArray(single(rand(4000,3001)));

data.ht_1 = gpuArray(single(rand(1000,20)));
data.x = gpuArray(single(rand(2000,20)));
data.Ct_1 = gpuArray(single(rand(1000,20)));

data.dJ_dht = data.ht;
data.dJ1_dCt = data.dJ_dCt;

% test forward
while 1
    [data, para] = LSTMForward(data, para);
    [data, para] = LSTMBackward(data, para);
end


%%

nBatch = size(data.x,2);
[data.x;ones(1,nBatch)];

