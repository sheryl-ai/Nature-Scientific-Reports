gpuDevice(3);

para = blpNow.fw; para.theta0 = gpuArray(para.theta0);
data.x = gpuArray(single(rand(3000,20)));
data.q = gpuArray(single(zeros(1001,20)));

% test forward
while 1
    [data, para] = softMaxForward2(data, para);
    [data, para] = softMaxBackward2(data, para);
end

