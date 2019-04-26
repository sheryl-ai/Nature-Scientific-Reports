function [data, para] = multiLabelForward(data, para)

nBatch = size(data.x,2);
data.l = para.theta0*[data.x;ones(1,nBatch)];
L = zeros(size(data.l));
Mu = zeros(size(data.l));
for type = 1:3
    idx = para.task_type == type;
    if sum(idx) == 0
        continue
    end    
    [L(idx,:)] = link_fun_simple(data.q_eq(idx,:),data.l(idx,:),para.w_pos,para.w_neg,type);    
    Mu(idx,:) = link_fun_mu_simple(data.l(idx,:),type);
end
data.y = Mu;
data.J = sum(L,1); 

if data.J == -inf
    disp('')
end
 