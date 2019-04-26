function [data, para] = multiLabelBackward(data, para)

nBatch = size(data.x,2);

err = zeros(size(data.q_eq));
for type = 1:3
    idx = para.task_type == type;
    if sum(idx) == 0
        continue
    end
    err(idx,:)  = grad_exp_simple(data.q_eq(idx,:),data.y(idx,:),para.w_pos,para.w_neg,type);
end

data.dJ_dl = err ;
 
para.dJ_dtheta0 = data.dJ_dl*[data.x;ones(1,nBatch)]'./nBatch;
data.dJ_dx = para.theta0(:,1:end-1)'*data.dJ_dl;